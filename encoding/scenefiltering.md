# Scenefiltering

Scenefiltering can be hazardous to both your mind and body if used
extensively. Avoid scenefiltering if possible.

If you're an aspiring young encoder or someone who has been around
fansubbing for a while, you've probably heard the term "scenefiltering".
But what is scenefiltering? As the name suggests, it is simply filtering
different scenes or frames of a video clip distinctly.


## Creating the base filters

Normally, if you have a source that has great video quality with minimal
video artifacts, you can use a simple chain of filters on the entire
video without any concern. However, if you have a more complex source
with a myriad of video artefacts, you probably don't want to use the
same filters everywhere. For instance, one scene could have heavy
banding while another scene might have strong aliasing. If you were to
fix both of these issues by using strong filtering over the entire
video, it would likely result in detail loss in other scenes, which you
do not want. This is where scenefiltering comes in.

As always, you start by importing the VapourSynth module and loading
your video source:

```py
import vapoursynth as vs  # this can look different based on your editor
core = vs.get_core()      # the following uses VSEdit's format

src = core.lsmas.LWLibavSource("source.mkv")
```

Next, you need to come up with a common set of filters that can be
applied to most of the video. Usually, this filtering includes denoising
and debanding. If you can't come up with anything suitable, don't fret;
you'll have plenty more chances to filter later.

```py
filtered = default_filtering(src)
```

Now that you have your common filtering down, you need to create some
base filter chains. Go through some random scenes in your source and
write down parts of the filtering that best suits those scenes. You
should separate these as variables with proper names and sorting (group
filters by their type) to keep everything neat and clean. If you do this
part well, you will save yourself a lot of time later on, so take your
time. At this point, your script should look something like this:

```py
import vapoursynth as vs
core = vs.get_core()

src = core.lsmas.LWLibavSource("source.mkv")
filtered = default_filtering(src)

light_denoise = someDenoiseFilter(filtered)
heavy_denoise = someOtherDenoiseFilter(filtered)

aa = antialiasing(filtered)

light_deband = deband1(filtered)
med_deband   = deband2(filtered)
```


## Adding the frame ranges

Once you've done all of that, you're done with filtering your source—at
least for the most part. Now all you need to do is add
`ReplaceFramesSimple` calls. For this, you require the
plugin [RemapFrames](https://github.com/Irrational-Encoding-Wizardry/Vapoursynth-RemapFrames/releases) or
the native Python version in
[fvsfunc](https://github.com/Irrational-Encoding-Wizardry/fvsfunc/blob/master/fvsfunc.py).
`Rfs` is a shorthand for `ReplaceFramesSimple`
and fvsfunc has the alias `rfs`.

```py
import vapoursynth as vs
import fvsfunc as fvf
core = vs.get_core()

src = core.lsmas.LWLibavSource("source.mkv")
filtered = defaultFiltering(src)

### Denoising

light_denoise   = someDenoiseFilter(filtered)
heavy_denoise   = someOtherDenoiseFilter(filtered)
heavier_denoise = someStrongerDenoiseFilter(filtered)

denoised = fvf.rfs(filtered, light_denoise, mappings="")
denoised = fvf.rfs(denoised, heavy_denoise, mappings="")
denoised = fvf.rfs(denoised, heavier_denoise, mappings="")

### Anti-aliasing

eedi2_aa  = eedi2_aa_filter(denoised)
nnedi3_aa = nnedi3_aa_filter(denoised)

aa = fvf.rfs(denoised, eedi2_aa, mappings="")
aa = fvf.rfs(aa, nnedi3_aa, mappings="")

### Debanding

light_deband = deband1(aa)
med_deband   = deband2(aa)

debanded = fvf.rfs(aa, light_deband, mappings="")
debanded = fvf.rfs(debanded, med_deband, mappings="")
```

So you created all your base filters and added Rfs calls. Now what? You
still have to perform the most tedious part of this entire
process—adding frame ranges to those calls. The basic workflow is
quite simple:

1.  Go to the start of the scene. View the next 2-3 frames. Go to the
    end of the scene. View the previous 2-3 frames. Based on this,
    decide on your filtering for the particular scene. If still in
    doubt, look at other frames in the scene. Sometimes, you will find
    that different frames in the same scene require different filtering,
    but this is quite uncommon.
2.  Now that you know what filter to use, simply add the frame range to
    the respective Rfs call. To add a frame range to Rfs, you need to
    enter it as a string in the `mappings` parameter. The format for the
    string is `[start_frame end_frame]`. If you only want to add a
    single frame, the format is `frame_number`. An example should help
    you understand
    better:

    ```py
    # The following replaces frames 30 to 40 (inclusive) and frame 50
    # of the base clip with the filtered clip.
    filtered = fvf.rfs(base, filtered, mappings="[30 40] 50")
    ```

3.  Repeat with the next scene.

When scenefiltering, it is good practice to comment out Rfs calls you're
currently not using because they just make your script slower and eat up
memory.

This step can take anywhere from a few minutes to hours, depending on
the encoder and the source. Most of the time, the same filters can be
reused every episode with some minor changes here and there.


### Editor shortcuts / tips

If using VSEdit as your [editor](preparation.md#the-editor),
it can be helpful to use the
built-in bookmark functionality
to find the frame ranges of each scene.
There is a [small script][vsbookmark] that can generate
these bookmarks from your clip inside of VSEdit.

```py
# Editing a script called 'example01.vpy'
import ...
from vsbookmark import generate

generate(clip, 'example01')
clip.set_output()
```

When previewing your clip,
there will now be bookmarks generated on the timeline
allowing you to skip to the next scene using the GUI buttons.

---

Now you might ask, "Why did I have to create base filters for
everything?" The answer is that these base filters allow other filters
to be added on top of them. Let's say a scene requires `light_denoise`
but also needs `med_deband` on top of that. Just put the same frame
ranges in their Rfs calls and watch it happen. What if a scene requires
denoising stronger than `heavier_denoise` ? Simple. Add another denoising
filter instead of `heavier_denoise` like so:

```py
super_heavy_denoise = ultra_mega_super_heavy_denoise(filtered)

filtered = fvf.rfs(filtered, super_heavy_denoise, mappings="[x y]")
```

Using different denoisers on that same frame range is also possible, but
always consider the impacts on performance. Calling a strong, slow
denoise filter might still be faster (and better-looking) than calling a
weak, faster filter multiple times.

That should be all you need to know
about scenefiltering.

[vsbookmark]: https://gist.github.com/OrangeChannel/b9666b3650a3448589069d25dd6a394c
