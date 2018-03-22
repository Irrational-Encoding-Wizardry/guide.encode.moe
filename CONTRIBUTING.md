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
gitbook uses the [Github Flavoured Markdown][GFM] (GFM) variant.

Documentation for gitbook's toolchain can be found here:
<https://toolchain.gitbook.com/>

In order to build and preview the guide locally,
you need [npm][] and [node.js][].
The former is usually bundled with installation packages for node.
Once you got those installed,
run the following commands
from the repository's folder:

{% term %}
$ npm install
added 611 packages from 674 contributors in 4.478s

$ ./node_modules/.bin/gitbook install
info: installing 5 plugins using npm@3.9.2
…

$ ./node_modules/.bin/gitbook serve --open
Live reload server started on port: 35729
Press CTRL+C to quit ...
info: 12 plugins are installed
info: loading plugin "highlight"... OK
…
info: found 11 pages
info: found 21 asset files
…
info: >> generation finished with success in 1.6s !
Starting server ...
Serving book on http://localhost:4000
{% endterm %}

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
or on a new section.

Currently, we aim to add the following topics
in no particular priority:

- Workflow
- (Translation)
- Edit
- Timing
  - Basic Procedure
  - Snapping
  - Joining, Splitting
  - Post-processing (TPP & Useful Scripts)
  - Shifting & Sushi
  - Karaoke
- Typesetting
  - …with Aegisub
    - Styling (of dialogue)
    - Signs
      - Positioning, Layers, Rotation, Perspective, …
    - Masking
    - Automation Scripts
    - Movement & Motion Tracking
  - …with Adobe Illustrator
  - (…with Adobe After Effects)
- Encoding \[*I'm sure there's something to be done*\]
- Quality Check
- Karaoke Effects

You may find some inspiration for these topics
from the following resources:

- http://unanimated.hostfree.pw/ts/?i=1
- http://blog.line0.in/typesetting-with-illustrator-and-ai2ass-part-i-the-basics/
- https://commiesubs.com/wp-content/uploads/2011/06/A-guide-to-timing-in-Aegisubv2.pdf
- http://doki.co/support/doki-timing-guide/


## Style Guidelines

Following are the style guidelines
for various aspects of this guide.
The most important aspect are **Semantic Linefeeds**.
All the other points
serve as guidelines to refer to
in case you are wondering
how to format Stuff™.


### Semantic Linefeeds (!)

Always use [Semantic Linefeeds][] are used
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
long lists (like this).

[Semantic Linefeeds]: http://rhodesmill.org/brandon/2012/one-sentence-per-line/


### Indentation

The indent size is **two spaces**.


### Lists

Unordered lists should be indented **once**,
while ordered lists are indented **twice**.
This also applies to the first line of an ordered list,
so that there are two spaces after the first item.

```md
- This is an unordered list
  - With a sublist
  - And another item in that sublist


1.  Text be here.
    And consecutively indented with four spaces.
2.  Another list item
…
10. Now only one space after the item number.
```


### Blank Lines

All block lists
should be separated from text
with a blank line on each side.
The same applies to code blocks.

Separate headings from text with **two** blank lines.
Headings immediately following their parent heading
only need one blank line in-between.
