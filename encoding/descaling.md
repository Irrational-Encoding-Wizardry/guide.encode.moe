# Descaling

The ability to descale is a wonderful tool
to have in any encoder's arsenal.
You may be familiar with
how most anime are not native 1080p,
but a lower resolution.
But how do we make use of that?
How do you find the native resolution
and reverse the upscale?


## When and where to descale

There's a lot of opportunities
where descaling might prove beneficial.
For example say you've got
a very blurry Blu-ray source.
Rather than sharpening it,
you might want to consider
checking if it's possible to descale it
and maybe alleviate a lot of
the blurriness that way.
Or the opposite:
say you've got a source full of ringing.
It might've been upscaled
using a very sharp kernel,
so it's worth a try
to see if it can be descaled.
It's no surprise that descaling tends to
offer far better lineart
than usual resampling does.

However, descaling is not always an option.
The worse your source is,
the less likely it is that
descaling will be a better alternative
to a simple resample.
If you've got a source
full of broken gradients
or noise patterns,
like your average simulcast stream,
descaling might only hurt the overall quality.
Sadly, sources with a lot of post-processing
might also prove tough to properly descale
without dabbling into specific masks.
However, so long as you've got
a source with nice, clean lineart,
descaling might be a viable option,
and possibly nullify the need
of a lot of other filtering.


## Preparation

To prepare for figuring out the native resolution,
you'll want to use [getnative][],
a Python script designed around
figuring out the resolution
a show was animated at.
For the actual descaling,
make sure to grab BluBb-mADe's [descale][].

One important thing
to keep in mind when descaling
is that you will never find
"the perfect descaling settings".
This is because the best available sources to consumers,
usually Blu-rays,
aren't lossless.
There's always going to be some differences
from the original masters
which makes it impossible
to perfectly descale something.
However, usually those differences
are so small that they're negligible.
If you run into a case where
you can only get high relative errors,
descaling can be highly destructive.
It's instead recommended to downscale
as you would normally,
or to not mess with scaling at all.

[getnative]: https://github.com/Infiziert90/getnative
[descale]: https://github.com/BluBb-mADe/vapoursynth-descale


## Finding out the native resolution

To figure out what
the native resolution of an anime is,
first you need a good frame to test.
Ideally you'll want a bright frame
with as little blur as possible of high quality
(Blu-ray or very good webstreams).
It also helps to not have
too many post-processed elements in the picture.
Whilst it is most definitely possible
to get pretty good results with "bad" frames,
you'll want to generally lower that chance
as much as possible.

Here's some examples of "bad" frames.

![Manaria Friends Ep01 frame 1](images/descale_manaria01.png)

This picture is dark.
It also has some effects over it.

![Manaria Friends Ep01 frame 2](images/descale_manaria02.png)

This picture is also very dark,
and has even more effects over it.

![Manaria Friends Ep01 frame 3](images/descale_manaria03.png)

Heavy dynamic grain will almost always give bad results.

![Manaria Friends Ep01 frame 4](images/descale_manaria04.png)

This is a nice frame to use as reference.
The background is a bit blurry,
but it isn't full of effects
and is fairly bright.
The lineart is very clear.

We will now make use of the getnative.py script
to figure out what resolution
this anime was produced at.
Run the following in your terminal:

```bash
$ python getnative.py "Manaria Friends Ep01 frame 4.png"
```

It should show the following:

```
Using imwri as source filter
501/501
Kernel: bicubic AR: 1.78 B: 0.33 C: 0.33
Native resolution(s) (best guess): 878p
done in 18.39s
```

If you look in the directory
that you ran the script in,
you will find a new folder
called "getnative".
You can find the following graph
in there as well:

![Manaria_Friends-ep1_04_graph](images/descale_graph.png)

You should be looking for a low relative error.
In this case it very clearly points to 878p.


## Descaling

Now it's time to actually start descaling.
Open up your Vapoursynth editor of choice,
and import the clip:

```Py
src = lvf.src(r"BDMV/[BDMV][190302][マナリアフレンズ I]/BD/BDMV/STREAM/00007.m2ts")
```

