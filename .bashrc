export PS1='\[\033[38;5;202;48;5;0m\]⏣ \[\033[38;5;134;48;5;0m\]\w \[\033[38;5;112;48;5;0m\]`git branch 2> /dev/null | grep -e ^* | sed -E  s/^\\\\\*\ \(.+\)$/\(\\\\\1\)\ /`\[\033[00m\]'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [[ $- != *i* ]]; then
  return
fi

shopt -s histappend
PROMPT_COMMAND='history -a'
HISTCONTROL=ignoredups:ignorespace

shopt -s checkwinsize

# xterm title:
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\n\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    ;;
*)
    ;;
esac

. ~/bin/utils

################################
# Aliases
################################

alias ls='ls --color=auto'
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
alias sudo="sudo "
alias clone='git clone'
alias e='vim'
alias c='clear'
alias dw='du -chs *'
alias rm='rm -vr'
alias cp='cp -R'
alias con='ps -A --sort -rsz -o comm,pmem,pcpu|awk "NR<=15"'
alias cdd='cd ~/Downloads'
alias ra='ranger'
alias :q='exit'
alias history='builtin fc -l 1'
alias load='xrdb -load ~/.Xresources'
alias t='tmux'
alias tls='tmux ls'
alias ta='tmux attach'
alias tat='tmux attach -t'
alias tk='tmux kill-session'
alias tkt='tmux kill-session -t'
alias tka='tmux kill-session -a'
alias halt='sudo halt'
alias poweroff='sudo poweroff'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown'
alias mount='sudo mount'
alias umount='sudo umount'


################################
#  Upload files
################################

# hosts list
host-list() {
	printf "TEXT:\nix\nhaste\niotek\nptpb\npnik\n\nFILES:\nuguu\
	\ntransfer\nanonfile\ncatbox\nteknik\n0x0\nmixtape\
	\nptpb\nlewd\nfiery\ndoko\n"
}


## text
### ix, quick and simple
ix() {
    local opts
    local OPTIND
    [ -f "$HOME/.netrc" ] && opts='-n'
    while getopts ":hd:i:n:" x; do
        case $x in
            h) echo "ix [-d ID] [-i ID] [-n N] [opts]"; return;;
            d) $echo curl $opts -X DELETE ix.io/$OPTARG; return;;
            i) opts="$opts -X PUT"; local id="$OPTARG";;
            n) opts="$opts -F read:1=$OPTARG";;
        esac
    done
    shift $(($OPTIND - 1))
    [ -t 0 ] && {
        local filename="$1"
        shift
        [ "$filename" ] && {
            finalResult="$(curl $opts -sF f:1=@"$filename" $* ix.io/$id)"
			printf "$finalResult" | xclip -selection clipboard
			notify-send "Uploaded!" "${finalResult}"
            return
        }
        echo "^C to cancel, ^D to send."
    }
    finalResult="$(curl $opts -sF f:1='<-' $* ix.io/$id)"
    printf "$finalResult" | xclip -selection clipboard
    notify-send "Uploaded!" "${finalResult}"

}

### haste
haste() {
    a=$(cat);
    finalResult="$(curl -X POST -s -d "$a" https://hastebin.com/documents | \
        awk -F '"' '{print "https://hastebin.com/"$4}';)"
        printf "$finalResult" | xclip -selection clipboard
        notify-send "Uploaded!" "${finalResult}"
}

### iotek
iotek() {
    for i in "$@"; do
        finalResult="$(curl -sT- https://p.iotek.org < $i)"
        printf "$finalResult" | xclip -selection clipboard
        notify-send "Uploaded!" "${finalResult}"
    done
}

