# Roles

 There are 8 (sometimes 9) major roles in every fansub group. They are:

1.  [**Encoder**](#encoder)
2.  [**Timer**](#timer)
3.  [**Typesetter**](#typesetter)
4.  [**Editor**](#editor)
5.  [**Quality Checker**](#quality-checker)
6.  *Optional*: [Translator](#translator--translation-checker)
7.  *Optional*: [Translation Checker](#translator--translation-checker)
8.  *Optional*: [Karaoke Effects Creator](#karaoke-effect-creator)
9.  *Optional*: Project Leader

In this guide, we will only be providing in-depth guides for the
Encoder, Timer, and Typesetter roles.
However, Quality Checkers are often expected to be familiar with
most or all of the roles in order to recognize errors.

This page serves as just an overview of the work
various roles will be expected to complete.

## Encoder

Time commitment per episode: 20 minutes - 2 hours active (4-12 hours
inactive)

Encoders (sometimes abbreviated as *ENC*) are responsible for the audio
and video.
They will generally be provided with one or more video sources
and are expected to produce the best video possible within reason.

This is done with a **frame-by-frame video processor** such as AviSynth
and VapourSynth[^1],
a **video encoder** such as x264 or x265[^2],
and **audio tools** such as eac3to,
qaac,
and FLAC[^3].
This is not a comprehensive list,
but it does represent the broad categories of tools required.

Encoders are expected to have a high level of skill and understanding of
video concepts and tools.
It is perhaps the most technically challenging role in fansubbing.
However, much of the work is repeatable,
as each episode in a show will usually be very similar to every other one.
It will also get easier over time as they become more familiar with the
concepts and tools.

One last note about encoding: there are as many opinions about how to
fix video problems as there are encoders.
Encoders can and often do become contentious about their work,
theories,
and scripts.
It's important to keep in mind that a disagreement is not always an insult,
and more experienced encoders often just want to help and provide feedback.
The important part is the result\!

## Timer

Time commitment per episode: 20 minutes - 4 hours

The Timer (abbreviated *TM*) is responsible for when the text
representing spoken dialogue shows up on screen.

The timing of subtitles is much more important than one might assume.
The entrance and exit times of the subtitles,
or a fluid transition from one line to the next,
can make a large impact on the "watchability" of the episode as a whole.
Take, for example,
the following clip from Eromanga-sensei:

<div style="width:100%;height:0px;position:relative;padding-bottom:28.125%;"><iframe src="https://streamable.com/s/5kylp/abmmlr" frameborder="0" width="100%" height="100%" allowfullscreen style="width:100%;height:100%;position:absolute;left:0px;top:0px;overflow:hidden;"></iframe></div>

On the left are the official subtitles from Amazon's AnimeStrike,
and on the right is a fansub release.
There are many problems with Amazon's subtitles:
entering and exiting the screen up to two seconds late,
presenting 4-5 lines on screen at once,
and not separating dialogue based on speaking character.
These problems detract from the viewing experience,
drawing attention to the appearance of the subtitles
and distracting from the story and video.

## Typesetter

Time commitment per episode: 20 minutes - 8+ hours (dependent on number
and difficulty of signs)

Typesetters (abbreviated *TS*) are responsible for the visual
presentation of translated text on-screen. These are generally called *signs*.

For example, given this scene and a translation of "Adachi Fourth Public High School"…

![[DameDesuYo] Eromanga-sensei - 01 (1920x1080 10bit AAC) [05CB518E].mkv_snapshot_03.11_[2017.08.18_21.14.55].jpg](images/cnvimage100.png)

the Typesetter would be expected to produce something like
this:

![[DameDesuYo] Eromanga-sensei - 01 (1920x1080 10bit AAC) [05CB518E].mkv_snapshot_03.11_[2017.08.18_21.14.43].jpg](images/cnvimage101.png)

Almost every sign the Typesetter works on will be unique,
requiring ingenuity,
a wild imagination,
a sense of style,
and a high degree of attention to detail.
The Typesetter's goal is to produce something that integrates so
well into the video that the viewer does not realize that it is actually
part of the subtitles.

The sign above is actually one of the more simple kinds that the Typesetter might
have to deal with.
It is *static*, meaning it does not move,
and has plenty of room around it to place the translation.
Other signs will be much more difficult.
Take for example this scene from Kobayashi-san Chi no
Maid Dragon:

<div style="width:100%;height:0px;position:relative;padding-bottom:28.125%;"><iframe src="https://streamable.com/s/d21iq/aqaodi" frameborder="0" width="100%" height="100%" allowfullscreen style="width:100%;height:100%;position:absolute;left:0px;top:0px;overflow:hidden;"></iframe></div>

Though it may be hard to believe,
the typesetting on the right side of the screen was done entirely
with *softsubs* (using Aegisub),
subtitles that can be turned on and off in the video player
as compared to *hardsubs* (using Adobe After Effects) which are burned in.
Each group and language "scene" will have different standards
in regards to soft and hardsubs.
For example, in the English scene,
hardsubs are considered highly distasteful,
whereas in the German scene they are readily accepted.

Something to remember about typesetting is that there is no one way to
typeset a sign.
There are, however,
incorrect ways that are not visually pleasing,
do not match the original well,
are difficult to read,
or are too *heavy* (meaning computer resource intensive).

## Editor

Time commitment per episode: 2-4+ hours

The Editor (sometimes abbreviated *ED*) is responsible for making sure that
the script reads well.
Depending on the source of the script,
this may mean grammatical corrections and some rewording
to address recommendations from the Translation Checker.
However, more often than not,
the job will entail rewriting,
rewording,
and characterizing large portions of the script.
Each group will have different expectations of an Editor
in terms of the type,
style,
and number of changes made.
The Editor may also be responsible
for making corrections recommended by the Quality Checkers.

## Quality Checker

Time commitment per episode: 30 minutes to 4 hours (depending on your
own standards)

Quality Checkers (abbreviated *QC*) are often the last eyes on an
episode before it is released.
They are responsible for ensuring that the overall quality
of the release is up to par with the group's standards.
They are also expected to be familiar with the workflow
and many intricacies of every other role.
Each group has a different approach to how the Quality Checker
completes their work.
For example, one group might require an organized "QC report"
with recommended changes and required fixes,
while other groups may prefer the Quality
Checker to make changes directly to the script whenever possible.

## Translator & Translation Checker

Time commitment per episode: 1-3 hours for translation check,
4+ hours for an original translation (dependent on the skill of the TL/TLC
and the difficulty of the show's original script)

The job of the Translator (abbreviated *TL*) and the Translation Checker
(abbreviated *TLC*) is to translate and ensure the translational quality
of the script and signs respectively.
This is perhaps an obvious statement,
but it bears explaining just in case.
Today, many shows are *simulcast* by one or more companies,
meaning scripts will be available either immediately or soon after airing in Japan.
In these cases, some fansub groups may choose to edit
and check the simulcast script rather than translate it from scratch.
This depends almost entirely on the quality of the simulcast.
Fixing a bad simulcast script may be harder than doing an 
*original translation* (abbreviated OTL).
Finally, translators are responsible for transcribing and translating
opening,
ending,
and insert songs as well.

## Karaoke Effect Creator

Time commitment: several hours, once or twice per season

The Karaoke Effect Creator (abbreviated *KFX*) styles and
adds effects to the lyrics and sometimes romaji and/or kanji for
opening,
ending,
and insert songs.
This can be very similar to typesetting
but utilizes a different set of tools
and can be highly programming-oriented.

***

[^1]: *TODO - sources for AviSynth and VapourSynth builds relevant to fansubbing.*

[^2]: Further reading on the x264 and x265 libraries can be found [here][reddit-x264-x265].

[^3]: Comparisons of various audio codecs can be found [here][wikipedia-audio].

[reddit-x264-x265]: https://www.reddit.com/r/anime/comments/8ktmvu/nerdpost_how_fansubbers_make_your_anime_look/
[wikipedia-audio]: https://en.wikipedia.org/wiki/Comparison_of_audio_coding_formats
