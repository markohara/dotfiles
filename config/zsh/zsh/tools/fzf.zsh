export FZF_DEFAULT_COMMAND='fd -tf -td -tl -te -H --hidden'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls j--color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

zstyle ':fzf-tab:*' use-fzf-default-opts yes

# zstyle ':fzf-tab:*' fzf-flags --hidden  --follow --exclude .git --color=fg:1,fg+:2 --bind=tab:accept


# fzf config
eval "$(fzf --zsh)"

# Set FZF to show hidden files
# export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


# bg="#2A2928"
# fg="#CBE0F0"
# bg_highlight="#333231"
# accent="#E6005F"
# blue="#06BCE4"
# cyan="#2CF9ED"
# green="#5AF78E"

# export FZF_DEFAULT_OPTS="
#   --color=fg:$fg,bg:$bg,hl:$blue
#   --color=fg+:$fg,bg+:$bg_highlight,hl+:$cyan
#   --color=info:$accent,prompt:$green,pointer:$accent
#   --color=marker:$accent,spinner:$cyan,header:$accent
# "