The next issue is figuring out
what was used to [upsample](resampling.md#upsampling) the show.
By default,
getnative.py checks with Mitchell-Netravali
(bicubic b=1/3, c=1/3).
However, it might have also been upscaled
using other kernels,
like Spline or Bilinear.
The best way to figure out
what is used is to simply try out
a bunch of and use your eyes.
Check for common scaling-related artifacting,
like haloing,
ringing,
aliasing,
etc.

For bicubic it is important
to keep in mind that
you will typically find that
the values match the following mathmatical expressions:

`b + 2c = 1` or `b + c = 1`

It could also just be 0 or 1.

Whilst this isn't a 100% guarantee,
this is the most common approach
to resampling using bicubic,
so it's worth keeping in mind.

Here's an example of the previous frame
when descaled using various kernels and settings
(note that descale requires either GrayS, RGBS, or YUV444PS.
I'll be using `split` and `join` from `kagefunc` to split the planes
and then join them again in this example,
and `get_w` from `vsutil` to calculate the width):

[Comparison between frames][manaria_compare]

```Py
import vapoursynth as vs
import vsutil
import kagefunc as kgf
import fvsfunc as fvf
core = vs.core

src = core.lsmas.LWLibavSource("BDMV/[BDMV][190302][マナリアフレンズ I]/BD/BDMV/STREAM/00007.m2ts")
src = fvf.Depth(src, 32)

Y, U, V = kgf.split(src)
width = vsutil.get_w(878)
height = 878

descale_a = core.descale.Debilinear(Y, width, height).resize.Bilinear(1920, 1080)                                                        # Bilinear
descale_b = core.descale.Debicubic(Y, width, height, b=1/3, c=1/3).resize.Bicubic(1920, 1080, filter_param_a=1/3, filter_param_b=1/3)    # Mitchell-Netravali
descale_c = core.descale.Debicubic(Y, width, height, b=0, c=1).resize.Bicubic(1920, 1080, filter_param_a=0, filter_param_b=1)            # Sharp Bicubic
descale_d = core.descale.Debicubic(Y, width, height, b=1, c=0).resize.Bicubic(1920, 1080, filter_param_a=1, filter_param_b=0)            # B-Spline
descale_e = core.descale.Debicubic(Y, width, height, b=0, c=1/2).resize.Bicubic(1920, 1080, filter_param_a=0, filter_param_b=1/2)        # Catmull-rom
descale_f = core.descale.Despline36(Y, width, height).resize.Spline36(1920, 1080)                                                        # Spline36

descaled = kgf.join([descale_a, U, V])
descaled.set_output()
```

You might realize that after descaling,
we are immediately upscaling the frame
with the same kernel and values again.
This is done so we can compare the before and after.
The closer the new frame is to the old one,
how more likely it is that you've got the correct kernel.
Zooming in on the frame at 4x magnification or higher
will help immensely.
An alternative that you can do
is to simply descale until
you've got what you believe to be the best result.
It's faster to do it this way,
but might be less accurate.

[manaria_compare]: https://slowpics.org/comparison/61e39e1e-d074-4d83-b7c9-b0f4e1861855


## Credits and other native 1080p elements

There is one very, very important thing
to keep in mind when descaling:

*Credits are usually done in 1080p*.

There are various masks you can use
to help with dealing with that issue,
but it might be better
to make use of existing wrappers instead.
For this example I'll
be using `inverse_scale` from kagefunc.

```Py
descaled = kgf.inverse_scale(src, height=878, kernel='bicubic', b=0, c=1/2, mask_detail=True)
```

We can make use of the mask
that `inverse_scale` uses internally
as well.

```Py
descaled = kgf.inverse_scale(src, height=874, kernel='bicubic', b=0, c=1/2)
descaled_mask = kgf._generate_descale_mask(vsutil.get_y(core.resize.Spline36(src, descaled.width, descaled.height)), vsutil.get_y(descaled), kernel='bicubic', b=0, c=1/2)
```

![KaguyaOP_credits_mask](images/descale_credits_mask.png)
![KaguyaOP_descaled](images/descale_credits.png)

Note that if you see the mask
catching a lot of other stuff,
you might want to consider *not* descaling
that particular frame,
or to try a different kernel/values.
Chances are that you're either
using the wrong kernel
or that the frames you're looking at are native 1080p.

![native1080.png](images/descale_native1080.png)

![dontdescalethis.png](images/descale_dontdescalethis.png)


## Dealing with bad descaling

There are various things you can do
to deal with scenes that have issues
even after descaling.
`Eedi3` stands out in particular
as a fantastic AA filter
that really nails down bad lineart
caused by bad descaling.
Just try not to rely on it too much,
as it is by all means a "cheat code".
It's also incredibly slow,
so you might want to
[use it on just a couple of frames at a time](scenefiltering.md)
rather than over the entire clip.

Other than Eedi3,
usually the results of bad descaling
are so destructive that
there isn't much you can do.
If you have an encode that's
badly descaled,
you're better off
finding a different one.
If you've got bad results
after descaling yourself,
try a different kernel or values.
Alternatively,
try not descaling at all.

At the end of the day,
as mentioned in the introduction,
you can't descale everything perfectly.
Sometimes it's better to think of it
as a magical anti-ringing/haloing/aliasing filter
(in conjunction with a good upscaling filter
like nnedi3_rpow2)
rather than a scaler.

For example,
here it was used
specifically to fix up
some bad aliasing
in the source.

![akanesasu_src.png](images/descale_akanesasu_src.png)
![akanesasu_rescaled.png](images/descale_akanesasu_rescaled.png)

```py
scaled = kgf.inverse_scale(src, height=900, kernel='bicubic', b=0.25, c=0.45, mask_detail=True)
scaled = nnedi3_rpow2(scaled).resize.Spline36(1920, 1080)
```

Note how this fixed
most of the aliasing
on the CGI model.
