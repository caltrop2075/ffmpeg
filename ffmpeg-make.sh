#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# video converter
# ffmpeg-make.sh -> ffmpeg-[dir].dat -> ffmpeg.sh -> converted video
#
# put video in '$HOME/Downloads/[directory]'
# directory name must start with capitol character, lower case will not process
# add [directory] case conditions, what is most numerous or deisrable
# nothing but the computer plays mkv & downloads are mixed: mkv, mp4, webm
#
# ffmpeg-[name].sh & ffmpeg.sh
# are in $HOME/bin, not in $HOME/.local/bin, for ease of editing
# ffmpeg is so FUCKED in scripts, loops don't work...
# the minimal ffmpeg display - shows progress with no overwrite
# ffmpeg -loglevel error -stats -n -i input.mkv output.mp4
#
# 2023-10-13 made multi-functional & limited info
#     no more ffmpeg PAGE of info, just the progress & errors
#     creates 'ffmpeg-[dir].sh' for each directory to process       <<< obsolete
# 2023-10-14 scans downloads directories
#     added delete ffmpeg-[dir].sh to ffmpeg-make.sh & ffmpeg.sh
#     now fully automated except case conditions
# 2023-10-20 added script data files 'ffmpeg-[dir].dat'
#     easier to delete without complicated filters
#     easier to build 'ffmpeg.sh' with 'source ffmpeg-[dir].dat'
#     also no mor chmod to a script
# 2023-10-25 fixed output glitch, '> $out' on wrong loop
#
#--------------------------------------------------------- build ffmpeg-[dir].sh
function fx_dir ()
{
   tgt="$bse/$dir"                           # target directory
   str=${dir:0:4}                            # get 4 chr
   str=${str,,}                              # all lower case
   out="$HOME/data/ffmpeg-$str.dat"          # output ffmpeg-[dir].dat
   title-80.sh -t line "$tgt\ncreating ${out##*/}  $in1, $in2 -> $cvt"
   sleep 1
   for typ in $in1 $in2                      # -> $cvt
   do
      find "$tgt" -type f -iname "*.$typ" | sort |
      while read src
      do
         des="${src%.*}.$cvt"
         if [ ! -f "$des" ]                  # destination exists
         then
            echo "${src##*/}" >&2
            echo "echo -e \"$Wht${src##*/} -> $cvt$nrm\""
            echo "ffmpeg -loglevel error -stats -n -i \"$src\" \"$des\""
            sleep 0.05
         fi
      done
   done > $out                               # had on the loop above... duh...
   if (( $(stat -c "%s" "$out") == 0 ))      # empty file ?
   then
      echo -e "${Red}no file(s) to process${nrm}"
      rm "$out"
   fi
}
#-------------------------------------------------------------------- initialize
clear
source ~/data/global.dat
dat="$HOME/data"
bse="$HOME/Downloads"
scr="$HOME/bin/ffmpeg.sh"
echo -e "deleting script data"               # script cleanup
find "$dat" -type f -name "ffmpeg-*.dat" -printf "%f\n" -delete
sleep 1
#--------------------------------------------------------- configure directories
find "$bse" -maxdepth 1 -type d -regex "$bse/[A-Z].+" -printf "%f\n" | sort |
while read dir
do
   title-80.sh -t double "${Wht}processing: $dir${nrm}"
   sleep 1
   case $dir in                              # directory processing
      "Dungeons & Dragons" | \
      "Popeye" | \
      "Space 1999" | \
      "Thunderbirds" | \
      "Thunderbirds Are Go" )
         in1="mkv"                           # -> mp4: all players
         in2="webm"
         cvt="mp4"
         fx_dir                              # ffmpeg-[dir].sh
      ;;
      "Bonanza" | \
      "Chef Michael Smith" | \
      "Dobie Gillis" | \
      "Jack Benny Show" | \
      "Land Of The Giants" | \
      "Milk Street" | \
      "Time Tunnel" | \
      "Voyage To The Bottom Of The Sea" )
         in1="mkv"                           # -> webm: TV only
         in2="mp4"
         cvt="webm"
         fx_dir                              # ffmpeg-[dir].sh
      ;;
      * )
         echo -e "${Red}not processed${nrm}"
   esac
done
#--------------------------------------------------------------- build ffmpeg.sh
title-80.sh -t double "${Wht}run ffmpeg.sh to process files${nrm}"
echo "#!/usr/bin/bash" > "$scr"
echo "clear" >> "$scr"
find "$dat" -type f -name "ffmpeg-*.dat" | sort | # ffmpeg-[dir].dat
while read lin
do
   echo "source $lin"
done >> "$scr"
# optional script data cleanup, files aren't big & fmpeg-make.sh removes them
# echo "echo -e \"\n${Wht}deleting script data${nrm}\"" >> "$scr"
# echo "find \"$HOME/data\" -type f -name \"ffmpeg-*.dat\" -printf \"%f\n\" -delete" >> "$scr"
# echo "sleep 1" >> "$scr"

#------------------------------------------------------------------------- stats
find "$dat" -type f -name "ffmpeg-*.dat" | sort |
{
   c=0
   while read src
   do
      c=$((c+$(cat "$src" | wc -l)/2))
   done
   printf "%s %2d\n" "files:" "$c"
   printf "%s %2d %s\n" "hours:" "$((c/2))" "(30m per file)"
}
#-------------------------------------------------------------------------------
exit
sleep 1
cat "$scr"
