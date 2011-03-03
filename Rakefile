require 'rake/packagetask'
require 'rake/rdoctask'
require 'rake'
require 'find'

# Globals

PKG_NAME = 'slideshow-val'
PKG_VERSION = '0.9.9.1'

PKG_FILES = ['README.rdoc', 'History.rdoc', 'Rakefile']
Find.find('lib/', 'bin/', 'config/', 'site/', 'samples', 'templates/') do |f|
        if FileTest.directory?(f) and f =~ /\.git/
                Find.prune
        else
                PKG_FILES << f
        end
end

# Tasks

task :default => [:package]

Rake::RDocTask.new do |rd|
  f = []
  require 'find'
  Find.find('lib/') do |file|
    # Skip hidden files (.svn/ directories and Vim swapfiles)
    if file.split(/\//).last =~ /^\./
      Find.prune
    else
      f << file if not FileTest.directory?(file)
    end
  end
  rd.rdoc_files.include(f)
  rd.options << '--all'
end

Rake::PackageTask.new(PKG_NAME, PKG_VERSION) do |p|
        p.need_tar = true
        p.package_files = PKG_FILES
end

# "Gem" part of the Rakefile
begin
        require 'rake/gempackagetask'

        spec = Gem::Specification.new do |s|
                s.platform = Gem::Platform::RUBY
                s.summary = "Slide Show (S9) + ehanced support for g5syntax template"
                s.name = PKG_NAME
                s.version = PKG_VERSION
                s.requirements << 'RedCloth, 4.0.0 or greater'
                s.requirements << 'kramdown, 0.9.0 or greater'
                s.require_path = 'lib'
                s.author = 'Gerald Bauer, modified by Laurent Vallar'
                s.email = 'val@zbla.net'
                s.homepage = 'https://www.github.com/Val/slideshow-val/'
                s.rubyforge_project = 'slideshow-val'
                s.files = PKG_FILES
                s.licenses = [ 'Apache-2', 'GPL-2']
                s.executables = [ 'slideshow' ]
                s.description = "Slide Show (S9) - A Free Web Alternative to PowerPoint and KeyNote in Ruby - g5syntax support. Added ehanced support for Google HTML5Rocks! g5syntax template."
        end

        Rake::GemPackageTask.new(spec) do |pkg|
                pkg.need_zip = true
                pkg.need_tar = true
        end
rescue LoadError
end
