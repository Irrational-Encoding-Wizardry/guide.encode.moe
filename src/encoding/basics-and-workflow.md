# Basics and General Workflow

## Preparation

downloading a source, looking at the video, some decisions
(resolution(s) for the release, audio codec, group-specific
requirements)


## Writing the Script

imports, source filter (mention lsmash, ffms2), examples for resizing,
debanding, AA. with images if possible


## Encoding the Result

```sh
$ vspipe.exe script.vpy -y - | x264.exe --demuxer y4m --some example --parameters here --output video.264 -
```

Editors for VapourSynth usually have inbuilt support for encoding
scripts you wrote. Use `%encode --y4m <clip_variable>` in Yuuno or the GUI
provided by VSEdit.


## Transcoding Audio

As said earlier, only *qaac* will require configuration,
everything else can simply be extracted wherever you like.
Nonetheless, it is easier to add every binary you use to the PATH environment variable,
and the rest of this guide will assume you've done exactly that.


### Decoding audio with FFmpeg and piping it out

Basic *ffmpeg* usage is simple.
You just need to specify your input file and your desired output file, like this:

```sh
ffmpeg -i "input.dtshd" "output.wav"
```

This command will decode the *DTS-HD MA* audio file and encode it as a WAVE file.
This command doesn't specify any options so *ffmpeg* will resort to using its defaults.

For transcoding from *DTS-HD MA*
only one option is needed:

```sh
ffmpeg -i "input.dtshd" -c:a pcm_s24le "output.wav"
```

The `-c:a pcm_s24le` parameter will tell *ffmpeg* to encode its output with a depth of 24 bits.
If your source file is 16 bits,
change this parameter to `pcm_s16le` or simply skip it
because 16 bits is the default.

<a name="16bps"></a>
<div class="info box"><div>

16 bits per sample are,
in almost all situation and most definitely also for anime,
more than enough data points to store audio data.
Thus, you should use 16 bits per sample in your output formats
and only use 24 bits for the intermediate *WAVE* file,
*iff* your source file already used 24 bits to begin with.

Refer also to the following article:
- [24/192 Music Downloads and why they make no sense][24/192-music]

[24/192-music]: https://people.xiph.org/~xiphmont/demo/neil-young.html

</div></div>

The command above will decode the source file
and save a resulting *WAVE* file on your drive.
You can then encode this *WAVE* file to a *FLAC* or *AAC* file,
but there is a faster and more convenient way to do that: piping.
Piping skips the process of writing
and reading the data to and from a file
and simply sends the data straight from one program to another.

To pipe from *ffmpeg*, specify the output format as *WAVE* using the `-f` option,
replace the output filename with a hyphen and place a pipe symbol at the end,
which will be used to separate the *ffmpeg* command from your encoder command,
like this:

```sh
ffmpeg -i "input.dtshd" -c:a pcm_s24le -f wav - | {encoder command}
```


### Encoding to FLAC

To encode to *FLAC*, we will use the `flac` command line program:

```sh
flac -8 --ignore-chunk-sizes --bps 16 "input.wav" -o "output.flac"
```

`-8` sets the encoding level to 8, the maximum level.
This will result in the best compression,
although at the expense of encoding speed.
*FLAC* encoding is fast, so just stick with level 8.

`--ignore-chunk-sizes` is needed
because the *WAVE* format only supports audio data up to 4 GiB.
This is a way to work around that limitation.
It will ignore the length field in the header of the *WAVE* file,
allowing the *FLAC* encoder to read files of any size.

`--bps 16` specifies the "bits per sample" to be 16.
As noted [earlier](#16bps),
16 bits are enough for our purposes
and *FLAC* additionally has the downside
that all 24-bit samples are padded to 32-bit samples in the format,
meaning 25% of the storage used is completely wasted.

To encode audio piped from *ffmpeg*,
replace the input filename with a hyphen
and place the whole command after the `ffmpeg` command,
like this:

```sh
ffmpeg -i "input.dtshd" -c:a pcm_s24le -f wav - | flac -8 --ignore-chunk-sizes --bps 16 - -o "output.flac"
```


### Encoding to AAC

First, set up *qaac*:

* Go to [its download page][qaac] and download the newest build
  (2.70 at the time of writing) and `makeportable.zip`.
* Extract the `x64` folder wherever you want `qaac` to be,
  then extract contents of `makeportable.zip` inside it.
* Download the [iTunes setup file][itunes] (`iTunes64Setup.exe`)
  and move it to the `x64` folder.
* Run the `makeportable.cmd` script
* You are done.
  You can now delete the iTunes installation file.

To encode from a file, use the following command:

```sh
qaac64 --tvbr 91 --ignorelength --no-delay "input.wav" -o "output.m4a"
```

The `--tvbr 91` option sets the encoding mode to True Variable Bitrate
(in other words, constant quality)
and sets the desired quality.
*qaac* has only 15 actual quality steps in intervals of 9 (0, 9, 18, ... 127).
The higher the number, the higher the resulting bitrate will be.
The recommended value is 91, which will result in a bitrate
of about 192 kbps on 2.0 channel files,
enough for complete transparency in the vast majority of cases.

`--ignorelength` performs the same function as `--ignore-chunk-sizes` in FLAC.
`--no-delay` is needed for proper audio/video sync[^1].

To encode audio piped from *ffmpeg*,
replace the input filename with a hyphen
and place the whole command after the `ffmpeg` command:

```sh
ffmpeg -i "input.dtshd" -c:a pcm_s24le -f wav - | qaac64 --tvbr 91 --ignorelength --no-delay - -o "output.m4a"
```

[itunes]: https://secure-appldnld.apple.com/itunes12/001-37026-20200915-5CBD39A0-F7A0-11EA-BB8F-8EB5DD073FF6/iTunes64Setup.exe
[qaac]: https://sites.google.com/site/qaacpage/
[^1]: Read why in this [HydrogenAudio forum post](https://hydrogenaud.io/index.php/topic,85135.msg921707.html#msg921707).


### Encoding to Opus

Encoding a file with `opusenc` will look like this:

```sh
opusenc --vbr --bitrate 160 --ignorelength "input.wav" "output.opus"
```

`--vbr` sets the encoding mode to Variable Bitrate (which is the default but it
never hurts to be explicit),
while `--ignorelength` does the same thing as in `qaac`.

As you may have noticed,
`opusenc` uses bitrate control
rather than some kind of constant quality mode[^2].
Instead of an abstract number that corresponds to a quality target
like with `x264`'s CRF mode and `qaac`'s TVBR mode,
you give the encoder your preferred resulting bitrate and it chooses the constant quality target itself.
The recommended bitrate is 160 kbps for 2.0 channels
and 320 kbps for 5.1.

Encoding audio piped from `ffmpeg` works the same as for previous encoders—just replace the input filename with a hyphen:

```sh
ffmpeg -i "input.dtshd" -c:a pcm_s24le -f wav - | opusenc --vbr --bitrate 160 --ignorelength - "output.opus"
```

[^2]: [A more in-depth explanation on HydrogenAudio](https://wiki.hydrogenaud.io/index.php?title=Opus#Characteristics)


## Muxing

mkvtoolnix
