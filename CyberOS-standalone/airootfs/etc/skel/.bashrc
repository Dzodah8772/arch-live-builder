[[ $- != *i* ]] && return
alias ll='ls -lah --color=auto'
alias update='sudo pacman -Syu'
PS1='\[\e[38;2;0;255;159m\]\u@\h\[\e[0m\] \w \$ '
command -v fastfetch &>/dev/null && fastfetch
