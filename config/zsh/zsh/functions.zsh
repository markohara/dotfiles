# Opens tmux-sessionizer if not in neo vim
open_sessionizer() {
    if [ -z "$NVIM" ]; then
        BUFFER="tmux-sessionizer"
        zle accept-line
    fi
}

clean_screen() {
    zle clear-screen
}
