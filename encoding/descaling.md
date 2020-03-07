# Descaling

Among the many tools available in an encoder's arsenal,
the ability to descale might arguably be one of the best.
But what does descaling actually mean?
In what way does it differ from normal downscaling?
How do you actually descale properly?
This guide will explain the groundwork for you
to start descaling effectively.


## Descaling vs. Downscaling

What the difference between downscaling and descaling is
is a question that gets asked fairly frequently.
Simply put,
downscaling is the act of resizing an image
to a smaller resolution than the original image,
while with descaling you are actively reversing the math
applied to an upscale,
reconstructing the original image before upscaling.

Descaling is generally the preferred method
of handling upscaled content whenever possible.
When performing a simple downscale,
information will be lost in the process.
A proper descale will, on the other hand,
(theoretically) preserve all the detail
that was actually there in the original image.
This offers a multitude of advantages,
like for example when dealing with artifacting
that was a result of a poor upscale.
You could instead undo the scaling
and use a better scaler to upscale it instead,
or keep it at its native resolution and
have less artifacting to worry about.

For a more thorough explanation on the intrinsics of descaling,
please refer to the [vapoursynth-descale Github page][vapoursynth-descale].

That said, if you can't perform a good descale,
you will usually end up with haloing/ringing artifacting,
as illustrated below:

![Lineart messed up due to poor descaling](images/descale/descale_ubw_00_bad.png)

<div class="warning box"><p>
Only descale if you can be sure,
beyond reasonable doubt,
that you have figured out the correct resolution and kernel.
</p></div>

[vapoursynth-descale]: https://github.com/Irrational-Encoding-Wizardry/vapoursynth-descale


# Discerning the native resolution

The first step to descaling is to figure out
what the native resolution of a frame is.
One way to do this is by descaling to all potential resolutions,
upscaling the descaled image with the same kernel,
and comparing the two.
The artifacts created by descaling to a wrong resolution
are generally more obvious than
the artifacts created by using the wrong kernel.
Luckily for us,
there's already a tool out there
you can use for this.

[getnative.py][getnative] is a common tool
used for figuring out the native resolution of an image.
It will return a graph showcasing all the resolutions
it tried to descale to,
as well as a plaintext file
with all the relative errors listed.
Here's an example:

![](images/descale/descale_owari_01_frame.png)

![Results from "getnative.py -k bicubic -b 0 -c 1/2"](images/descale/descale_owari_01_graph.png)

What you want to look out for are very clear spikes.
You can spot one of those here,
pointing towards a height of 720.
When using getnative,
the ideal frame to use is a relatively bright one
with clearly defined lineart
and no obvious effects or filtering applied to it
(like for example blur, glow, or heavy grain).
Here is another example of such a frame:

![](images/descale/descaled_illya_02_frame.png)

![Result from the default settings](images/descale/descaled_illya_02_graph.png)

If you've got a graph without any clear spikes,
it's usually a bad idea to try descaling that.
It's likely that you're either working with native 1080p content,
an already-descaled encode,
or a source that has been warped too much to properly descale.

![](images/descale/descaled_fgo_op_encoded_frame.png)

![Running getnative on frame of a already-rescaled encode](images/descale/descaled_fgo_op_encoded_graph.png)

Also of note is that you should be careful
to not pick a frame with credits to run getnative on.
Credits are usually added at the very end,
after the clip has already been upscaled.
Those will need to be handled separately.

![](images/descale/descaled_yaiba_17_credits_frame.png)

![Credits and other native 1080p elements mess with the graph](images/descale/descaled_yaiba_17_credits_graph.png)

There is also letterboxing.
When talking about letterboxing,
we refer to the black bars
you occasionally find around a video.
Running these through getnative will result in very odd graphs
that you can't discern much from.

![](images/descale/descaled_crystar_op1_letterbox_frame.png)

