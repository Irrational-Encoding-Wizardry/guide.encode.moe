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
by clicking on the
<kbd><i class="fa fa-edit"></i> EDIT THIS PAGE</kbd>
button in the top bar.

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
and uses legacy gitbook's [toolchain][] to compile
the static HTML pages.
Gitbook uses the [Github Flavoured Markdown][GFM] (GFM) variant.

In order to build and preview the guide locally,
you need [npm][] and [node.js][].
The former is usually bundled with installation packages for node.
Once you have those installed,
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
[toolchain]: https://github.com/GitbookIO/gitbook
[GFM]: https://github.github.com/gfm/
[npm]: https://npmjs.com/
[node.js]: https://nodejs.org/


### Adding a New Page

In order for your page to be accessible,
you need to add it to the `SUMMARY.md` file.
The title used there will be used in the navigation bar,
so keep it short.


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
Refer to [gitbook's markdown documentation][gitbookMarkdown][^1]
for guidelines on visual formatting.

[gitbookMarkdown]: https://gitbookio.gitbooks.io/documentation/content/format/markdown.html


### Semantic Linefeeds (!)

Always use [Semantic Linefeeds][] when editing text.
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
or new items in a long list
(such as the one you are reading right now).

[Footnotes](#footnotes) are an exception and must be written all on one line.

[Semantic Linefeeds]: https://rhodesmill.org/brandon/2012/one-sentence-per-line/


### Indentation

The indent size is **two spaces**.


### Lists

Unordered list lines should be indented **once**,
while ordered lists are indented **twice**.
The text of an unordered item should have one space after the `-`,
while the text of an ordered item
should start four columns after the number.

```md
- This is an unordered list
  - With a sublist
  - And another item in that sublist
```

```md
1.  This is an ordered list.
    Consecutive lines are indented with four spaces.
2.  Another list item
…
10. Now only one space after the item number.
```


### Blank Lines

All block lists
should be separated from text
with a blank line on each side.
The same applies to code blocks.

Separate headings from text with **two** blank lines before the heading,
and **one** after.
Headings immediately following their parent heading
only need one blank line in-between.

Additionally, separate text from end-of-section hyperlink lists
with **one** blank line before the list.
For image embeds,
there should be a blank line on each side.


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
…
```

For relative links (links to other pages,
images,
or files within this repository),
follow the guidelines for [Jekyll Relative Links][].

[short]: https://guide.encode.moe/
[Jekyll Relative Links]: https://github.com/benbalter/jekyll-relative-links/blob/master/README.md


#### Section Linking

If you are linking to a section on the same page,
`[section name](#header)` is allowed in-line.
An example of this is [the hyperlink section you are reading](#hyperlinking).
In markdown, this is simply `[the hyperlink section you are reading](#hyperlinking)`.

The section names are converted to all lowercase[^2],
and whitespace is converted to a dash.
Special characters excluding the dash are ignored.
For example, a section titled *Foo & BAR-2 !* is converted to
`#foo--bar-2-`.


### Adding Images

When adding images to your paragraphs,
use the following syntax:

```
![Visible caption text](images/filename.png)
```

Make sure your image is separated from other images or text
with a blank line above and below,
as this will align them correctly
and allow for the caption to be displayed.


### Citations

If you are archiving another website's text
or copying their images into this repository,
make sure to cite your sources using APA formatting.
To generate APA citations,
use [PapersOwl][].
Only use this if you fear the website is not a permanent source.

For mid-document citations,
use "in-text citations" with footnotes for the full citations.
For a full document citation,
simply place the full citation at the bottom of the document,
under a horizontal rule.

[PapersOwl]: https://papersowl.com/apa-citation-generator


### Glossary

If you find yourself repeating a term or concept
that should be explained elsewhere,
feel free to add the term to the `GLOSSARY.md` file.
Examples of this can be found on the
[Aegisub and Other Tools](typesetting/aegisub.md) page.


### Footnotes

Footnotes can be used for information that would interrupt
the flow or purpose of a paragraph,
but may still be of interest.
They are created with `[^#]` in-text,
and an additional `[^#]: Text here...` at the bottom of the page,
separated by a line break `---`.

**Note**: The footnote text at the bottom of the page
must all be written one line per footnote.
Line breaks **cannot** be used.

---

[^1]: The new gitbook spec is very different than the version this book is using. Almost none of the information from [gitbook's new website][new-gitbook] applies.

[^2]: This is different from how github.com's markdown preview behaves.

[new-gitbook]: https://www.gitbook.com/
