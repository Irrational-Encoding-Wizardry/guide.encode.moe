# Resampling

Resampling is a technique applied in various
image processing tasks,
most prominently scaling/resizing,
but also shifting and rotation.

## Resizing

The most common class of resampling algorithms
used for resizing are the convolution-based resamplers.
As the name suggests,
these work by [convolving][Convolution] the image
with a filter function.
These filter functions,
also known as kernels,
are what the terms Bilinear/Bicubic/Lanczos/etc. generally refer to.
The [ImageWorsener documentation][ImageWorsener] features a great
visual explanation of how this process works in detail.
It is strongly recommended to read it.
If you wish to explore the mathematics behind the design
of these filters,
the [Sampling and Reconstruction chapter][Sampling chapter]
of [Physically Based Rendering][PBRT] is one of the best places
for a layman to start.

[Convolution]: https://en.wikipedia.org/wiki/Convolution
[Sampling chapter]: https://www.pbrt.org/chapters/pbrt_chapter7.pdf
[PBRT]: https://www.pbrt.org/
[ImageWorsener]: https://entropymine.com/imageworsener/resample/

### Filters

All resampling kernels behave slightly differently
and generate artifacts of differing kinds and severity.

It should be noted that there is no “objectively best” resampling filter,
so it is largely a matter of personal preference.
There are no hard and fast rules about
which resampler performs best for any given type of content,
so it’s best to test for yourself.

A short overview of the most common filters follows.
For a much more extensive explanation of the different filters,
including details on the exact algorithms,
see [ImageMagick’s guide][IM].

[IM]: http://www.imagemagick.org/Usage/filter/

##### Box filter / Nearest Neigbour

When upscaling,
the Box filter will behave just like
[Nearest Neighbour interpolation][NN],
that is,
it will just pick the closest pixel in the input image
for every output pixel.
This results in the source pixel grid being magnified
without any smoothing or merging of adjacent pixels,
providing a faithful representation of the original pixel grid.
This is very useful when inspecting an image up close
to examine the pixel structure,
or when enlarging [pixel art][pixel art],
but not suitable for regular content
due to the jagged lines and deformed details it causes.

When downscaling,
the Box filter behaves differently to Nearest Neighbour,
which continues to just pick the closest pixel and be done with it,
in that it merges adjacent pixels together.
Unlike most other filters, however,
it averages them evenly
instead of giving the central ones more weight.
(For example, reducing a 10 pixel row to 5 pixels
will average every pixel pair.)
This, again,
can be a useful property in specific cases,
but is not generally desirable.

The Box filter is available in VapourSynth
in the ``fmtconv`` plug-in:

```py
clip = core.fmtc.resample(src, w, h, kernel="box")
```

Nearest Neighbour interpolation is part of the built-in ``resize`` plug-in:

```py
clip = core.resize.Point(src, w, h)
```

Most script editors like VSEdit feature NN scaling in the preview;
it is recommended to use it over Bilinear
when making filtering decisions.

[NN]: https://en.wikipedia.org/wiki/Nearest-neighbor_interpolation
[pixel art]: https://en.wikipedia.org/wiki/Pixel_art

##### Bilinear / Triangle

Bilinear, also known as Triangle due to its graph’s shape,
is one of the most common algorithms in widespread use
because of its simplicity and speed.
However,
it generally creates all sorts of nasty artifacts
and is inferior in quality to most other filters.
The only advantage it offers is speed,
so don’t use unless you’re sure you have to.

VapourSynth example:

```py
clip = core.resize.Bilinear(src, w, h)
```

##### Mitchell-Netravali / Bicubic

The Mitchell-Netravali filter, 
also known as Bicubic,
is one of the most popular resampling algorithms,
and the default for many image processing programs,
because it is usually considered a good neutral default.

It takes two parameters, B and C,
which can be used to tweak the filter’s behaviour.
For upscaling, it is recommended to use values that satisfy the equation
``b + 2c = 1``.

The graph below outlines 
the various kinds of artifacts
different B-C-configurations produce.

![Bicubic B-C parameters](images/cubic_survey.gif)

Mitchell-Netravali generalizes all smoothly fitting
(continuous first derivative) piece-wise cubic filters,
so any of them can be expressed with the appropiate parameters.
Below you can find a list of common cubic filters
and their corresponding parameters in Mitchell-Netravali.

- B-Spline – b=1, c=0
- Hermite – b=0, c=0
- Mitchell-Netravali – b=1/3, c=1/3 (sometimes referred to as just “Mitchell”)
- Catmull-Rom – b=0, c=0.5
- Sharp Bicubic – b=0, c=1