![There's no way to figure out the native resolution from this](images/descale/descaled_crystar_op1_letterbox_graph.png)

And finally, we run into heavily post-processed videos.
These are usually impossible to accurately descale
due to additional post-processing that was applied during the scaling,
or due to the scaler used being so destructive
that it leaves no detail to preserve.

![](images/descale/descale_paniponidash_op2_qtec_frame.png)

![This is what a murder scene looks like](images/descale/descale_paniponidash_op2_qtec_graph.png)

[getnative]: https://github.com/Infiziert90/getnative


# Filterchains

Once you've figured out the native resolution,
you can move on to the actual descaling.
There's two common ways to do this.

1. Using the [descale][] plugin.
1. Using `invks` from the [fmtc][] plugin.

For convenience's sake,
we'll be keeping it to just `descale` for this guide.

There are a couple very common kernels
used in anime production:

* Bilinear
* Bicubic b=1/3, c=1/3 (Mitchell-Netravali)
* Bicubic b=0, c=0.5 (Catmull-Rom)

Occasionally, although rare,
you may also run into the following kernels:

* Lanczos taps=3
* Lanczos taps=4
* Spline16
* Spline36
* Bicubic b=1, c=0 (B-Spline)
* Bicubic b=0, c=1 (Sharp Bicubic)
* Bicubic b=0, c=0 (Hermite)
* Bicubic b=0.3782, c=0.3109 (Robidoux)
* Bicubic b=0.2620, c=0.3690 (Robidoux Sharp)
* Bicubic b=0.6796, c=0.1602 (Robidoux Soft)

The most reliable way to discern
which kernel was used is by descaling the clip,
upscaling it again with the same kernel,
and then comparing it with the original frame.
Here is an example script using `compare` and `test_descale` from [lvsfunc][]
to easily compare frames from two clips:

```py
import lvsfunc as lvf

clip = core.lsmas.LWLibavSource(r"PATH/TO/VIDEO.m2ts")

descaled = lvf.test_descale(clip, height=720, kernel='bicubic', b=1/3, c=1/3)

comp = lvf.compare(clip, descaled)
comp.set_output()
```

The most reliable way to check for differences in vsedit is
by zooming in 4x with Nearest Neighbor
and switching between the frames
with the left and right arrow buttons.
You can enable the zoom here:

![The zoom bar](images/descale/descale_zoom_a.png)

Click "No zoom" and select "Fixed ratio".
You can set the zoom level next to it,
and the scaler used next to that.
Make sure to set it to Nearest!

Figuring out what to look out for
is a case of trial and error.
The best thing to keep an eye on
is lineart as well as small detail like stars.
It isn't uncommon for noise to become weaker after a rescale
(since that's usually added after upscaling, too),
so try not to be too distracted by that.

[descale]: https://github.com/Irrational-Encoding-Wizardry/vapoursynth-descale
[fmtc]: https://forum.doom9.org/showthread.php?t=166504
[lvsfunc]: https://github.com/Irrational-Encoding-Wizardry/lvsfunc


# Re-scaling

A fairly common practice is
to upscale the descaled clip to a standard resolution
(if it isn't already one, like for example 720p).
The following scalers are generally recommended for this task.

The most common scaler for re-scaling is [nnedi3_rpow2][].
It returns consistently good-looking lines
without damaging other detail.
Since it's an image doubler,
it's important to remember that you'll have to scale it down afterwards.
Nnedi3_rpow2 can do this internally,
as demonstrated below:

```py
from nnedi3_rpow2 import nnedi3_rpow2

upscaled = nnedi3_rpow2(descaled, width=1920, height=1080)
```

Similarly, [nnedi3_resample][] is also used by some people
and might give better results
with some additional tweaking of the settings.
Like nnedi3_rpow2, it's an image doubler
and needs to be downscaled after.

```py
from nnedi3_resample import nnedi3_resample

upscaled = nnedi3_resample(descaled, width=1920, height=1080)
```

Of course you can still opt for more generic scalers,
like Spline36 or Lanczos.

```py
upscaled = core.resize.Spline36(descaled, width=1920, height=1080)
```

```py
upscaled = core.resize.Lanczos(descaled, width=1920, height=1080, filter_param_a=3)
```

A couple more extreme examples
would be using [waifu2x][] or [upscaled_sraa][]
to upscale it back to 1080p.
These are far more destructive and expensive to compute
but might yield overall better results
depending on your source.

```py
upscaled = core.caffe.Waifu2x(descaled, noise=-1, scale=2, model=6, cudnn=True)
upscaled = core.resize.Spline36(upscaled, width=1920, height=1080)
```
```py
import lvsfunc as lvf

upscaled = lvf.upscaled_sraa(descaled, h=1080)
```

[nnedi3_rpow2]: https://github.com/darealshinji/vapoursynth-plugins/blob/master/scripts/nnedi3_rpow2.py
[nnedi3_resample]: https://github.com/mawen1250/VapourSynth-script/blob/master/nnedi3_resample.py
[waifu2x]: https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Waifu2x-caffe
[upscaled_sraa]: https://github.com/Irrational-Encoding-Wizardry/lvsfunc/blob/d4bdfa76f9aa94a49bd038d98e8b28876ab7332c/lvsfunc.py#L515-L582


# Handling native 1080p content

When descaling,
it's important to be wary of native 1080p elements.
A common example of this is credits,
which are usually added after upscaling.
These will require being masked.

The easiest way to do this
is by using the re-upscaled clip
used for checking for the kernel
and using an expression to get the absolute difference
between that and the original frame,
creating a mask.
Afterwards you can expand the mask
to make sure it catches all the credits properly.
This should work fine for most of the frame
(given that you descaled it correctly).
Here is an example of that:

```py
import vsutil
import kagefunc as kgf
import vsutil
from nnedi3_resample import nnedi3_resample

clip_y = vsutil.get_y(clip)
descaled = core.descale.Debicubic(clip_y, 1550, 872, b=1/3, c=1/3)
upscaled = core.resize.Spline36(descaled, 1920, 1080, filter_param_a=1/3, filter_param_b=1/3)
credit_mask = core.std.Expr([clip_y, upscaled], 'x y - abs')
credit_mask = vsutil.iterate(credit_mask, core.std.Maximum, 4)
credit_mask = vsutil.iterate(credit_mask, core.std.Inflate, 2)
credit_mask = nn3_rs.credit_mask.std.Binarize(0.05)

rescaled = nnedi3_resample(descaled, width=1920, height=1080)
merged = core.std.MaskedMerge(rescaled, planes[0], credit_mask)

merged = core.std.ShufflePlanes([merged, clip], [0, 1, 2], vs.YUV)
```

![](images/descale/descaled_symphoxv_credits_frame_non-masked.png)

![A mask to catch the credits in Symphogear XV's OP](images/descale/descaled_symphoxv_credits_mask.png)
![Merge the original credits with a re-upscaled frame](images/descale/descaled_symphoxv_credits_frame_masked.png)

[Here][rescaled] is a link to a comparison.

This can also be done when descaling
to a resolution that you plan to stick with.
Since the credits will still be messed up,
you will need to replace them with a downscaled clip.

```py
y, u, v = vsutil.split(clip)
descaled = core.descale.Debicubic(y, 1280, 720, b=0, c=1/2)
upscaled = core.resize.Bicubic(descaled, 1920, 1080, filter_param_a=0, filter_param_b=1/2)
downscaled = core.resize.Spline36(y, 1280, 720)
credit_mask = core.std.Expr([y, upscaled], 'x y - abs')
credit_mask = kgf.iterate(credit_mask, core.std.Maximum, 6)
credit_mask = kgf.iterate(credit_mask, core.std.Inflate, 2)
credit_mask = core.std.Binarize(credit_mask, 0.05)
credit_mask = core.resize.Spline36(credit_mask, 1280, 720)

y_scaled = core.std.MaskedMerge(descaled, downscaled, credit_mask)
u_scaled = core.resize.Bicubic(u, 1280, 720)
v_scaled = core.resize.Bicubic(v, 1280, 720)

merged = core.std.ShufflePlanes([y_scaled, u_scaled, v_scaled], [0, 0, 0], vs.YUV)
```

![](images/descale/descale_casefiles_ed_credits_frame_non-masked.png)

![Downscaled mask that catches all the credits](images/descale/descale_casefiles_ed_credits_mask.png)

![Merge downscaled credits with descaled clip](images/descale/descale_casefiles_ed_credits_frame_masked.png)

[Here][downscaled] is also a link to a comparison.

[rescaled]: https://slow.pics/c/ZCVD7jdZ
[downscaled]: https://slow.pics/c/gVIda96h
