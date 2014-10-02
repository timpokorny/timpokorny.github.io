---
title: Markdown Template
layout: documentation
author: Tim Pokorny

section: User Documentation
section-path: documentation/user/
tags: [java, c++, hla13, ieee1516e]

header-image-path: assets/images/logos/macosx-yosemite-450x250.png
header-image-text: Some descriptive text

excerpt: > 
    Markdown is awesome. Clean and easy to read both in its native form, and when transformed.
    This page provides example snippets that and shows you the results for the Portico site.

---

Typography and Text
===================

You can get _Italic Text_ by using `_Text Here_` or `*Text Here*`.

You can get some **Bold Text** by using `__Text Here__` or `**Text Here**`.

Alerts and Callouts
-------------------
Below are some alert box styles you can use to call attention to various important things
in your document. Unfortunately these are only available as embedded HTML as there is no
easy Markdown conversion:

### Info Alert

```markup
<div class="alert info">
  <p>This is an Info alert - use it to alert people to alertful things.</p>
</div>
```

<div class="alert info">
  <p>This is an Info alert - use it to alert people to alertful things.</p>
</div>

### Success Alert

```markup
<div class="alert success">
  <p>This is a Success alert - use it to affirm successful things.</p>
</div>
```

<div class="alert success">
  <p>This is a Success alert - use it to affirm successful things.</p>
</div>

### Warning Alert

```markup
<div class="alert warning">
  <p>This is a Warning alert - use it to warn people about scary things.</p>
</div>
```

<div class="alert warning">
  <p>This is a Warning alert - use it to warn people about scary things.</p>
</div>

### Error Alert

```markup
<div class="alert error">
  <p>This is an Error alert - use it to alert people to red things.</p>
</div>
```

<div class="alert error">
  <p>This is an Error alert - use it to alert people to red things.</p>
</div>

Quotes
--------
Quotes are blocks prefixed with ` >`. For example:

```markdown
 > Are you quite sure that all those bells and whistles, all those wonderful facilities of
 > your so called powerful programming languages, belong to the solution set rather than the
 > problem set?
 > 
 >  -- Edsger W. Dijkstra
```

 > Are you quite sure that all those bells and whistles, all those wonderful facilities of
 > your so called powerful programming languages, belong to the solution set rather than the
 > problem set?
 > 
 >  -- Edsger W. Dijkstra


Code Highlighting
=================

### Inline Code

The Markdown conversion supports inline code through the use of backticks <span class="code">\`</span>, allowing you to
create sections `like this`.

If we want to get a bit more specific with the background colour of the highlight we have to
drop back to html again. For example: <span class="label label-info">methodWithBlueBackground()</span>
is generated from this:

```markup
<span class="label label-info">methodWithBlueBackground()</span>
```

Other options available include:

<span class="label label-default">label-default</span>, 
<span class="label label-primary">label-primary</span>, 
<span class="label label-success">label-success</span>, 
<span class="label label-info">label-info</span>, 
<span class="label label-warning">label-warning</span>, 
<span class="label label-danger">label-danger</span>.

### Fenced Code Blocks

Fenced code blocks are also supported. They start with three backticks and should be followed by
the name of the language you wish to use. For example:

```
```java
public static void main( String[] args )
{
	System.out.println( "Do you like Portico?" );
	for( int i = 0; i < 10; i++ )
	{
		String temp = "Yes I do!";
		System.out.println( temp );
	}
}
```

```java
public static void main( String[] args )
{
  System.out.println( "Do you like Portico?" );
  for( int i = 0; i < 10; i++ )
  {
    String temp = "Yes I do!";
    System.out.println( temp );
  }
}
```

### External Code Files

Finally, you can point the highlighter at an external file, which it will parse and bring in
for highlighting:

```markup
<!-- Bring in some code from an external file -->
<pre data-src="Main.java" class="language-java"></pre>
```

<pre data-src="Main.java" class="language-java"></pre>


Tables
======
Tables? You want tables? OK. They're really easy.

```markup
| Left-Aligned     |   Center Aligned    |    Right Aligned |
| :--------------- |:-------------------:| ----------------:|
| col 3 is         | **some wordy text** |       **$1600**  |
| col 2 is         | centered            |             $12  |
| zebra stripes    | are neat            |              $1  |
```

| Left-Aligned     |   Center Aligned    |    Right Aligned |
| :--------------- |:-------------------:| ----------------:|
| col 3 is         | **some wordy text** |       **$1600**  |
| col 2 is         | centered            |             $12  |
| zebra stripes    | are neat            |              $1  |



Links
======
Links to other pages have a simple format, with the text to display held in square-brackets,
follows by the URL to link to. For example, consider the following:

  - **Text Link**
    - Markdown: `The [Portico Website](http://www.porticoproject.org)`
    - Result: The [Portico Website](http://www.porticoproject.org)
  - **Direct Link**
    - Markdown: `<http://www.porticoproject.org>`
    - Result: <http://www.porticoproject.org>
  - **Email Link**
    - Markdown: `<support@porticoproject.org>`
    - Result: <support@porticoproject.org>


Images
======
Images are also straightforward, except that you have little control over things like the size :(

```markup
![This is the alt text for the image]({% site_asset images/logos/macosx-yosemite-450x250.png %})![This is the alt text for the image]({% site_asset images/logos/macosx-yosemite-450x250.png %})
```

![This is the alt text for the image]({% site_asset images/logos/macosx-yosemite-450x250.png %})

That's all for now!

