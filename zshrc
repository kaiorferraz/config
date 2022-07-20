# umask 077

autoload -U colors && colors
autoload -U compinit && compinit

bindkey "$(echotc kl)" backward-char
bindkey "$(echotc kr)" forward-char
bindkey "$(echotc ku)" up-line-or-history
bindkey "$(echotc kd)" down-line-or-history
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word

PS1="$fg[cyan]%}[%h]%{$fg[green]%}[%~]
%{$reset_color%}... "

NOW="$(date +%F-%H:%M:%S)"
TODAY="$(date +%F)"
TS="$(date +%s)"
ROOT="$(command -v sudo || command -v doas)"

ZDOTDIR="${HOME}/.config/zsh/zcompinit"
HISTFILE="${HOME}/.config/histfile"
HISTSIZE=9999
SAVEHIST=$HISTSIZE

LANG="en_US.UTF-8"

export DISPLAY=:1
export LC_ADDRESS=$LANG
export LC_ALL=$LANG
export LC_COLLATE=$LANG
export LC_CTYPE=$LANG
export LC_IDENTIFICATION=$LANG
export LC_MEASUREMENT=$LANG
export LC_MESSAGES=$LANG
export LC_MONETARY=$LANG
export LC_NAME=$LANG
export LC_PAPER=$LANG
export LC_TELEPHONE=$LANG
export LC_TIME=$LANG

export HOMEBREW_CASK_OPTS=--require-sha
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

#export PYTHONSTARTUP="$HOME/.config/pythonrc"
#export PATH="$HOME/homebrew/opt/libpcap/bin:$PATH"
#export LDFLAGS="-L$HOME/homebrew/opt/openssl@3/lib"
#export CPPFLAGS="-I$HOME/homebrew/opt/openssl@3/include"
#export LDFLAGS="-L$HOME/homebrew/opt/libpcap/lib"
#export CPPFLAGS="-I$HOME/homebrew/opt/libpcap/include"
#export PKG_CONFIG_PATH="$HOME/homebrew/opt/libpcap/lib/pkgconfig"
#export PKG_CONFIG_PATH="$HOME/homebrew/opt/sqlite/lib/pkgconfig"

# export http_proxy="127.0.0.1:8118"
# export https_proxy="127.0.0.1:8118"

setopt cdablevars
setopt alwaystoend
setopt autocd
setopt completeinword
setopt correct
setopt nobeep
setopt noclobber
setopt nullglob
# setopt extendedhistory
# setopt histignorealldups
# setopt histignorespace
# setopt histreduceblanks
# setopt autopushd


zstyle ":completion:*" auto-description "specify %d"
zstyle ":completion:*" completer _expand _complete _correct _approximate
zstyle ":completion:*" file-sort modification reverse
zstyle ":completion:*" format "completing %d"
zstyle ":completion:*" group-name ""
zstyle ":completion:*" list-colors "=(#b) #([0-9]#)*=36=31"
zstyle ":completion:*" menu select=long-list select=0
zstyle ":completion:*" verbose yes
# zstyle ":completion:*" cache-path "$HOME/.zsh_cache"
# zstyle ":completion:*" use-cache on
# zstyle ":completion:*" hosts off

alias m="micro"
alias l="ls -lhAGF"
alias rm="rm -drf"
alias t="tree --dirsfirst --sort=name -LlaC 1"
alias ll="ls -lhAGF1"
alias grep="grep --text --color"
alias td="mkdir $TODAY ; cd $TODAY"
alias sha256="sha256sum"
alias sha512="sha512sum"
alias hide="chflags hidden $@"
alias md="mkdir -p"
alias kil="killall -u $(whoami)"
alias pbc="pbcopy"
alias pbp="pbpaste"
alias santa="santactl"
alias 700="chmod 700"
alias 000="chmod 000"
alias 755="chmod 755"
alias doctor="brew doctor"
alias web="open -a Safari"
alias speed="networkQuality"
alias python="python3"

FPATH=${HOME}/.config/zsh/zsh-completions:$FPATH
source ${HOME}/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${HOME}/.config/zsh/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

function proxy ()
{
	rm -rf ${HOME}/.config/proxy-list
	curl -sSf "https://raw.githubusercontent.com/clarketm/proxy-list/master/proxy-list-raw.txt" > ${HOME}/.config/proxy-list
}

function reinstall {
	brew reinstall $@
}

function .. { 
	cd ".." ; 
}

function ... { 
	cd "../.." ; 
}

function .... { 
	cd "../../.." ;
}

function wifi {
	if [[ $1 == "down" ]] ; then
		$ROOT ifconfig en0 down
	elif [[ $1 == "up" ]] ; then
		$ROOT ifconfig en0 up
	fi
}

function here {
	open $(pwd)
}

function plist {
	function get_plist {
		for the_path in $(find LaunchDaemons ; find LaunchAgents) ; do
	        for the_file in $(ls -1 $the_path) ; do
				echo $the_path/$the_file ; 
			done ; 
		done
	}
	function get_shasum {
		for i in $(get_plist) ; do
			shasum -a 256 $i ; 
		done
	}
	if [[  $1 == "get" ]] ; then
		get_shasum > $HOME/.config/plist-shasum
	elif [[  $1 == "verify" ]] ; then
		diff <(get_shasum) <(cat $HOME/.config/plist-shasum)
	fi
}

function install {
	if [[ $1 == 'brew' ]] ; then
		if [[ $2 == 'local'  ]] ; then
			mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master \
			| tar xz --strip 1 -C homebrew && \
			brew update && brew upgrade
		else
			/bin/bash -c \
			"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
			brew update && \
			brew upgrade
		fi
	elif [[ $1 == 'nvm' ]] ; then
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
	else
		brew install $@
	fi
}

