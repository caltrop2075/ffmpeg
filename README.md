# ffmpeg
ffmpeg utilities, making life simple

automated ffmpeg stuff
see individual scripts for instructions

DIRECTORIES:
$HOME/Downloads/[directory]
   hflip & your video directories
$HOME/data

SCRIPTS:
ffmpeg-hflip.sh   -> ffmpeg.sh
ffmpeg-make.sh    -> ffmpeg-[directory].dat  -> ffmpeg.sh
ffmpeg.sh         what is finally run
title-80.sh       in another project, change this if you want

COMMENT FROM SCRIPTS:
# ffmpeg-[name].sh & ffmpeg.sh
# are in $HOME/bin, not in $HOME/.local/bin, for ease of editing
# ffmpeg is so FUCKED in scripts, loops don't work...
# the minimal ffmpeg display - shows progress with no overwrite
# ffmpeg -loglevel error -stats -n -i input.mkv output.mp4
