# Requirements

### Language

There are fansub groups for almost every language in the world.
So, while anyone is welcome to read and use this textbook,
I recommend applying your skills in a fansub group
centered on your native language.
Of course,
there are some roles that don't require any language skills to complete them.
But you will still need to communicate with the other
members of your chosen fansub group,
and a language barrier can make that difficult.

### Hardware

Every fansubber will need a computer.
Some roles will have higher requirements.
Below are some **minimum *recommended* computer specifications**
based on the role.
Can you do the job with less than what's below?
Probably, but it could make your job much harder than it needs to be.

- **Timer, Editor, Translator, Translation Checker**
  - Some of the most forgiving roles in fansubbing for computer
    hardware.
  - **OS**: Windows 7, Mac OS X 10.7, Linux
  - **Screen**: 720p
  - **CPU**: dual-core \>2Ghz
    - Computer should be able to playback HD anime with
      subtitles.
  - **Memory**: 4GB
    - Aegisub loads the entire video into memory. With larger HD
      videos being standard today, this could be up to several GB.
  - **Storage**: 50GB available
  - **Mouse**: recommended
  - **Internet**: 25 Mbps download
- **Typesetter, Quality Checker**
  - The middle of the road in terms of required computer hardware.
  - **OS**: Windows 7, Mac OS X 10.7, Linux
    - 64-bit recommended
  - **Screen**: 1080p
  - **CPU**: dual-core \>2.5GHz (quad-core \>3GHz recommended)
    - Computer should be able to playback modern fansubbed anime
      releases with high settings.
  - **Memory**: 8GB
    - Aegisub loads the entire video into memory. With larger HD
      videos being standard today, this could be up to several GB.
    - Windows loads installed fonts into memory on boot. For
      typesetters, the font library could grow to be several GB.
  - **Storage**: 100GB available
  - **Mouse**: *required*
  - **Internet**: 25 Mbps download, 5 Mbps upload
- **Encoder**
  - The most demanding role in terms of computer hardware.
  - The speed and capabilities of the computer directly correlate to
    encode times and the stability of encoding tools.
  - **OS**: Windows 7, Mac OS X 10.7, Linux
    - 64-bit *required*
  - **Screen**: 1080p
    - IPS panels highly recommended for color correctness.
    - VA panels highly discouraged.
  - **CPU**: quad-core \>4GHz
    - More cores and/or higher speed are better (e.g. AMD Ryzen,
      Threadripper or Intel Core i7+).
    - **CPU Requirements**:
      - Hyperthreading
      - AVX2
      - SSE4
  - **Memory**: 8GB
    - Memory can be a bottleneck when encoding. More, faster
      memory is always better for encoding rigs.
  - **Storage**: 500GB available
    - Encoders sometimes deal with files up to 40GB each and
      regularly with ones between 1GB and 8GB and may be required
      to retain these files for a long time.
  - **Internet**: 25 Mbps download, 25 Mbps upload

### Software

Every role will have different required software,
but it is recommended for every role to have installed [Aegisub][].
It is **highly** recommended to use [CoffeeFlux's builds][].
They come pre-equipped with Dependency Control
and several *critical* fixes to Aegisub that have not been merged
into the official application.

[Aegisub]: http://www.aegisub.org
[CoffeeFlux's builds]: https://thevacuumof.space/builds/

More specifics will be presented in the chapters devoted to each role.

<TODO - pages for each role ^>

### Programming

Prior knowledge of some programming languages
can be extremely useful for fansubbing, though it is not required.
Specifically, Lua and [Moonscript][] are useful for Typesetters.
Encoders will find that Python is used to interact with VapourSynth,
so learning it ahead of time will be to their advantage.

[Moonscript]: http://moonscript.org/
