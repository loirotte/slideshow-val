# builtin text filters
# called before text_to_html
#
# use web filters for processing html/hypertext

module TextFilter

def directives_bang_style_to_percent_style( content )

  # for compatibility allow !SLIDE/!STYLE as an alternative to %slide/%style-directive
  
  bang_count = 0

  # get unparsed helpers e.g. SLIDE|STYLE  
  unparsed = config.helper_unparsed.map { |item| item.upcase }.join( '|' )                                                                   
  
  content.gsub!(/^!(#{unparsed})/) do |match|
    bang_count += 1
    "%#{$1.downcase}"
  end

  puts "  Patching !-directives (#{bang_count} #{config.helper_unparsed.join('/')}-directives)..."

  content
end

def directives_percent_style( content )

  directive_unparsed  = 0
  directive_expr      = 0
  directive_block_beg = 0
  directive_block_end = 0

  # process directives (plus skip %begin/%end comment-blocks)

  inside_block  = false
  inside_helper = false
  
  content2 = ""
  
  content.each_line do |line|
    if line =~ /^%([a-zA-Z][a-zA-Z0-9_]*)(.*)/
      directive = $1.downcase
      params    = $2

      logger.debug "processing %-directive: #{directive}"

      # slide, style
      if config.helper_unparsed.include?( directive )
        directive_unparsed += 1
        content2 << "<%= #{directive} '#{params ? params : ''}' %>"
      elsif config.helper_exprs.include?( directive )
        directive_expr += 1
        content2 << "<%= #{directive} #{params ? erb_simple_params(directive,params) : ''} %>"        
      elsif inside_helper && directive == 'end'
        inside_helper = false
        directive_block_end += 1
        content2 << "%>"        
      elsif inside_block && directive == 'end'
        inside_block = false
        directive_block_end += 1
        content2 << "<% end %>"
      elsif [ 'comment', 'comments', 'begin', 'end' ].include?( directive )  # skip begin/end comment blocks
        content2 << line
      elsif [ 'helper', 'helpers' ].include?( directive )
        inside_helper = true
        directive_block_beg += 1
        content2 << "<%"
      else
        inside_block = true
        directive_block_beg += 1
        content2 << "<% #{directive} #{params ? erb_simple_params(directive,params) : ''} do %>"
      end
    else
      content2 << line
    end
  end  
    
  puts "  Preparing %-directives (" +
      "#{directive_unparsed} #{config.helper_unparsed.join('/')} directives, " +
      "#{directive_expr} #{config.helper_exprs.join('/')} expr-directives, " +
      "#{directive_block_beg}/#{directive_block_end} block-directives)..."

  content2
end



def comments_percent_style( content )    
    
    # remove comments
    # % comments
    # %begin multiline comment
    # %end multiline comment

    # track statistics
    comments_multi  = 0
    comments_single = 0
    comments_end    = 0

    # remove multi-line comments
    content.gsub!(/^%(begin|comment|comments).*?%end/m) do |match|
      comments_multi += 1
      ""
    end
    
     # remove everyting starting w/ %end (note, can only be once in file) 
    content.sub!(/^%end.*/m) do |match|
      comments_end += 1
      ""
    end

    # hack/note: 
    #  note multi-line erb expressions/stmts might cause trouble
    #  
    #  %> gets escaped as special case (not treated as comment)
    # <%
    #   whatever
    # %> <!-- trouble here; would get removed as comment!
    #  todo: issue warning?
    
    # remove single-line comments    
    content.gsub!(/(^%$)|(^%[^>].*)/ ) do |match|
      comments_single += 1
      ""
    end
    
    puts "  Removing %-comments (#{comments_single} lines, " +
       "#{comments_multi} begin/end-blocks, #{comments_end} end-blocks)..."
    
    content    
  end

  def skip_end_directive( content )
    # codex-style __SKIP__, __END__ directive
    # ruby note: .*? is non-greedy (shortest-possible) regex match
    content.gsub!(/__SKIP__.*?__END__/m, '')
    content.sub!(/__END__.*/m, '')
    content
  end
  
  def erb_rename_helper_hack( content )
    # note: include is a ruby keyword; rename to s9_include so we can use it 
    
    rename_counter = 0
    
    # turn renames into something like:
    #   include|class   etc.
    renames = config.helper_renames.join( '|' )
    
    content.gsub!( /<%=[ \t]*(#{renames})/ ) do |match|
      rename_counter += 1
      "<%= s9_#{$1}" 
    end

    puts "  Patching embedded Ruby (erb) code for aliases (#{rename_counter} #{config.helper_renames.join('/')}-aliases)..."

    content
  end
  
  # allow plugins/helpers; process source (including header) using erb    
  def erb( content )
    puts "  Running embedded Ruby (erb) code/helpers..."
    
    content =  ERB.new( content ).result( binding() )
    content
  end

  def erb_simple_params( method, params )
    
    # replace params to support html like attributes e.g.
    #  plus add comma separator
    #
    #  class=part       -> :class => 'part'   
    #  3rd/tutorial     -> '3rd/tutorial'
    #  :css             -> :css
    
    return params   if params.nil? || params.strip.empty?

    params.strip!    
    ## todo: add ' and " for check??
    if params.include?( '=>' )
      puts "** warning: skipping patching of params for helper '#{method}'; already includes '=>':"
      puts "  #{params}"
      
      return params
    end
    
    before = params.clone
    
    # 1) string-ify values and keys (that is, wrap in '')
    params.gsub!( /[:a-zA-Z0-9][\w\/\-\.]*/) do |match|
      symbol = ( Regexp.last_match( 0 ).include?(':') )
      if symbol  # return symbols as is
        Regexp.last_match( 0 )
      else
        "'#{Regexp.last_match( 0 )}'"
      end
    end
    
    # 2) change = to =>
    params.gsub!( /[ \t]*=[ \t]*/, '=>' )
    
    # 3) symbol-ize hash keys 
    params.gsub!( /'(\w+)'=>/ ) do |match|
      ":#{$1}=>"
    end
    
    # 4) separate w/ commas
    params.gsub!( /[ \t]*(:\w+)=>/) do |match|
      ", #{$1}=>"
    end
    # remove possible leading comma
    params.sub!( /^[ \t]*,/, '' )
  
    puts "    Patching params for helper '#{method}' from '#{before}' to:"
    puts "      #{params}"  
       
    params    
  end


  def erb_django_simple_params( code )
    
    # split into method/directive and parms plus convert params
    code.sub!( /^[ \t]([\w.]+)(.*)/ ) do |match|
      directive = $1
      params    = $2
      
      "#{directive} #{params ? erb_simple_params(directive,params) : ''}"     
    end
    
    code
  end


  def erb_django_style( content )

    # replace expressions (support for single lines only)
    #  {{ expr }}  ->  <%= expr %>
    #  {% stmt %}  ->  <%  stmt %>   !! add in do if missing (for convenience)

    erb_expr = 0
    erb_stmt_beg = 0
    erb_stmt_end = 0

    content.gsub!( /\{\{([^{}\n]+?)\}\}/ ) do |match|
      erb_expr += 1
      "<%= #{erb_django_simple_params($1)} %>"
    end

    content.gsub!( /\{%[ \t]*end[ \t]*%\}/ ) do |match|
      erb_stmt_end += 1
      "<% end %>"
    end

    content.gsub!( /\{%([^%\n]+?)%\}/ ) do |match|
      erb_stmt_beg += 1
      "<% #{erb_django_simple_params($1)} do %>"
    end

    puts "  Patching embedded Ruby (erb) code Django-style (#{erb_expr} {{-expressions," +
       " #{erb_stmt_beg}/#{erb_stmt_end} {%-statements)..."
         
    content        
  end

  def code_block_curly_style( content )
    # replace {{{  w/ <pre class='code'>
    # replace }}}  w/ </pre>
    # use 4-6 { or } to escape back to literal value (e.g. {{{{ or {{{{{{ => {{{ )
    # note: {{{ / }}} are anchored to beginning of line ( spaces and tabs before {{{/}}}allowed )
    
    # track statistics
    code_begin     = 0
    code_begin_esc = 0
    code_end       = 0    
    code_end_esc   = 0    
        
    content.gsub!( /^[ \t]*(\{{3,6})/ ) do |match|
      escaped = ($1.length > 3)
      if escaped
        code_begin_esc += 1
        "{{{"
      else
        code_begin += 1
        "<pre class='code'>"
      end
    end    
    
    content.gsub!( /^[ \t]*(\}{3,6})/ ) do |match|
      escaped = ($1.length > 3)
      if escaped
        code_end_esc += 1
        "}}}"
      else
        code_end += 1
        "</pre>"      
      end
    end
        
    puts "  Patching {{{/}}}-code blocks (#{code_begin}/#{code_end} blocks, " +
         "#{code_begin_esc}/#{code_end_esc} escaped blocks)..."    
    
    content
  end

end # module TextFilter

class Slideshow::Gen
  include TextFilter
end