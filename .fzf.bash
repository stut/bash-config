# Setup fzf
# ---------
if [[ ! "$PATH" == */home/stuart/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/stuart/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/stuart/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/stuart/.fzf/shell/key-bindings.bash"
