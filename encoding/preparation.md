# Preparation and Necessary Software

While the term "encoding" originally just referred
to the opposite of decoding—
that is, compressing raw video with a video codec—
the term has a broader meaning in the context of fansubbing.
Here, "encoding" includes the entire process
from receiving the source video until the final release.
Usual steps are processing or filtering
of the original video to remove defects,
compressing the video in a way that does not generate new artifacts,
transcoding audio to the desired format,
and muxing video,
audio,
subtitles,
fonts,
and other attachments into a container,
such as mkv.

Each of these steps requires different tools which will be listed and
explained in the following paragraphs.

It is assumed that you already have a source video at this point,
so software like torrent clients,
Perfect Dark,
Share,
or even FileZilla will not be covered.
If you don't have a reliable way to get raws
and if your group doesn't provide them,
try finding a source first.
Private bittorrent trackers like [u2][]
or [AsianDVDClub][] are good starting points.

[u2]: https://u2.dmhy.org "u2"
[AsianDVDClub]: https://asiandvdclub.org "ADC"


## Processing and Filtering

### The Frameserver

In order to process your source video
(which will be called "raw" throughout this chapter),
you need to import it into a so-called "frameserver",
a software that is designed to process a video frame-by-frame,
usually based on a script that defines various filters
which will be applied to the video.

Currently, only two widely-known frameservers exist:
Avisynth and VapourSynth.

While many (especially older) encoders still use Avisynth,
there is no reason to use it
if you're just starting to learn encoding.[^1]
Most Avisynth users only use it because
they have years of experience and
don't want to switch.

Since this guide is aimed towards new encoders,
and the author has no qualms about imposing his own
opinions onto the host of people willing to listen,
the guide will focus on VapourSynth.
Avisynth equivalents are provided for certain
functions where applicable,
but the sample code will always be written for VapourSynth.

That being said, the installation of VapourSynth is quite easy.
It is strongly recommended to install the 64-bit version
of all tools listed here.
VapourSynth requires Python 3.6 or newer
(which can be downloaded [here][Python]).
VapourSynth Windows binaries can be found
[here][VapourSynth].
Linux users will have to build their own version,
but if you're on Linux,
you probably know how to do that.
During the installation,
you might be prompted to install the Visual C++ Redistributables.
Just select "Yes" and the installer will do it for you.

And that's it.
You can test your VapourSynth installation by opening the
Python shell and typing:

```py
>>> import vapoursynth
```

If the installation was not successful,
you should receive an error that reads:

```
Traceback (most recent call last):
  File "", line 1, in <module>
ImportError: No module named 'vapoursynth'
```

In that case,
make sure your current Python shell is the correct version
(Python version as well as architecture),
try restarting your PC,
reinstall VapourSynth,
or [ask for help][Discord].

[Python]: https://www.python.org/downloads/
[VapourSynth]: https://github.com/vapoursynth/vapoursynth/releases
[Discord]: https://discordapp.com/invite/ZB7ZXbN


### Plugins

