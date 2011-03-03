%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Some Headers
title: SlideShow (S9) g5syntax
subtitle: Advanced Google HTML5 template
abstract: Presentation made easy using <b>textile</b>...
author: Laurent Vallar <val@zbla.net>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Dynamic themes support 

_Google [HTML5rocks!](http://slides.html5rocks.com/)
presentation comes with some themes..._

<br />

## Currently available ones

* **default**, default [HTML5rocks!](http://slides.html5rocks.com/) theme
  (light gray blue)
* **moon**, light gray slides over white background with smooth transitions
* **sand**, antique white slides over brown background
* **sea wave**, white slides over cyan gradiant background 

<br />

> **Press <span class="key">T</span> to cycle between available themes.**

# In slide notes

This slide contains two formated texts: the slide one and the notes one...

> **Press <span class="key">N</span> to show/hide notes.**

<br />
<br />
Notes are visible in [printer view](test.pdf.html#in-slide-notes)

<div class='notes' markdown='1'>

* first point
* second point
* third one...

## Yes we can do formated text inside notes!

</div>

# Google Code Prettify usage

## Original vs. Prettier

<pre>
#!/bin/sh -e
read -s -p "Password: " passwd
echo
if [ -f "$0" ];then
  sleep 2
fi
echo "You typed '$passwd'"
</pre>

<pre>
#!/usr/bin/env ruby
require 'highline/import'
pass = ask("Password: ") do |q|
 q.echo = "●"
end
puts "Password is '#{pass}'."
</pre>

<br />

> **Press <span class="key">H</span> or <span class="key">B</span> to toggle
  syntax highlight.**

!TRANSITION z-section

## Transition slide

Level 2 title becomes transition slide title, but watch the following image...

![Z image](../Z.png "Z image")

# One page on "z-section"

Now see how previous transition slide image is repeated without any additional
code...

# Another page on "z-section"

## Be warned: the "logo" is a shadow of the original image

![Z image](../Z.png "Z image")
{: class='center'}

_(You need **kramdown** markdown parser to center this image, see
**slideshow.yml**)_

And bottom image/log can be reseted using a transition slide without any
image....

!TRANSITION y-section

## Transition slide without image

Only a subtitle, let's see what's happen on following pages...

# One page on "y-section"

There is no image at bottom of this page...

# Another page on "y-section"

... nor at this one too.

!TRANSITION

## Thanks for reading!

Now some junk...

# Markdown base syntax (1/4)

{% left %}
<pre>
# Markdown base syntax (1/4)
## Header#2
### Header#3

A _text_.
Another **text**, -all- in `Markdown`.
+Formula+: E=mc ^2^, Log ~2~ x

> A block quotation with `some code`.

1. *red*{: style="color: red"} color
1. __blue__{: style="color: blue"},
   `green`{: style="color:green"}

{:refdef0: align="left"}
align left
{: refdef0}

{:refdef1: align="right"}
align right
{: refdef1}

{:refdef2: align="center"}
centered
{: refdef2}

[Link](http://link/)

</pre>
{% end %}

{% right %}
## Header#2

### Header#3

A _text_.
Another __text__, -all- in `Markdown`.
+Formula+: E=mc ^2^, Log ~2~ x

> A block quotation with `some code`.

1. *red*{: style="color: red"} color
1. __blue__{: style="color: blue"},
   `green`{: style="color:green"}

{:refdef0: align="left"}
align left
{: refdef0}

{:refdef1: align="right"}
align right
{: refdef1}

{:refdef2: align="center"}
centered
{: refdef2}

[Link](http://link/)

{% end %}


Markdown base syntax (2/4)
==========================

<pre>
    + this is
      * a list
    - with
      1. numbers
      1. too
    
    ---
    
    This is \*\*not\*\* in bold.
    `some <nimp>*code*</nimp>`
</pre>

+ this is
  - a list
* with
  1. numbers
  1. too

---

This is \*\*not\*\* in bold.
`some <nimp>*code*</nimp>`

Markdown base syntax (3/4)
==========================

<pre>
    This is a referenced [link][1], [another one][item].
    
    ![an image 300x150](http://placehold.it/300x150 "300x150 test")
    ![referenced image 100x150][img]
    
    [1]: / "referenced link"
    [item]: /
    [img]: http://placehold.it/100x150 "100x150 reference test"
</pre>

This is a referenced [link][1], [another one][item].

![an image 300x150](http://placehold.it/300x150 "300x150 test")
![referenced image 100x150][img]

[1]: / "referenced link"
[item]: /
[img]: http://placehold.it/100x150 "100x150 reference test"

Markdown base syntax (4/4)
==========================

<pre>
| A | simple | table | ... |
|:--|-------:|:-----:|:----|
| left | right | `code` | ![placehold.it/64x64](http://placehold.it/64x64) |
{: class="visible center" }
</pre>

| A | simple | table | ... |
|:--|-------:|:-----:|:----|
| left | right | `code` | ![placehold.it/64x64](http://placehold.it/64x64)
{: class="visible center"}

Is this *red*{: style="color: red"}?

!SLIDE

<section class="left">
    <p>Use !SLIDE to make slide without title.</p>
    <p>But I can't make <a href="http://slideshow.rubyforge.org/more.html#notitle">class name declaration</a> work.</p>
</section>

<section class="right">
    <p>Don't worry, you can still write your own HTML code in markdown.</p>
</section>

!SLIDE

<section>
    <h2>Sometimes one column is not enough</h2>

    <ul class="two-column">
        <li>HTML</li>
        <li>CSS</li>
        <li>JavaScript</li>
        <li>SVG</li>
        <li>Canvas</li>
        <li>Audio</li>
        <li>Video</li>
        <li>SVG</li>
        <li>geolocation</li>
        <li>File API</li>
        <li>Drag and Drop</li>
        <li>Offline Detection</li>
    </ul>
</section>

Table
=====

<style>
table {
    width: 100%;
    border-collapse: collapse;
}
th, td {
    padding: 10px;
}
thead th {
    border-bottom: 1px solid #333;
}
tr:nth-child(even) td {
    background: rgba(255, 255, 255, 0.5);
}
</style>

Col1 | Very very long head | Very very long head|
-----|:-------------------:|-------------------:|
cell | center-align        | right-align        |
cell | center-align        | right-align        |
cell | center-align        | right-align        |
cell | center-align        | right-align        |