Hermite is often considered one of the best choices for downscaling,
as it produces only minimal artifacting,
at the cost of slight blurriness.

VapourSynth example:

```py
clip = core.resize.Bicubic(src, w, h, filter_param_a=0, filter_param_b=0.5) # “filter_param_a” and “filter_param_b” refer to B and C, respectively
```

##### Lanczos

Lanczos is generally considered
a very high-quality resampler for upscaling,
especially its [EWA version][#ewa-elliptical-weighted-averaging-also-cylindrical-polar-circular].

It is usually slightly sharper than Mitchell (Bicubic b=c=1/3),
but might produce slightly more ringing.

Lanczos takes an additional parameter
that controls the filter’s number of lobes,
also called taps.
Increasing the number of lobes
improves sharpness at the cost of increased ringing.
You might occasionally see the tap count
appended to the filter name to clarify
the exact filter used, e.g. Lanczos2 for 2 taps.

For downscaling,
higher tap counts might help in
suppressing [Moiré effects][Moire].

[Moire]: http://www.imagemagick.org/Usage/filter/#aliasing

```py
clip = core.resize.Lanczos(src, w, h, filter_param_a=2) # “filter_param_a” specifies the tap count
```

##### Spline

Spline is another high-quality resizer.

Spline, like Lanczos,
can be finetuned by configuring its number of lobes.
Unlike Lanczos, 
however,
Splines with different tap counts are usually split
into seperate functions,
with ``(tap_count*2)**2`` appended to their name,
e.g. Spline36 for 3 taps, Spline64 for 4, etc.
(This number repesents the total amount of input pixels
involved in the calculation of any given output pixel.)

Spline36 is a very popular choice for downscaling,
since it is fairly artifact-free yet decently sharp.
For upscaling,
it looks similiar to Lanczos3,
though arguably slightly less artifacted.

VS example:

```py
clip = core.resize.Spline36(src, w, h)
```

Higher tap counts can be used via fmtconv:

```py
clip = core.fmtc.resample(src, w, h, kernel="spline", taps=6) # equivalent to Spline144
```

##### Gauss

The Gaussian filter is very special in that its [Fourier transform][^1]
is another Gaussian
whose width is antiproportional to the spatial function’s.
This can be harnessed to remove and amplify high frequencies 
in a very controllable way.
Widening the filter,
for example,
will confine the output to small frequencies (blurrier),
whereas squashing it will amplify higher frequencies (more aliasing).

In practice,
though,
the Gaussian filter isn’t all too useful for regular resizing.
However,
it can be used to accurately
emulate a Gaussian blur (when used without resizing) in VapourSynth.

For example:

```py
blurred = core.fmtc.resample(src, kernel="gauss", fh=-1, fv=-1, a1=1)
```

``fh=-1, fv=-1`` forces the processing when no resizing is performed.
``a1`` controls the blurring:
the higher,
the sharper the image.


#### Interpolation filters

It is sometimes distinguished between 
interpolation filters and non-interpolation filters.

Interpolation filters are those that, 
when applied “in-place”,
i.e. at the location of the input samples,
don’t alter the sample value.
Therefore,
they only interpolate “missing” values,
leaving the input samples untouched.

This is true for filters that evaluate to 0
at all integer positions except 0
or whose support is <= 1.
Examples include:
(Windowed) Sinc filters,
such as Lanczos,
Bicubic with B=0,
e.g. Hermite and Catmull-Rom,
and Triangle/Bilinear.

This can be a beneficial property in some cases,
for example the No-Op case.
No-Op means that no scaling, shifting or similiar is performed,
that is, the input is resampled at exactly the same positions.
In this case,
an interpolation filter will return the input image untouched,
whereas other filters will slightly alter it.

Another, more practical,
case where this property is useful
is when shifting an image by full pixel widths (integers),
again because input pixel values aren’t changed
but just relocated.

#### Two-dimensional resampling

There are two different ways to go about
resampling in two dimensions:

##### Tensor resampling (also: orthogonal, 2-pass, seperated)

The image is resampled in two seperate passes:
First it is resampled horizontally, then vertically.
This allows images to be treated 1-dimensionally
since each pixel row/colomn can be resampled seperately.
This method is considerably faster than EWA,
which is why it’s the much more common one;
generally, unless indicated otherwise,
this is what is used.

##### EWA (Elliptical Weighted Averaging) (also: cylindrical, polar, circular)

![Two-dimensional kernel. The support range is colored green.](images/polar.png)

All input samples whose [Euclidian distance][L2] to the pixel
is within the support range contribute to its value.
The Euclidian distance is passed to the filter kernel.
This is a lot more costly than tensor resampling in terms of runtime.

#### Scaling in modified colorspaces

The colorspace used when resampling
can significantly impact the output’s subjective quality.

##### Downscaling in linear light

Downscaling in gamma-corrected light instead of linear light
can sometimes noticeably dim the image.
(Scaling in linear light means
undoing the image’s [Gamma transform][gamma]
before resampling,
and re-applying it afterwards.)
To see why this happens,
consider this graph:

![The sRGB gamma curve. x is the encoded value, y is the brightness.](images/gamma.png)

When downscaling,
adjacent pixels are essentially
averaged together.
Let’s say we want to merge
pixels A and B.
Averaging the gamma-encoded values
would result in point C.
However,
C is clearly closer to A on the brightness scale.
This means,
*the average of the gamma-encoded values is always lower than the average brightness*,
dimming the image slightly overall.
The correct value,
located at the average brightness,
is marked as D on the graph.

This dimming effect is usually only noticeable
in dense color patterns,
e.g. small black text on a white background,
stars in the night sky, etc,
and much less so in blurrier areas.

See [this comparison][comp] for an example of linear vs gamma downscaling.

However,
this doesn’t mean downscaling in linear light
is always the right choice,
since it noticeably accentuates dark halos
introduced by scaling.
Besides,
the dimming may even be desirable in some cases like black text on white paper,
because it preserves readability.

If you choose to downscale in linear light,
make sure to use a sufficiently high bitdepth
so as to not introduce banding.

Example code for resizing in linear RGB light:

```py
linear = core.resize.Bicubic(src, format=vs.RGBS, transfer_in_s="709", transfer_s="linear", matrix_in_s="709")
scaled_linear = core.resize.Bicubic(linear, 640, 360)
scaled_gamma = core.resize.Bicubic(scaled_linear, format=src.format, transfer_s="709", transfer_in_s="linear", matrix_s="709")
```

[gamma]: https://en.wikipedia.org/wiki/Gamma_correction
[comp]: https://slowpics.org/comparison/8103b2d1-b9d4-4d7e-b7a7-3197ae999244

##### Upscaling in sigmoidized light

In order to attenuate both dark and white halos 
introduced by upscaling,
you can resize through a sigmoidized colorspace.

This means converting the linear RGB version of an image
to a custom colorspace with an S-shaped intensitiy curve
before scaling and converting it back afterwards.
What this does, essentially,
is decrease the image’s contrast
by pushing extreme values of both dark and bright
towards the middle.

Quoting Nicholas Robidoux from ImageMagick:

“You may decrease halos and increase perceptual sharpness by increasing the sigmoidal contrast (up to 11.5, say). Higher contrasts are especially recommended with greyscale images (even "false RGB greyscale" that have three proportional color channels). The downside of sigmoidization is that it sometimes produces "color bleed" artefacts that look a bit like cheap flexographic ("gummidruck") printing or chromatic aberration. In addition, sigmoidization's "fattening" of extreme light and dark values may not work for your image content. If such artefacts are obvious, push the contrast value down from 7.5 (to 5, for example, or even lower). Setting the contrast to 0 is equivalent to enlarging through linear RGB.“

Example code for VS:

```py
import havsfunc as hf
linear = core.resize.Bicubic(src, format=vs.RGBS, transfer_in_s="709", transfer_s="linear", matrix_in_s="709")
sigmoidized = hf.SigmoidInverse(linear, thr=0.5, cont=6.5) # cont corresponds to the “sigmoidal contrast” mentioned above
scaled_sigmoid = core.resize.Bicubic(sigmoidized, 640, 360)
de_sigmoidized = hf.SigmoidDirect(scaled_sigmoid, thr=0.5, cont=6.5)
scaled_gamma = core.resize.Bicubic(de_sigmoidized, format=src.format, transfer_s="709", transfer_in_s="linear", matrix_s="709")
```

---

## Shifting

Shifting an image by an arbitrary amount,
including non-integer values,
requires resampling as well.
For example,
left-shfting by a quarter pixel
will resample the image at the input samples’ positions minus 0.25.[^2]
This also means that,
unless a [interpolative filter](#interpolation-filters) is used,
even shifting by integer amounts will alter the image.

Side note:
It can be interesting to think of shifting
not as resampling at shifted pixel locations,
but as resampling at the input locations
with shifted kernels functions.

---
[^1]: The Fourier transform is an ubiqitous concept in image processing, so we strongly advise familiarizing oneself with at least the basics. A very good resource for this topic is [ImageMagick’s guide](http://www.imagemagick.org/Usage/fourier/)
[^2]: If you don’t understand what this means, read the resources linked [above][#Resampling].