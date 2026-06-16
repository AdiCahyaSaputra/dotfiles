if status is-interactive
    # Commands to run in interactive sessions can go here
end

# === Initial Command ===

# === Aliases ===
alias ls="ls --color=auto"
alias lslah="ls -lah"
alias grep="grep --color=auto"
alias cls="clear"
alias g="git"
alias gaa="git add ."
alias gst="git status"
alias glg="glab auth login"

alias sbashrc="source ~/.config/fish/config.fish"

alias vi="nvim"
# alias vi="NVIM_APPNAME=nvim-12 nvim"
alias vim="nvim"

alias dock="sudo docker"
alias dockcp="sudo docker-compose"
alias win11='xfreerdp3 /v:127.0.0.1:3389 /u:adics /p:hehe1234 /cert:ignore /sec:tls /f'
alias netminer='mono /opt/NetworkMiner_*/NetworkMiner.exe --noupdatecheck'
alias cr="cursor"
alias nvim12="NVIM_APPNAME=nvim-12 nvim"
alias python="python3"

# === Prompt ===
# In Bash you had: PS1='[\u@\h \W]\$ '
# In Fish you normally use `fish_prompt` function or Starship (see below).
# We'll let Starship handle prompt.

# === Paths ===
# Use fish_add_path instead of export PATH=...
fish_add_path $HOME/.asdf/shims
fish_add_path $HOME/.local/bin
fish_add_path /opt/android-studio/bin
fish_add_path /home/adics/.encore/bin
fish_add_path /home/adics/go/bin

# === Env variables ===
set -Ux WINAPPS_SRC_DIR $HOME/.local/bin/winapps-src
set -Ux ENCORE_INSTALL "/home/adics/.encore"

set -Ux HYPRSHOT_DIR "/home/adics/Pictures/Screenshots"
set -Ux QT_QPA_PLATFORMTHEME "gtk3"

if test -e $HOME/.config/fish/env.private.fish
	source $HOME/.config/fish/env.private.fish
end

# === Plugins ===
starship init fish | source
zoxide init fish | source

# === Git completion (Fish auto has strong git support, but if you want asdf/git completion) ===
# For asdf:
asdf completion fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
