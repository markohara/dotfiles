CONFIG=$HOME/zsh

source $CONFIG/prompt.zsh
source $CONFIG/options.zsh
source $CONFIG/zinit.zsh
source $CONFIG/history.zsh
source $CONFIG/aliases.zsh
source $CONFIG/keybinds.zsh

for file in "$CONFIG/tools"/*.zsh; do
    if [ -f "$file" ]; then
        source "$file"
    fi
done

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local || true