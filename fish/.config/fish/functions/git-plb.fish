function git-plb --description "Prune deleted remote branches and remove local gone branches"
    git fetch --prune

    git branch -vv \
        | awk '/: gone]/{print $1}' \
        | xargs -r git branch -D
end