### teknik
pnik() {
	a="$(</dev/stdin)";
    uploadResult=$(curl --silent --data-urlencode "code=$a" https://api.teknik.io/v1/Paste)
    	uploadResult="${uploadResult##*id\":\"}"
    	uploadResult="${uploadResult%%\",\"*}"
    	finalResult="$(printf "https://paste.teknik.io/Raw/${uploadResult}\n")"
    [ -z ${uploadResult} ] || printf "$finalResult" | xclip -selection clipboard ;\
		notify-send "Uploaded!" "${finalResult}"
}

## files
### uguu - 24 hours
uguu() {
    for i in "$@"; do
        finalResult="$(curl -i -F file=@$i https://uguu.se/api.php?d=upload-tool | grep https)"
        printf "$finalResult" | xclip -selection clipboard
        notify-send "Uploaded!" "${finalResult}"
    done
}

### transfer
transfer() {
    for i in "$@"; do
        finalResult="$(curl -sS -T $i https://transfer.sh/)"
        printf "$finalResult" | xclip -selection clipboard
        notify-send "Uploaded!" "${finalResult}"
    done
}

### anonfile
anon() {
    for i in "$@"; do
    	finalResult="$(curl -F "file=@$i" https://anonfile.com/api/upload)"
		printf "$finalResult" | sed 's/.*short":"//;s/"}.*//' | xclip -selection clipboard
		notify-send "Uploaded!" "$(printf "$finalResult" | sed 's/.*short":"//;s/"}.*//')"
    done
}

### catbox
catbox() {
    for i in "$@"; do
        finalResult="$(curl -F "reqtype=fileupload" -F "fileToUpload=@$i" https://catbox.moe/user/api.php)"
        printf "$finalResult" | xclip -selection clipboard
        notify-send "Uploaded!" "${finalResult}"
    done
}

### teknik
teknik() {
    for i in "$@"; do
		finalResult="$(curl -sf -F file="@$i" https://api.teknik.io/v1/Upload)"
		finalResult="${finalResult##*url\":\"}"
		finalResult="${finalResult%%\"*}"
		printf "$finalResult" | xclip -selection clipboard
		notify-send "Uploaded!" "${finalResult}"
	done
}

### 0x0
0x0() {
	for i in "$@"; do
		finalResult="$(curl -sf -F file="@$i" https://0x0.st/)"
		printf "$finalResult" | xclip -selection clipboard
		notify-send "Uploaded!" "${finalResult}"
	done
}

