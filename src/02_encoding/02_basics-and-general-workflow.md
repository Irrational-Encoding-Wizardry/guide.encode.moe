# Basics and General Workflow

#### Preparation

downloading a source, looking at the video, some decisions
(resolution(s) for the release, audio codec, group-specific
requirements)

#### Writing the Script

imports, source filter (mention lsmash, ffms2), examples for resizing,
debanding, AA. with images if
    possible

#### Encoding the Result

    vspipe.exe script.vpy -y - | x264.exe --demuxer y4m --some example --parameters here --output video.264 -

Editors for VapourSynth usually have inbuilt support for encoding
scripts you wrote. Use `%encode --y4m variable` in Yuuno or the GUI
provided by VSEdit.

#### Transcoding Audio

examples for qaac, flac

#### Muxing

mkvtoolnix

 

