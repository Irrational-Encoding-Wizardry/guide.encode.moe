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

This guide is written in [Markdown][] and uses [Rust's mdBook][mdbook] to compile
the static HTML pages.

In order to build and preview the guide locally,
you only need to [install mdBook][],
which can be done via the provided binaries
or directly installing via [Crates.io][], Rust's package registry:

```
$ cargo install mdbook
Updating crates.io index
Installing mdbook v0.4.1
Downloaded syn v1.0.38
...
Downloaded 4 crates (501.9 KB) in 0.42s
Compiling libc v0.2.74
...
Compiling mdbook v0.4.1
Finished release [optimized] target(s) in 2m 56s
```

Once an `mdbook` executable is installed,
running `mdbook serve` in the root directory of the guide's repository
and opening `http://localhost:3000` with your browser
will show a preview of the book.
Any changes you make to the source `.md` files
will cause your browser to be refreshed and automatically reloaded.

```
$ mdbook serve
[INFO] (mdbook::book): Book building has started
[INFO] (mdbook::book): Running the html backend
[INFO] (mdbook::cmd::serve): Serving on: http://localhost:3000
[INFO] (warp::server): Server::run; addr=V6([::1]:3000)
[INFO] (warp::server): listening on http://[::1]:3000
[INFO] (mdbook::cmd::watch): Listening for changes...
```

Changes to the theme can be done by editing the `.css` files in `/theme/css/`.
For information on adding plug-ins or changing the way the book is built,
see the [mdBook User Guide][].

[Markdown]: https://en.wikipedia.org/wiki/Markdown
[mdbook]: https://github.com/rust-lang/mdBook
[install mdBook]: https://github.com/rust-lang/mdBook/tree/a00e7d17695d43af1f7999008b08a75bcb0c134f#installation
[Crates.io]: https://crates.io/
[mdBook User Guide]: https://rust-lang.github.io/mdBook/


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
Refer to the [Markdown Guide][]
for guidelines on visual formatting.

[Markdown Guide]: https://www.markdownguide.org/basic-syntax


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

[Semantic Linefeeds]: https://rhodesmill.org/brandon/2012/one-sentence-per-line/


### Indentation

The indent size is **two spaces**.


### Lists

Unordered list lines should be indented **once**,
while ordered lists are indented **twice**.
The text of an unordered item should have one space after the `-`,
while the text of an ordered item
should start on the fourth column
(start every line with the number 1).

```md
- This is an unordered list
  - With a sublist
  - And another item in that sublist
```

```md
1. This is an ordered list
1. Another list item
…
1. Last entry of the list
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

Horizontal rules can be useful for splitting subsections or
as a visual guide to where the next explanation begins.
They are created with a sole `---` on its own line,
and must have a blank line on each side.


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

Section names are converted to all lowercase,
replacing spaces with a `-` dash,
while disregarding all non-alphanumeric characters
with the exception of the literal `-` dash being kept.
Therefore, a section named `$aFoo-Bar b2 !` can be referenced
as `foobar.md#afoo-bar-b2-`.


### Adding Images

When adding images to your paragraphs,
use the following syntax[^1]:

```
![](images/filename.png)
*Visible caption text*
```

Make sure your image is separated from other images or text
with a blank line above and below,
as this will align them correctly
and allow for the caption to be displayed.

<div class="warning box"><p>
Try to avoid adding lossy images to the guide
(all screenshots should be lossless from the source).
Also, make sure your image is compressed as much as possible
<strong>before committing</strong> it.
This can be done with <a href="https://www.css-ig.net/pingo" target="_blank">pingo</a>'s
lossless PNG compression: <code>pingo -sa file.png</code>.
</p></div>

When extracting frames directly from a VapourSynth pipline
where the format might be `vs.YUV420P16` (YUV 4:2:0, 16-bit),
convert your image to `vs.RGB24` (RGB 8-bit) before saving as a PNG.
This is because many, if not all, browsers don't support
images with bit-depths higher than 8 bpp,
and the dithering behavior of some browsers may be different from others
or poorly executed.

You can change the format and bit-depth
while saving to a PNG file with the following lines:

```py
# replace `{frame}` with the frame number of the clip you are extracting
out = core.imwri.Write(clip[{frame}].resize.Bicubic(format=vs.RGB24, matrix_in_s='709', dither_type='error_diffusion', filter_param_a_uv=0.33, filter_param_b_uv=0.33), 'PNG', '%06d.png', firstnum={frame})
out.get_frame(0)
```


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


### Footnotes

Footnotes can be used for information that would interrupt
the flow or purpose of a paragraph,
but may still be of interest.
They are created with `[^#]` in-text,
and an additional `[^#]: Text here...` at the bottom of the page,
separated by a horizontal rule `---`,
where `#` is to be replaced with an increasing
and per-page unique number.


### Info/Warning boxes

Info boxes can be used similarly to footnotes,
but for information that the reader might want to know
before continuing to read the rest of the page.

Warning boxes are similar but are for information
that is necessary for the reader to know
before continuing to read the rest of the page.

The current syntax uses in-line HTML to render these paragraphs with a
different CSS style.
These paragraphs must be separated with a blank line above and below similar
to images or code blocks.

```md
<div class="info box"><p>
Text here as usual, using semantic linefeed rules.
If you need text-formatting, you <strong>must</strong> use in-line HTML.
</p></div>
```

```md
<div class="warning box"><p>
This class should be used for important information.
</p></div>
```


### Punctuation

Use the *ASCII* symbols `"` and `'`
for quotation and apostrophe respectively
over the *Unicode* versions `“`, `“`, and `’`.
They will be converted during the build process
and in most situations,
text editing tools will work better
with the generic *ASCII* symbols.


### Mathematics with MathJax

This guide has MathJax support,
so in-line or block mathematics can be rendered with TeX.
This obviously requires knowledge of TeX syntax and the supported functions
listed in the [MathJax documentation][].
To start in-line formulas, the syntax is `\\( ... \\)`.
On the other hand, the block formulas' syntax is:

```md
$$
...
$$
```

Similar to \`\`\` fenced code blocks,
separate these blocks with one blank line on either side.

[MathJax documentation]: http://docs.mathjax.org/en/latest/input/tex/index.html

---

[^1]: This differs from normal Markdown image syntax,
by abusing CSS tags to render the `Visual caption text`
centered and under the image.
This may be changed in the future with a plug-in.
