# Resampling

#### Upsampling

    Or supersampling, upscaling. It is important to know which
resamplers work best for upsampling and to be able to tell (to some
extent) what sort of resizing kernel was used on a source in order to
reverse bad upscales.

<https://diff.pics/AOJ4sBhbe6SX/1> - 2x magnified luma test image using
various kernels (and nnedi3)

  - 3 - B-Spline - Bicubic b=1, c=0
  - 4 - Hermite - Bicubic b=0, c=0
  - 5 - Mitchell-Netravali - Bicubic b=1/3, c=1/3
  - 6 - Catmull-Rom - Bicubic b=0, c=0.5
  - 7 - Sharp Bicubic - Bicubic b=0, c=1

####  Downsampling

TODO

####  Inverse scaling

TODO

put something about (1-b)/2 for bicubic and b=0, c=X can be any number
of values

####  Chroma Subsampling

TODO

####  