function remove { 
	if [[ $1 == 'brew' ]] ; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
		if [[ -d "${HOME}/homebrew" ]] ; then
			rm -rf ${HOME}/homebrew
		elif [[ -d "/opt/homebrew" ]] ; then
			$ROOT rm -rf /opt/homebrew
		elif [[ -d "/local/homebrew" ]] ; then
			$ROOT rm -rf /local/homebrew
		fi
	else 
		brew uninstall $@
	fi
}

function generate_ip {
	for a in {1..254};do
		echo "$a.1.1.1"
   		for b in {1..254};do
			echo "$a.$b.1.1"
			for c in {1..254};do
				echo "$a.$b.$c.1"
				for d in {1..254};do
					echo "$a.$b.$c.$d"
          		done
      		done
   		done
	done

}

function update { 
	brew update && brew upgrade
}

function cleanup { 
	brew cleanup
}

function info { 
	brew info $@
}

function list { 
	brew list
}

function search { 

	brew search $@
}

function connect {
	if [[ $1 == "ubuntu" ]] ; then
		ssh root@164.92.89.226 -i $HOME/.ssh/ed25519-ubuntu-odigitalocean-one
	fi }
		
function dmg() {
	if [[ $1 == "crypt" ]] ; then
		hdiutil create $2.dmg -encryption -size $3 -volname $2 -fs JHFS+
	else
		hdiutil create $1.dmg -size $2 -volname $1 -fs JHFS+
	fi
}

function mkvenv() {
	python3 -m venv $1
	cd $1
	source bin/activate
	pip install --upgrade pip
}

function cloud() {
	cd "~/Library/Mobile\ Documents/com\~apple\~CloudDocs"
}

function clone {
	MY_PATH=$(pwd)
	cd $HOME/github && git clone $@
	cd MY_PATH
}

function block {
	$ROOT santactl rule --silent-block --path $@
}

function unblock {
	$ROOT santactl rule --remove --path $@
}

function intel {
	exec arch -x86_64 $SHELL
}

function arm64 {
	exec arch -arm64 $SHELL
}

function grep_ip {
	grep -Eo \
	"([0-9]{1,3}\.){3}[0-9]{1,3}" "$@"
}

# function adbpkg {
	# for p in $(adb shell pm list package|awk -F "package:" '{print $2}'); \
	# do echo -n "$p: "
	# adb shell dumpsys package $p | \
	# 	grep -i versionname | \
	# 	awk -F "=" '{print $2}'
	# done > adb.pkg.$(date +%F)
# }

function backup () {
	cp -v "$1" "$1.$TS"
}

function calc {
	awk "BEGIN { print "$*" }"
}

function cert {
	cn="$1-$TS}"
	expire="$2-8}"
	openssl req -new \
	-newkey rsa:4096 -nodes \
	-subj "/CN=$cn" \
	-x509 -sha512 -days "$expire" \
	-keyout "s.$cn.pem" -out "s.$cn.crt"
	openssl x509 -in "s.$cn.crt" -noout \
	-subject -issuer -dates -serial
	for ft in \-sha1 \-sha256 \-sha512 ; do \
	openssl x509 -in "s.$cn.crt" -noout \
	-fingerprint $ft | tr -d ":" ; done
}

function colours {
	for i in {255..001} ; do \
		printf "\x1b[38;5;$im$i\n" | \
		tr "\n" " " ; done | fold -w 255
}

function dump {
	if [[ $1 == "arp" ]] ; then
		$ROOT tcpdump $NETWORK -w arp-$NOW.pcap "ether proto 0x0806"
	elif [[ $1 == "icmp" ]] ; then
		$ROOT tcpdump -ni $NETWORK -w icmp-$NOW.pcap "icmp"
	elif [[ $1 == "pflog" ]] ; then
		$ROOT tcpdump -ni pflog0 -w pflog-$NOW.pcap "not icmp6 and not host ff02::16 and not host ff02::d"
	elif [[ $1 == "syn" ]] ; then
		$ROOT tcpdump -ni $NETWORK -w syn-$NOW.pcap "tcp[13] & 2 != 0"
	elif [[ $1 == "upd" ]] ; then
		$ROOT tcpdump -ni $NETWORK -w udp-$NOW.pcap "udp and not port 443"
	else
		$ROOT tcpdump 
	fi
}

function find {
	mdfind -name $@ | grep $@ --color=auto
}

function myip {
	curl -sq "https://icanhazip.com/"
}

function lowercase {
	tr '[:upper:]' '[:lower:]'
}

function rand {
	if [[ $1 == "mac" ]] ; then
		openssl rand -hex 6 | sed "s/\(..\)/\1:/g; s/.$//" | pbc
		pbp
	elif [[ $1 == "pass" ]] ; then
		python3 ~/.config/scripts/passwordGenerator.py | pbc
		pbp
	fi
}

function top_history {
	history 1 | awk '{CMD[$2]++;count++;}END {
	  for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | column -c3 -s " " -t | sort -nr | nl |  head -n25
}

function z {
	source $HOME/.zshrc
}

function theme {
	osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'
}

function path {
	if [[ -d "$1" ]] ; then
		if [[ -z "$PATH" ]] ; then
			export PATH="$1"
    	else
			export PATH="$PATH:$1"
		fi
  	fi
}
export PATH=""
path "/bin"
path "/sbin"
path "/usr/bin"
path "/usr/sbin"
path "/usr/local/bin"
path "/usr/local/sbin"
path "${HOME}/.config/homebrew/bin"
path "${HOME}/.config/cmdline/flutter/bin"
path "${HOME}/.config/cmdline/android/bin"