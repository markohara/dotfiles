export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.0.0/bin:$PATH

export PATH=$HOME/.local/bin:$PATH
export SESSIONIZER_PROJECTS="$HOME/config:$HOME/dotfiles"

[[ -f ~/.zprofile.local ]] && source ~/.zprofile.local || true