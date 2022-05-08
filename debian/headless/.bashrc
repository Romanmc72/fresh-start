alias l='l'
alias ll='ls -al'
alias lll='ls -alh'
alias ..='cd ..'
alias lines='wc -l'

function math() {
    # Because math with python is way easier than using straight bash
    python -c "print($@);"
}
