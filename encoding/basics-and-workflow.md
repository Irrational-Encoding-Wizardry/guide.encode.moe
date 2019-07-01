# Basics and General Workflow

## Preparation

It is important to have a good idea
of what you want the result of the encode
to be like.
What will your video source be?
What resolution should you encode it to?
Do you use AAC or FLAC?
8bit colors or 10bit colors?
All of these are things
that have to be accounted for
and decided early on.

Some groups have set standards.
For example, you may have a group
that always encodes their audio in AAC.
Others will always release their videos in 1080p.
Some may even mix it up
and use FLAC audio for 1080p releases,
but AAC for 720p.
They might even only go for
8bit colors in the latter case!
If you're unsure what standards a group has,
contact your group leader.

There are various sources
that are often used for the video.
You will most commonly work with websources
like Crunchyroll,
as those are easy to acquire,
or Blu-rays, for the improved quality and fixes.
As a beginner, you might not
have access to private trackers with BDMVs yet.
A good alternative until then
is to use the raws provided by groups like Reinforce:
those that have not been filtered,
just re-encoded from the BDMV.

## Writing the Script

In order to start filtering,
first you must learn how to write a VapourSynth script.

```Py
import vapoursynth
core = vs.core
```

First, you must import the VapourSynth module.
You can also import various other modules,
like the many "funcs"[^1] that people have written.
Here are some common examples:

```Py
import kagefunc as kgf
import fvsfunc as fvf
import havsfunc as haf
```

These will import various functions
that may prove useful for filtering,
like masks, descaling wrappers, anti-aliasing functions, etc.

Now, to start filtering,
we must first import a video clip.

```Py
src = core.ffms2.Source("source")
```
```Py
src = core.lsmas.LWLibavSource("source")
```

There are two common import filters available.
Those are L-SMASH and ffms2.
L-SMASH is typically used for m2ts files
(the kind you'll find in BMDVs),
while ffms2 is used for everything else.
The reason for this is that ffms2
can't accurately read m2ts files,
which L-SMASH can.
However, L-SMASH is slower than ffms2,
and some people prefer to be able to
index the source files faster.

It is common practice to call the source clip `src`.
This way it's easy to tell what the original video is,
and it can be referenced for some masks or for comparisons.

Let's now look at a couple of common filters
that you will find yourself using often.

```Py
src16 = fvf.Depth(src, 16)
```

The color depth of a clip
indicates the number of bits used
to give a pixel its color.
A lot of filters work with high bitdepths,
so this is typically set at the start of the script.
Your average `src` will be 8bit,
but you might occasionally run into 10bit sources as well.

```Py
trim = core.std.Trim(src, first=100, last=1000)
```
```Py
trim = src[100:1001]
```

`Trim` is used for trimming the video.
It's inclusive,
which means that it also adds the `last` frame given.
Another way to trim is by using Python Slices.
These are exclusive however,
so you need to take that into account.

Inclusive and exclusive work like this:

Let's say you have a number range.
This is what they'd look like with both methods:
```
Inclusive from 1 to 10:
1 2 3 4 5 6 7 8 9 10

Exclusive from 1 to 10:
1 2 3 4 5 6 7 8 9
```

Inclusive also **inclu**des
the final number in the given range,
whilst exclusive **exclu**des them.
Both of these have their pros and cons,
so it all comes down to preference.

```Py
scaled = core.resize.Spline36(src, width=1280, height=720)
```

`resize` has multiple "kernels"
that are used for [resampling](resampling.md#upsampling) the clip
to the given resolution.
Common resolutions are 1920x1080, 1600x900, 1280x720, 1024x576 and 848x480.
Nowadays most sources will be available in 1080p,
but there are advantages to downscaling,
like smaller filesizes.

You will often find grain or noise on a lot of sources.
You can get rid of that by denoising them.

![Manaria Friends — 04](images/basics_noise.png)

Look at her hair. There is a lot of grain on there, but some people may prefer that to be smooth instead.

```Py
import mvsfunc as mvf

denoise = mvf.BM3D(src, sigma=[4,2])
```

![Manaria Friends — 04 (denoised)](images/basics_denoised.png)

There are many denoisers available to use,
and they all have their strong and weak points.
Some will have better detail retention,
whilst others are a lot faster.

Just be aware that getting rid of grain
will often result in more problems popping up,
like the very obvious banding in this case.

Banding is caused by gradients
breaking up during compression.
In this picture,
you can see the gradient breaking up
very clearly in her hair.
To fix this, you use a debanding filter.

```Py
import mvsfunc as mvf
import kagefunc as kgf

denoise = mvf.BM3D(src, sigma=[4,2])
deband = core.f3kdb.Deband(denoise, range=18, y=40, cb=32, cr=32, grainy=12, grainc=0, output_depth=16)
grain = kgf.adaptive_grain(deband, strength=0.1)
```
![Manaria Friends — 04 (debanded and grained)](images/basics_debanded.png)

The banding is now less obvious,
and has been further hidden by adding grain.

Grain is something that some people like,
and others hate with a passion.
There are various ways that it can be used,
ranging from adding a particular mood to a scene
to preventing other artifacts from showing up.
It's also common for encoders to
add their own grain after denoising.

![Fairy Tail — NCOP20 (cleaned)](images/basics_clean.png)

This frame looks fairly clean overall,
but the encoding may introduce some banding
in the darker areas of this frame.
To combat this, we're adding grain
to just the darker areas.

```Py
import kagefunc as kgf

grain = kgf.adaptive_grain(deband, strength=0.3, luma_scaling=8)
```
![Fairy Tail — NCOP20 (grained)](images/basics_grained.png)



Another common issue is aliasing.
Aliasing an artifact that is commonly caused
by scaling or compression.

![Kimetsu no Yaiba — OP1](images/basics_aliasing.png)

Note the windows to the left.
You'll want to use anti-aliasing filters
to deal with this.

```Py
import vsTAAmbk as taa

aa = taa.TAAmbk(src aatype='Eedi3', opencl=True)
```

![Kimetsu no Yaiba - OP1 (anti-aliased)](images/basics_anti-aliased.png)

There are a couple of different anti-aliasing filters,
some faster than others.
Try out lighter AA if you can first,
like `Nnedi3`.



## Encoding the Result

{% term %}
$ vspipe.exe script.vpy -y - | x264.exe --demuxer y4m --some example --parameters here --output video.264 -
{% endterm %}

```sh
$ vspipe.exe script.vpy -y - | x264.exe --demuxer y4m --some example --parameters here --output video.264 -
```

Editors for VapourSynth usually have inbuilt support for encoding
scripts you wrote. Use `%encode --y4m <clip_variable>` in Yuuno or the GUI
provided by VSEdit.


## Transcoding Audio

examples for qaac, flac


## Muxing

mkvtoolnix

***

[^1]: "funcs" are a combination of wrappers written by people to perform different tasks.
Most of these can be found in the [VapourSynth Database][vsdb]

[vsdb]: http://vsdb.top/