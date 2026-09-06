if status is-interactive
    # Commands to run in interactive sessions can go here
end

# === Aliases ===
alias ls="ls --color=auto"
alias lslah="ls -lah"
alias grep="grep --color=auto"
alias cls="clear"
alias g="git"
alias gaa="git add ."
alias gst="git status"
alias gco="git checkout"
alias glg="glab auth login"

alias wails="~/go/bin/wails"

alias sbashrc="source ~/.config/fish/config.fish"

alias vi="nvim"
# alias vi="NVIM_APPNAME=nvim-12 nvim"

alias dock="sudo docker"
alias dockcp="sudo docker-compose"
alias win11='xfreerdp3 /v:127.0.0.1:3389 /u:adics /p:hehe1234 /cert:ignore /sec:tls /f'
alias netminer='mono /opt/NetworkMiner_*/NetworkMiner.exe --noupdatecheck'
alias cr="cursor"
alias nvim12="NVIM_APPNAME=nvim-12 nvim"
alias python="python3"
alias sshp="ssh -i"

alias uvsrcrun="uvicorn src.main:app --reload"

alias cpenvc="python3.12 -m venv .venv" # c prefix = Claverio
alias penvc="python -m venv .venv" # python system (3.14)
alias penv="source .venv/bin/activate.fish"
alias pmanage="python manage.py" # already inside .venv

alias agent="cursor-agent"

if test pnpm
	alias lc4s="pnpx likec4 start"
end

# === Prompt ===
# Starship handles the prompt when available (see Plugins below).

# === Paths (skip missing dirs so fresh machines stay quiet) ===
for p in \
    $HOME/.asdf/shims \
    $HOME/.local/bin \
    /opt/android-studio/bin \
    $HOME/.encore/bin \
    $HOME/go/bin \
		/opt/homebrew/opt/rustup/bin \
    /opt/homebrew/opt/ffmpeg-full/bin
    if test -d $p
        fish_add_path $p
    end
end

# === Env variables ===
set -gx WINAPPS_SRC_DIR $HOME/.local/bin/winapps-src

if test -d $HOME/.encore
    set -gx ENCORE_INSTALL $HOME/.encore
end

if test -d $HOME/Pictures/Screenshots
    set -gx HYPRSHOT_DIR $HOME/Pictures/Screenshots
end

if test -n "$DISPLAY"; or test -n "$WAYLAND_DISPLAY"
    set -gx QT_QPA_PLATFORMTHEME "gtk3"
end

if test -d /opt/homebrew/opt/ffmpeg-full
    set -gx LDFLAGS "-L/opt/homebrew/opt/ffmpeg-full/lib"
    set -gx CPPFLAGS "-I/opt/homebrew/opt/ffmpeg-full/include"
end

# Oracle Instant Client (optional)
if test -d $HOME/instant-client
    set -gx OCI_HOME $HOME/instant-client
    set -gx DYLD_LIBRARY_PATH (string join : $OCI_HOME $DYLD_LIBRARY_PATH)
    fish_add_path $OCI_HOME
end

if test -e $HOME/.config/fish/env.private.fish
    source $HOME/.config/fish/env.private.fish
end

# === Plugins (soft-guarded) ===
command -q starship; and starship init fish | source
command -q zoxide; and zoxide init fish | source

if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

command -q asdf; and asdf completion fish 2>/dev/null | source

# bun
if test -d $HOME/.bun
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path $BUN_INSTALL/bin
end

# Grok
if test -d $HOME/.grok/bin
		fish_add_path $HOME/.grok/bin
end