### mixtape
mixtape() {
	for i in "$@"; do
		finalResult="$(curl -sf -F files[]="@$i" https://mixtape.moe/upload.php)"
		finalResult="$(echo "${finalResult}" | grep -Po '"url":"[A-Za-z0-9]+.*?"' | sed 's/"url":"//;s/"//')"
		finalResult="$(echo "${finalResult//\\\//\/}")"
		printf "$finalResult" | xclip -selection clipboard
		notify-send "Uploaded!" "${finalResult}"
	done
}

### ptpb
ptpb() {
	for i in "$@"; do
		finalResult="$(curl -sf -F c="@$i" https://ptpb.pw/)"
		finalResult="${finalResult##*url: }"
		finalResult="${finalResult%%$'\n'*}"
		printf "$finalResult" | xclip -selection clipboard
		notify-send "Uploaded!" "${finalResult}"
	done
}

### lewd
lewd() {
	for i in "$@"; do
		finalResult="$(curl -sf -F file="@$i" https://lewd.se/api.php?d=upload-tool)"
		printf "$finalResult" | xclip -selection clipboard
		notify-send "Uploaded!" "${finalResult}"
	done
}

### fiery
fiery() {
	for i in "$@"; do
		finalResult="$(curl -sf -F files[]="@$i" https://safe.fiery.me/api/upload)"
		finalResult="$(echo "${finalResult}" | grep -Po '"url":"[A-Za-z0-9]+.*?"' | sed 's/"url":"//;s/"//')"
		printf "$finalResult" | xclip -selection clipboard
		notify-send "Uploaded!" "${finalResult}"
	done
}

### doko
doko() {
	for i in "$@"; do
		finalResult="$(curl -sf -F files[]="@$i" https://doko.moe/upload.php)"
		finalResult="$(echo "${finalResult}" | grep -Po '"url":"[A-Za-z0-9]+.*?"' | sed 's/"url":"//;s/"//')"
		finalResult="$(echo "${finalResult//\\\//\/}")"
		printf "$finalResult" | xclip -selection clipboard
		notify-send "Uploaded!" "${finalResult}"
	done
}


#####################################
# Educational Videos
#####################################

# requirements:
#     1. install nohup mpv vim youtube-dl
#     2. add this to your ~/.vimrc
#        map <F8> :exec '!nohup mpv ' . shellescape(getline('.'), 1) . ' >/dev/null 2>&1&'<CR><CR>
#
# how to use:
#     1. fap-xvideos ashlynn brooke
#     2. hit F8 on the link you want to play
#     3. hit ZZ or ZQ to quit vim
fap-youporn() {
  grepmatch=$(echo "$@" | sed 's/ /.*/g')
  keyword="$(echo "http://www.youporn.com/search?query=$@&type=straight" | sed 's/ /\+/g')"
  pagenum=3
  pagenum_to_url=$(for num in $(seq 1 "$pagenum"); do echo "$keyword&page=$num"; done )
  videourl=$(echo "$pagenum_to_url" | while read line; do lynx -dump "$line" \
  | awk '/watch/ {print $2}' | cut -d\/ -f1-6 | grep -iE $grepmatch | awk '!x[$0]++' ; done)

  echo $videourl | sed 's/\ /\n/g' | awk '!x[$0]++' | vim -R -
}

fap-youjizz() {
  keyword="$(echo "http://www.youjizz.com/search/$@" | sed 's/ /\-/g')"
  pagenum=5
  pagenum_to_url=$(for num in $(seq 1 "$pagenum"); do echo "$keyword-$num".html""; done )
  videourl=$(echo "$pagenum_to_url" | while read line; do lynx -dump "$line" \
  | awk '/\.com\/videos/ {print $2}' | awk '!x[$0]++' ; done)

  echo $videourl | sed 's/\ /\n/g' | awk '!x[$0]++' | vim -R -
}

fap-xvideos() {
keyword="$(echo "http://www.xvideos.com/?k=$@" | sed 's/ /\+/g')"
pagenum=5
pagenum_to_url=$(for num in $(seq 1 "$pagenum"); do echo "$keyword&p=$num"; done )
videourl=$(echo "$pagenum_to_url" | while read line; do lynx -dump "$line" \
	| awk '/xvideos\.com\/video/ {print $2}' | awk '!x[$0]++' ; done)

echo $videourl | sed 's/\ /\n/g' | awk '!x[$0]++' | vim -R -
}

fap-spankwire() {
  keyword="$(echo "http://www.spankwire.com/search/straight/keyword/$@" | sed 's/ /\%20/g')"
  pagenum=5
  pagenum_to_url=$(for num in $(seq 1 "$pagenum"); do echo "$keyword?Sort=Relevance&Page=$num"; done )
  videourl=$(echo "$pagenum_to_url" | while read line; do lynx -dump "$line" \
  | awk '/www\.spankwire\.com/ && /video/ {print $2}' | awk '!x[$0]++' ; done)

  echo $videourl | sed 's/\ /\n/g' | vim -R -
}

chaturbate(){ mpv --ytdl-format=slow-2 "https://chaturbate.com/$@" ;}


####################################
# Compacting and extracting
####################################

# Extract a folder

extract() {
if [[ -f $1 ]]; then
    case "$1" in
        *.tar.bz2) tar xvjf "$1";;
        *.tar.gz) tar xvzf "$1";;
        *.tar.xz) tar xvf "$1";;
        *.tar) tar xvf "$1";;
        *.tgz) tar xvf "$1";;
        *.xz) tar xvf "$1";;
        *.gz) gunzip "$1";;
        *.zip) unzip "$1";;
        *.rar) unrar x "$1";;
        *) echo "'$1' cannot be extracted via extract."
    esac
else
    echo "'$1' is not a valid file"
fi
}

# Compress a file

compress() {
	if [[ -n "$1" ]]; then
		FILE=$1
		case $FILE in
			*.tar ) shift && tar cf $FILE $* ;;
			*.tar.bz2 ) shift && tar cjf $FILE $* ;;
			*.tar.gz ) shift && tar czf $FILE $* ;;
			*.tgz ) shift && tar czf $FILE $* ;;
			*.zip ) shift && zip $FILE $* ;;
			*.rar ) shift && rar $FILE $* ;;
		esac
	else
		echo "usage: compress <foo.tar.gz> ./foo ./bar"
	fi
}


##################################
# Miscellaneous
##################################