In addition to VapourSynth's core plugins,
community-created scripts and plugins
can be installed to extend the functionality of the frameserver.
These are usually more specific than the universally usable core plugins
or they are collections of wrappers and functions.
A (non-exhaustive) list of plugins and scripts is available in the
[official documentation][vs-plugins].
Alternatively, some individuals in the community are creating archives
containing the most recent version of useful plugins.
[eXmendiC's encode pack][ex-encode-pack] is an example of this
(the lite version should suffice).

[vs-plugins]: http://www.vapoursynth.com/doc/pluginlist.html "Plugins, Applications & Scripts"
[ex-encode-pack]: https://iamscum.wordpress.com/encoding-stuff/encode-pack/


### The Editor

Now that you have installed the frameserver,
you can start filtering the video.
But without an editor,
you have no means of previewing the results other than test encodes
or raw output into a file.
That's why editors exist.
They provide useful features such as autocompletion,
tooltips,
preview images,
and comparisons.

There are two editors that can be used to preview you
VapourSynth-Script.

1.  [VSEdit](https://bitbucket.org/mystery_keeper/vapoursynth-editor).
    It is a small editor software that can run on your PC. It can be
    downloaded
    [here](https://bitbucket.org/mystery_keeper/vapoursynth-editor/downloads/).
    It provides an easy and simple GUI to write your VapourSynth
    scripts.

    ![The main window of VSEdit.](images/cnvimage100.png)

    While it seems to be unstable on some systems, its high performance
    preview window offsets its problems.

2.  [Yuuno](https://yuuno.encode.moe/). While it is not an editor, Yuuno
    is an extension to a Python-shell-framework that runs inside your
    browser.
    This increases latency, but it gives you a wider range of preview
    related features while being more stable than VSEdit. It should be
    noted that Yuuno natively supports remote access, as it is only an
    extension for Jupyter Notebook.

    ![A Jupyter Notebook.](images/cnvimage101.png)

3.  [AvsPmod](https://github.com/AvsPmod/AvsPmod/releases). This is the
    editor for AviSynth. It is old and slow but stable. When you are
    using AviSynth, you are limited to this editor. AvsPmod *can* handle
    AviSynth and VapourSynth scripts, however, VapourSynth support was
    an afterthought and is therefore experimental, unstable, and
    "hacky".

    Do not use AvsPmod for VapourSynth scripts unless you have a very
    good reason!

Please rest assured that the author does not impose any editor on you.
Instead we will give callouts for some editors.
These will be completely optional.

## Video Codecs

Once you are happy with the result of your filter chain,
you want to save the output to a file.
While it is possible to store the script's output as raw,
uncompressed pixel data,
that would result in hundreds of gigabytes of data for a single episode.
Because of this,
we use video codecs to compress the video.

Lossless compression will still result in very big files,
so we have to use lossy compression,
which means losing some information in the process.
As long as you're not targeting unreasonable bitrates
(say, 50 MB per 24 minute episode),
this loss of information should be barely noticeable.

None of the codecs mentioned here need to be installed.
Just save the executable(s) somewhere for later.

For now, all you need to know is which codecs exist
and which ones you want to use.

The codec used most commonly is x264,
an implementation of the h.264 standard.
There are multiple versions available
(kmod and tmod being the most popular ones),
but they only differ slightly
(mainly cosmetic patches and some obscure parameters
that you will probably never use),
and no version is objectively better than any other.
x264 can encode in 8 or 10 bit color depth.
We will explain the meaning of these at a later time.
For now, they are just relevant for choosing the right binary.
All modifications come in two versions each,
one for 8 bit and one for 10 bit[^2].
Most fansub group nowadays use 10 bit,
so you should download that
unless your group leader or encode mentor told you otherwise.

- [Download kmod](http://komisar.gin.by/)
- [Download tmod](https://github.com/jpsdr/x264/releases)

A newer, more efficient alternative is x265.
It is still in active development
and aims for 20-50% lower bitrates with the same quality as x264.
It does have its flaws,
is a lot slower,
and not as widely supported by media players as x264,
but it can be a viable alternative,
especially if small files are important
and encoding time is of secondary importance.
Note that many groups will require you to use x264,
so ask your group leader before picking this codec.


Other codecs, such as VP9, are generally not used for fansubbing, so
they are not listed here. The same is true for unreleased codecs like
Daala and AV-1.

## Audio Codecs

TODO: FLAC, AAC, maybe mention opus


## MKVToolNix

You probably have at least three files now—
that being the video,
audio,
and subtitles—
and you need to combine all of them into a single file.
This process is called muxing.

MKVToolNix is used to mux all parts of the final output
into an mkv container.
Most people use MKVToolNix GUI,
which provides a graphical user interface to mux video,
audio,
chapters,
fonts,
and other attachments
into an mkv file.
Installation instructions for virtually any platform
can be found [on their website][MKVToolNix].

It is possible to use other containers,
but Matroska has become the standard for video releases
due to its versatility and compatibility.

[MKVToolNix]: https://mkvtoolnix.download/downloads.html "MKVToolNix"


## FFmpeg

While FFmpeg is not necessary for any specific task,
it is a very useful tool for all kinds of conversion and transcoding.
There will be times where using FFmpeg is simply the easiest solution,
so it is recommended to download it.
Windows builds can be found [here][ffmpeg-zeranoe].
Just like the codecs,
you don't have to install it.
Just extract it somewhere.

[ffpeg-zeranoe]: http://ffmpeg.zeranoe.com/builds/ "FFmpeg"

---

[^1]: It should be noted that the author strongly disagrees with this sentiment. The two have a lot in common, and any capable Avisynth encoder could reach a similar leven in Vapoursynth within a few months, maybe even weeks. At least I'm honest, okay?
