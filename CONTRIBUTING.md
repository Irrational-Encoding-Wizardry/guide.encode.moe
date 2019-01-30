# Contribution Guidelines

If you are interested in supporting
or contributing to this guide,
please keep on reading.

**If you are not,
feel free to skip to the next page.**

---

We are currently still in the early phases of this guide,
so any form of contribution,
including just giving feedback,
is greatly appreciated.
Please open an issue on our [Github repository][issues]
with your feedback,
or begin working on a Pull Request.
You can start editing any page
by clicking on the 'Edit this page' button
in the top bar.

If you are mainly looking for things to work on,
refer to the [TODO](#todo) section.

[issues]: https://github.com/Irrational-Encoding-Wizardry/guide.encode.moe/issues


## General

### Language

The language of this guide is **English**.
American or British English are both acceptable
and there is no preference for either.

The only exceptions are
pages specific to a particular language,
for example with references to online dictionaries
or official grammar rule books,
or other typographic advices,
for example concerning the usage of quotation marks.

When adding such a page,
please briefly describe in your Pull Request
what the text is about,
what topics it covers,
and, if necessary,
why it only applies to a specific language.


### Technology

This guide is written in [Markdown][]
and uses [gitbook][]'s [toolchain][] to compile
the static HTML pages.
Gitbook uses the [Github Flavoured Markdown][GFM] (GFM) variant.

Documentation for gitbook's toolchain (including gitbook markdown sytax)
can be found here:
<https://toolchain.gitbook.com/>

In order to build and preview the guide locally,
you need [npm][] and [node.js][].
The former is usually bundled with installation packages for node.
Once you have those installed,
run the following commands
from the repository's folder:

```js
$ npm install

$ ./node_modules/.bin/gitbook install

$ ./node_modules/.bin/gitbook serve --open
```

Afterwards, your browser will have opened
with a preview of your files.
Any changes you make to the source `.md` files
will cause your browser to be refreshed
and automatically reloaded.

[Markdown]: https://en.wikipedia.org/wiki/Markdown
[gitbook]: https://www.gitbook.com/
[toolchain]: https://github.com/GitbookIO/gitbook
[GFM]: https://github.github.com/gfm/
[npm]: https://npmjs.com/
[node.js]: https://nodejs.org/


### TODO

Various sections are still under construction.
You will occasionally find `TODO` as verbatim text
or within comments.

Our goal is to have a section
with one or more pages
for each of the roles
specified in the roles page.

Feel free to work on any of the `TODO` marks
or create a new section.

Currently, we aim to add the following topics
in no particular priority:

- Workflow
- Translation
- Edit
- Timing
  - Basic Procedure
  - Snapping
  - Joining, Splitting
  - Post-processing (TPP & Useful Scripts)
  - Shifting & [Sushi][]
  - Karaoke
- Typesetting
  - …with Aegisub
    - Styling (of dialogue)
    - Signs
      - Positioning, Layers, Rotation, Perspective, …
    - Masking
    - [Automation Scripts][TypesettingTools]
    - Movement & Motion Tracking
  - …[with Adobe Illustrator][Ai2ASS]
  - (…with Adobe After Effects)
- Encoding \[*I'm sure there's something to be done*\]
- Quality Check
- Karaoke Effects

There is a collection of links [here][issue2] that can be used as reference
when working on any future section.

[Ai2ASS]: https://typesettingtools.github.io/2014/08/25/typesetting-with-illustrator-and-ai2ass-part-1.html
[TypesettingTools]: https://github.com/TypesettingTools
[Sushi]: https://github.com/tp7/Sushi/releases
[issue2]: https://github.com/Irrational-Encoding-Wizardry/guide.encode.moe/issues/2


## Style Guidelines

The following are the style guidelines
for various aspects of this guide.
The most important aspect is having **Semantic Linefeeds**.
The other points may serve as guidelines for formatting future pages.
Refer to [gitbook's markdown documentation][gitbookMarkdown]
for guidelines on visual formatting.

[gitbookMarkdown]: https://toolchain.gitbook.com/syntax/markdown.html


### Semantic Linefeeds (!)

Always use [Semantic Linefeeds][] when editing code.
They are used
to break lines into logical units
rather than after a certain line length threshold is reached!

They drastically improve sentence parsing
in the human brain
and make code diffing much more simple
compared to hard-wrapping at 80 columns.
You should still aim
not to exceed 80 columns in a single line,
but unless you are writing code or URLs,
you will most likely not have any problems with this.
Markdown will collapse adjacent lines into a paragraph,
so you don't have to worry about the rendered result.

As a rule of thumb,
always start a new line on
a comma,
a period,
any other sentence terminating punctuation,
parenthesized sentences (not words),
or new items in a long list (such as the one you are reading right now).

[Semantic Linefeeds]: http://rhodesmill.org/brandon/2012/one-sentence-per-line/


### Indentation

The indent size is **two spaces**.


### Lists

Unordered list lines should be indented **once**,
while ordered lists are indented **twice**.
The text of an unordered item should have one space after the `-`
while the text of an ordered item should have two spaces after the `#.`

```md
- This is an unordered list
  - With a sublist
  - And another item in that sublist
```

```md
1.  This is an ordered list.
    Consecutive lines are indented with four spaces.
2.  Another list item
...
10. Now only one space after the item number.
```


### Blank Lines

All block lists
should be separated from text
with a blank line on each side.
The same applies to code blocks.

Separate headings from text with **two** blank lines before the heading
and **one** after.
Headings immediately following their parent heading
only need one blank line in-between.

Separate text from end-of-section hyperlink lists with **one** blank line
before the list. See [below](#Hyperlinking) for more information.


### Hyperlinking

There are three types of hyperlinks.

- The text you want highlighted is more than one word,
  or different than the shorthand name of the link.
  - `[website's great article][short]`
  - [website's great article][short]
- The text you want highlighted is the same as the shorthand.
  - `[short][]`
  - [short][]
- You want the full address displayed.
  - `<https://guide.encode.moe/>`
  - <https://guide.encode.moe/>

For the first two hyperlinking styles,
you will want to include a line at the end of that header section
in the following format.

`[short]: https://guide.encode.moe/`

If there are multiple links used in the first two styles,
you will want multiple lines at the end of the header section.

```md
[short1]: https://guide.encode.moe/
[short2]: https://guide.encode.moe/CONTRIBUTING.HTML
...
```

If you are linking to a section on the same page,
`[section name](#header)` is allowed in-line.
An example of this is ["the hyperlink section you are reading"](#Hyperlinking).
In code, this is simply `["the hyperlink section you are reading"](#Hyperlinking)`.

For relative links (links to other pages, images, or files within
this repository), follow the guidelines for [Jekyll Relative Links][].

[short]: https://guide.encode.moe/
[Jekyll Relative Links]: https://github.com/benbalter/jekyll-relative-links/blob/master/README.md


### Citations

If you are archiving another website's text or copying their images
into this repository, make sure to cite your sources using APA formatting.
To generate APA citations, use [Citation Machine][]. Only use this if you
fear the website is not a permanent source.

For mid-document citations, use "in-text citations" with footnotes for the
full citations. For a full document citation, simply place the
full citation at the bottom of the document under a horizontal rule.

[Citation Machine]: http://www.citationmachine.net/apa/cite-a-website
