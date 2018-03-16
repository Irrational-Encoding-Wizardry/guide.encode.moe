<div id="page-show" class="container">

<div class="row">

<div class="col-md-8 col-md-offset-2">

<div class="page-content">

<div data-ng-non-bindable="">

# Basics and General Workflow

<div style="clear:left;">

</div>

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

 

</div>

-----

Revision \#4  
Created <span title="Mon, Aug 21, 2017 8:07 AM">6 months ago</span> by
[kageru](http://34.234.192.3/user/6)  
Updated <span title="Fri, Sep 15, 2017 7:40 PM">6 months ago</span> by
[begna112](http://34.234.192.3/user/3)

</div>

</div>

</div>

</div>
