autoload -U add-zle-hook-widget

.zsh-enable-sgr-mouse() { :; }
zsh-enable-sgr-mouse() {
    if (( ${1:-1} )); then
        .zsh-enable-sgr-mouse() { printf '\x1b[?1000;1006h'; }
        .zsh-enable-sgr-mouse
        # reenable in case something disables it
        add-zle-hook-widget line-pre-redraw .zsh-enable-sgr-mouse
    else
        .zsh-enable-sgr-mouse() { }
        printf '\x1b[?1000;1006l'
    fi
}

.sgr-mouse-input() {
    local REPLY buf=
    while IFS= read -r -k1 && ! [[ "$REPLY" =~ [mM] ]] && (( ${#buf} < 10 )); do
        buf+="$REPLY"
    done

    local action
    case "$REPLY" in
        M) action=down ;;
        m) action=up ;;
        *) return ;;
    esac

    local button x y
    IFS=';' read -r button x y <<<"$buf"

    local modifiers=()
    if (( button & 16 )); then
        modifiers+=( control )
    fi
    if (( button & 8 )); then
        modifiers+=( meta )
    fi
    if (( button & 4 )); then
        modifiers+=( shift )
    fi
    (( button &= ~4 & ~8 & ~16 ))
    case "$button" in
        0)  button=left ;;
        1)  button=middle ;;
        2)  button=right ;;
        64) button=scrollup; action= ;;
        65) button=scrolldown; action= ;;
        *)  button="button$((button & ~64 & ~128))" ;;
    esac
    local funcname="on-mouse-${modifiers[@]:+${(j:-:)modifiers[@]}-}${button}${action:+-$action}"

    if [[ "${functions[$funcname]+x}" == x ]]; then
        "$funcname" "$button" "$x" "$y" "$action" "${modifiers[*]}"
    fi
}

bindkey '\e[<' .sgr-mouse-input
zle -N .sgr-mouse-input
zle -N zsh-enable-sgr-mouse

bindmouse() {
    functions[on-mouse-$1]="${(q)2}"' "$@"'
}
