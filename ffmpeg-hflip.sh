#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# video horizontal flipper
# ffmpeg-hflip.sh -> ffmpeg.sh -> hflip video
#
# put video in '$HOME/Downloads/hflip' add '*-R.*' before extension
# then check the video...
#
# 2023-10-13 fully automated hflip
#
# ffmpeg-[name].sh & ffmpeg.sh
# are in $HOME/bin, not in $HOME/.local/bin, for ease of editing
# ffmpeg is so FUCKED in scripts, loops don't work...
# the minimal ffmpeg display - shows progress with no overwrite
# ffmpeg -loglevel error -stats -n -i input.mkv output.mp4
#
#-------------------------------------------------------------------------------
clear
source ~/data/global.dat

dir="$HOME/Downloads/hflip"
out="$HOME/bin/ffmpeg.sh"
echo "#!/usr/bin/bash" > "$out"
echo "clear" >> "$out"
find "$dir" -type f \( -name "*-R.mp4" -o -name "*-R.webm" \)| sort |
while read src
do
   des=${src/-R./.}
   fil=${des##*/}
   echo $fil >&2
   echo ${des##*/} >&2
   echo >&2
   echo "echo -e \"${Wht}horizontal flipping: ${fil%.*}${nrm}\""
   echo "ffmpeg -loglevel error -stats -y -i \"$src\" -vf hflip \"$des\""
done >> "$out"
echo $div_s
cat "$out"
#-------------------------------------------------------------------------------
