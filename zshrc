# CONFIGURACION DE ZSHRC

# Alias
alias ls="eza -lh --icons --color=always --group-directories-first"
alias la="eza -lah --icons --color=always --group-directories-first"

# Custom SSH MOTD
if [[ -o interactive && -n "$SSH_CONNECTION" ]]; then
    ~/.config/motd/system-info.sh
fi

# Pronmpt configuration

function dir_icon {
        if [[ "$PWD" == "$HOME" ]]; then
                echo "%B%F{black}%f%b"
        else
                echo "%B%F{cyan}%f%b"
        fi
}

function parse_git_branch {
        local branch
        branch=$(git symbolic-ref --short HEAD 2> /dev/null)
        if [ -n "$branch" ]; then
                echo " [$branch]"
        fi
}

PROMPT='%F{red} %f %F{magenta}%n%f $(dir_icon) %F{red}%~%f%${vcs_info_msg_0_} %F{yellow}$(parse_git_branch)%f %(?.%B%F{green}.%F{red})%f%b '