countdown() {
	secs=$(($1 * 60))
	while [ $secs -gt 0 ]; do
		echo -ne "Counting down from $1 minutes, \033[1;31m$secs seconds\033[0m remaining... \033[1;30m(Ctrl+C to Cancel)\033[0m\r"
		sleep 1
		: $((secs--));
	done; echo -e "\n\033[1;30m$(date)\033[1;31m Countdown has finished!\033[0m\n"
}

# list and grep with file permission
lsg() {
  keyword=$(echo "$@" |  sed 's/ /.*/g')
  ls -hlA --color=yes \
  | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print}' \
  | grep -iE $keyword
}

# show file access permission
# http://unix.stackexchange.com/a/46921
file-permission() { stat --format '%a %A %n' "$@" ;}

# searches for manual locally or online
manned() {
	for arg in "$@"; do man $arg 2> /dev/null \
		|| $arg -H 2> /dev/null || $arg -h 2> /dev/null \
		|| $arg --help-all 2> /dev/null || $arg --help 2> /dev/null \
		|| help $arg 2> /dev/null \
		|| $BROWSERCLI "http://manned.org/browse/search?q=$@" 2> /dev/null \
		|| $BROWSER "http://manned.org/browse/search?q=$@" 2> /dev/null \
		|| open "http://manned.org/browse/search?q=$@" 2> /dev/null \
		|| xdg-open "http://manned.org/browse/search?q=$@"
done
}

ymp3() {
	youtube-dl "$@" --add-metadata --metadata-from-title "%(artist)s - %(title)s" \
	--extract-audio --audio-format mp3 --audio-quality 0 --prefer-ffmpeg \
	--youtube-skip-dash-manifest --ignore-errors
}

mkcd() {
	mkdir "$1"
	cd "$1"
}

csv() {
 	cat $1 | less -#2 -N -S
}

# Shows files in markdown format
mdless(){
	pandoc -s -f markdown -t man "$*" | groff -T utf8 -man | less ;
}

# display directories ranked by size (MB), descending order
dum() {
	du -h | grep ^[0-9.]*M | sort -rn | head -n 20
}

#List files only, the advantage is that it works just like normal 'ls' so you could do 'lf -al | grep blah' etc.
lf () {
	ls -1p $@ | grep -v '\/$'
}

# DESC: cli calculator (Ctrl+D to exit)
# DEMO: http://www.youtube.com/watch?v=JkyodHenTuc
# LINK: http://docs.python.org/library/math.html
calc() {
  if which python2 &>/dev/null; then
    python2 -ic "from __future__ import division; from math import *; from random import *"
  elif which python3 &>/dev/null; then
    python3 -ic "from math import *; import cmath"
  elif which bc &>/dev/null; then
    bc -q -l
  else
    echo "Requires python2, python3 or bc for calculator features"
  fi
}

# Wget (Retrieve Files From The Web)
# http://stackoverflow.com/a/18709707
wget-extension() {
  if [ $# -lt 2 ]; then
    echo -e "Download all files with specific extension on a webpage"
    echo -e "\nUsage: wget-extension <file_extension> <url>"
    echo -e "\nExample:\nwget-extension mp4 http://example.com/files/"
    echo -e "wget-extension mp3,ogg,wma http://samples.com/files/"
    return 1
  fi

  # savepath=~/Downloads
  # outputdir_name=$(echo "$2" | rev | cut -d\/ -f2 | rev)
  # mkdir -pv "$savepath/$outputdir_name"
  # cd "$savepath/$outputdir_name" && wget -r -l1 -H -t1 -nd -N -np -A "$1" -erobots=off "$2"

  outputdir_name=$(echo "$2" | rev | cut -d\/ -f2 | rev)
  mkdir -pv "$outputdir_name"
  cd "$outputdir_name" && wget -r -l1 -H -t1 -nd -N -np -A "$1" -erobots=off "$2"
}

# Use lftp as download manager
gdown() {
	lftp -e "pget -n 4 -c $1; exit"
}

# Search for processes using grep
function psg()
{
	if [ $# -lt 1 ] || [ $# -gt 1 ]; then
		echo "grep running processes"
		echo "usage: psg [process]"
	else
		ps aux | grep USER | grep -v grep
		ps aux | grep -i $1 | grep -v grep
	fi
}


#################################
# FZF
#################################

# cdfile - cd into a selected file directory
cdfile() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

# Kill process by searching by the name
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}
