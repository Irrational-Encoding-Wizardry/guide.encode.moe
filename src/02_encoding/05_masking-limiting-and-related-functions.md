# Masking, Limiting, and Related Functions

    There are filters, which changes the video in various ways, and then
there are ways to change the filtering itself. There are likely hundreds
of different techniques at your disposal for various situations, using
masks to protect details from smoothing filters, blending two clips with
different filtering applied, and countless others- many of which haven't
been thought of yet. This article will cover:

  - Masking and Merging
  - Limiting
  - Reference clips
  - Expressions and Lookup Tables
  - Runtime functions
  - Prefiltering

#### Masking

    Masking refers to a broad set of techniques used to merge multiple
clips, usually one filtered clip merged with a source clip according to
an overlay mask. A mask clip may contain any information generated from
a pixel-wise operation.Vapoursynth includes some basic tools for
manipulating masks as
well:

[**std.Minimum/std.Maximum**](http://www.vapoursynth.com/doc/functions/minimum_maximum.html)

TODO

[**std.Inflate/std.Deflate**](http://www.vapoursynth.com/doc/functions/deflate_inflate.html)

TODO

[**std.Binarize**](http://www.vapoursynth.com/doc/functions/binarize.html)

    Split the luma/chroma values of any clip into one of two values,
according to a fixed threshold. For instance, binarize an edgemask to
white when edge values are at or above 24, and set values lower to
0:`mask.std.Binarize(24, v0=0, v1=255)`

    For methods of creating mask clips, there are a few general
categories...

**Line masks**

    These are used for normal edge detection, which is useful for
processing edges or the area around them, like anti-aliasing and
deringing. The traditional edge detection technique is to apply one or
more convolutions, focused in different directions, to create a clip
containing what you might call a gradient vector map, or more simply a
clip which has brighter values in pixels where the neighborhood
dissimilarity is higher. The main ones I would recommend would be
Prewitt (core), Sobel (core), and kirsch (kagefunc).

    There are also some edge detection methods that use prefiltering
when generate the mask. The most common of these would be TCanny, which
applies a gaussian blur before creating a 1-pixel-thick Sobel mask. The
most noteworthy pre-processed edge mask would be kagefunc's
retinex\_edgemask filter, which at least with cartoons and anime, is
unmatched in its accuracy. This is the mask to use if you want edge
masking with ALL of the edges and nothing BUT the edges.

    One more edge mask worth mentioning is the mask in dehalohmod, which
is a black-lineart mask well-suited to dehalo masking. Internally it
uses a mask called a Camembert to generate a larger mask and limits it
to the area affected by a line-darkening script. The main mask has no
name and is simply dhhmask(mode=3)

 

Example: Build a simple dehalo mask**
**

 

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p><span style="color: #999999;">#black line mask</span></p>
<p>mask = zz.dhhmask(src)</p>
<p> </p>
<p><span style="color: #999999;">#grow mask to cover halos</span></p>
<p>mask_outer = kgf.iterate(mask, <span style="color: #3366ff;">core.std.Maximum</span>, 3)</p>
<p> </p>
<p><span style="color: #999999;">#extend a bit and shrink back to exclude close, adjacent lines</span></p>
<p>mask_inner = <span style="color: #3366ff;">core.std.Maximum</span>(mask_outer)</p>
<p>mask_inner = kgf.iterate(mask_inner, <span style="color: #3366ff;">core.std.Minimum</span> ,4)</p>
<p> </p>
<p>halos = <span style="color: #3366ff;">core.std.Expr</span>([mask_outer, mask_inner], <span style="color: #800080;">'x y -'</span>)</p></td>
</tr>
</tbody>
</table>

 

    I would also lump the range mask (or in masktools, the "min/max"
mask) into this category, which is a very simple masking method that
returns a clip made up of the maximum value of a range of neighboring
pixels minus the minimum value of the range, as so:

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p>clipmax = <span style="color: #3366ff;">core.std.Maximum</span>(clip)<br />
clipmin = <span style="color: #3366ff;">core.std.Minimum</span>(clip)</p>
<p><br />
minmax = <span style="color: #3366ff;">core.std.Expr</span>([clipmax, clipmin], 'x y -')</p></td>
</tr>
</tbody>
</table>

    The most common use of this mask is within GradFun3. In theory, the
neighborhood variance technique is the perfect fit for a debanding mask.
Banding is the result of 8 bit color limits, so we mask any pixel with a
neighbor higher or lower than one 8 bit color step, thus masking
everything except potential banding. But alas, grain induces false
positives and legitimate details within a single color step are smoothed
out, therefor debanding will forever be a balancing act between detail
loss and residual artifacts.

 

**Diff masks**

    A diff(erence) mask is any mask clip generated using the variance of
two clips. There are many, many different ways to use this type of mask,
from limiting a difference to a threshold, processing a filtered
difference itself, or smoothing -\> processing the clean clip -\>
overlaying the original grain. They can also be used in conjunction with
line masks, for example: kagefunc's hardsubmask uses a special edge mask
with a diff mask, and uses core.misc.Hysteresis to grow the line mask
into diff mask).

 

Example: Create a descale mask for white non-fading credits with extra
protection for lines (16 bit input)

 

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p>src16 = kgf.getY(last)</p>
<p>src32 = fvf.Depth(src16, 32)</p>
<p> </p>
<p>standard_scale = <span style="color: #3366ff;">core.resize.Spline36</span>(last, 1280, 720, format=vs.YUV444P16, resample_filter_uv=<span style="color: #800080;">'spline16'</span>)</p>
<p> </p>
<p>inverse_scale = <span style="color: #3366ff;">core.descale.Debicubic</span>(src32, 1280, 720)</p>
<p>inverse_scale = fvf.Depth(inverse_scale, 16)</p>
<p> </p>
<p><span style="color: #999999;">#absolute error of descaling</span></p>
<p>error = <span style="color: #3366ff;">core.resize.Bicubic</span>(inverse_scale, 1920, 1080)</p>
<p>error = <span style="color: #3366ff;">core.std.Expr</span>([src, error], <span style="color: #800080;">'x y - abs'</span>)</p>
<p> </p>
<p><span style="color: #999999;">#create a light error mask to protect smaller spots against halos aliasing and rings</span></p>
<p>error_light = <span style="color: #3366ff;">core.std.Maximum</span>(error, coordinates=[0,1,0,1,1,0,1,0])</p>
<p>error_light = <span style="color: #3366ff;">core.std.Expr</span>(error_light,<span style="color: #800080;"> '65535 x 1000 / /'</span>)</p>
<p>error_light = <span style="color: #3366ff;">core.resize.Spline36</span>(error_light, 1280, 720)</p>
<p> </p>
<p><span style="color: #999999;">#create large error mask for credits, limiting the area to white spots</span></p>
<p><span style="color: #999999;">#masks are always full-range, so manually set fulls/fulld to True or range_in/range to 1 when changing bitdepth</span></p>
<p>credits = <span style="color: #3366ff;">core.std.Expr</span>([src16, error], <span style="color: #800080;">'x 55800 &gt; y 2500 &gt; and 255 0 ?'</span>, vs.GRAY8)</p>
<p>credits = <span style="color: #3366ff;">core.resize.Bilinear</span>(credits, 1280, 720)</p>
<p>credits = <span style="color: #3366ff;">core.std.Maximum</span>(credits).std.Inflate().std.Inflate()</p>
<p>credits = fvf.Depth(credits, 16, range_in=1, range=1)</p>
<p> </p>
<p>descale_mask = <span style="color: #3366ff;">core.std.Expr</span>([error_light, credits], <span style="color: #800080;">'x y -'</span>)</p>
<p> </p>
<p>output = kgf.getY(standard_scale).std.MaskedMerge(inverse_scale, descale_mask)</p>
<p>output = muvf.MergeChroma(output, standard_scale)</p></td>
</tr>
</tbody>
</table>

 

#### Single and multi-clip adjustments with std.Expr and friends

    Vapoursynth's core contains many such filters, which can manipulate
one to three different clips according to a math function. Most, if not
all, can be done (though possibly slower) using std.Expr, which I will
cover at the end of this
sub-section.

[**std.MakeDiff**](http://www.vapoursynth.com/doc/functions/makediff.html)
and[**std.MergeDiff**](http://www.vapoursynth.com/doc/functions/mergediff.html)

    Subtract or add the difference of two clips, respectively. These
filters are peculiar in that they work differently in integer and float
formats, so for more complex filtering float is recommended whenever
possible. In 8 bit integer format where neutral luminance (gray) is 128,
the function is `clip1 - clip2 + 128` for MakeDiff and `clip1 + clip2
- 128` for MergeDiff, so pixels with no change will be gray.

    The same is true of 16 bit and 32768. The float version is simply
`clip1 - clip2` so in 32 bit the difference is defined normally,
negative for dark differences, positive for bright differences, and null
differences are zero.

    Since overflowing values are clipped to 0 and 255, changes greater
than 128 will be clipped as well. This can be worked around by
re-defining the input clip as so:

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p>smooth = <span style="color: #3366ff;">core.bilateral.Bilateral</span>(sigmaS=6.4, sigmaR=0.009)</p>
<p>noise = <span style="color: #3366ff;">core.std.MakeDiff</span>(src, smooth) <span style="color: #999999;"># subtract filtered clip from source leaving the filtered difference</span></p>
<p>smooth = <span style="color: #3366ff;">core.std.MakeDiff</span>(src, noise) <span style="color: #999999;"># subtract diff clip to prevent clipping (doesn't apply to 32 bit)</span></p></td>
</tr>
</tbody>
</table>

 

[**std.Merge**](http://www.vapoursynth.com/doc/functions/merge.html)

TODO

**[std.MaskedMerge](http://www.vapoursynth.com/doc/functions/maskedmerge.html)**

TODO

 

[**std.Expr**](http://www.vapoursynth.com/doc/functions/expr.html)

TODO

[**std.Lut**](http://www.vapoursynth.com/doc/functions/lut.html) and
[**std.Lut2**](http://www.vapoursynth.com/doc/functions/lut2.html)

    May be slightly faster than Expr in some cases, otherise they can't
really do anything that Expr can't. You can substitute a normal Python
function for the RPN expression, though, so you may still find it
easier. See link for usage information.

#### Limiting

 TODO

#### Referencing

 TODO - probably just merge with "Limiting"

#### Runtime filtering with FrameEval

 TODO

Example: Strong smoothing on scene changes (i.e. for MPEG-2 transport
streams)

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p><span style="color: #33cccc;">from</span> functools<span style="color: #33cccc;"> import</span> partial</p>
<p> </p>
<p>src = <span style="color: #3366ff;">core.d2v.Source</span>()</p>
<p>src = ivtc(src)</p>
<p>src = haf.Deblock_QED(src)</p>
<p> </p>
<p>ref = <span style="color: #3366ff;">core.rgvs.RemoveGrain</span>(src, 2)</p>
<p> </p>
<p><span style="color: #999999;"># xvid analysis is better in lower resolutions</span></p>
<p>first = <span style="color: #3366ff;">core.resize.Bilinear</span>(ref, 640, 360).wwxd.WWXD()</p>
<p>last = <span style="color: #3366ff;">core.std.DuplicateFrames</span>(first, src.num_frames - 1).std.DeleteFrames(0)</p>
<p> </p>
<p><span style="color: #999999;"># copy prop to last frame of previous scene</span></p>
<p>propclip = <span style="color: #3366ff;">core.std.ModifyFrame</span>(first, clips=[first, last], selector=shiftback)</p>
<p> </p>
<p><span style="color: #33cccc;">def </span>shiftback(n, f):</p>
<p>    both = f[0].copy()<br />
    <span style="color: #33cccc;"> if</span> f[1].props.SceneChange == 1:<br />
         both.props.SceneChange = 1</p>
<p>  <span style="color: #33cccc;">  return</span> both</p>
<p> </p>
<p><span style="color: #33cccc;">def</span> scsmooth(n, f, clip, ref):</p>
<p>  <span style="color: #33cccc;">  if </span>f.props.SceneChange == 1:</p>
<p>        clip = <span style="color: #3366ff;">core.dfttest.DFTTest</span>(ref, tbsize=1)</p>
<p>    <span style="color: #33cccc;">return</span> clip</p>
<p> </p>
<p>out = <span style="color: #3366ff;">core.std.FrameEval</span>(src, partial(scsmooth, clip=src, ref=ref), prop_src=propclip)</p></td>
</tr>
</tbody>
</table>

 

#### Prefilters

TODO

 

Example: Deband a grainy clip with f3kdb (16 bit input)

 

<table>
<colgroup>
<col style="width: 100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><p>src16 = last</p>
<p>src32 = fvf.Depth(last, 32)</p>
<p> </p>
<p><span style="color: #999999;"># I really need to finish zzfunc.py :&lt;</span></p>
<p>minmax = zz.rangemask(src16, rad=1, radc=0)</p>
<p> </p>
<p><span style="color: #999999;">#8-16 bit MakeDiff and MergeDiff are limited to 50% of full-range, so float is used here</span></p>
<p>clean = <span style="color: #3366ff;">core.std.Convolution</span>(src32, [1,2,1,2,4,2,1,2,1]).std.Convolution([1]*9, planes=[0])</p>
<p>grain = <span style="color: #3366ff;">core.std.Expr</span>([src32, clean32], <span style="color: #800080;">'x y - 0.5 +'</span>)</p>
<p> </p>
<p>clean = fvf.Depth(clean, 16)</p>
<p>deband =<span style="color: #3366ff;">core.f3kdb.Deband</span>(clean, 16, 40, 40, 40, 0, 0, keep_tv_range=<span style="color: #33cccc;">True</span>, output_depth=16)</p>
<p> </p>
<p><span style="color: #999999;">#limit the debanding: f3kdb becomes very strong on the smoothed clip (or rather, becomes more efficient)</span></p>
<p><span style="color: #999999;">#adapt strength according to a neighborhood-similarity mask, steadily decreasing strength in more detailed areas</span></p>
<p>limited = zz.AdaptiveLimitFilter(deband, clean, mask=minmax, thr1=0.3, thr2=0.0, mthr1=400, mthr2=700, thrc=0.25)</p>
<p> </p>
<p>output = fvf.Depth(limited, 32).std.MergeDiff(grain)</p></td>
</tr>
</tbody>
</table>

 

-----

Revision \#11
Created <span title="Wed, Aug 30, 2017 4:13 PM">6 months ago</span> by
[Zastin](http://34.234.192.3/user/11)
Updated <span title="Fri, Sep 8, 2017 4:58 AM">6 months ago</span> by
[Zastin](http://34.234.192.3/user/11)

