# CONFIGURACION DE ZSHRC

# Alias
alias ls="eza -lh --icons --color=always --group-directories-first"
alias la="eza -lah --icons --color=always --group-directories-first"

# Custom SSH MOTD
if [[ -o interactive && -n "$SSH_CONNECTION" ]]; then
    ~/.config/motd/system-info.sh
fi
