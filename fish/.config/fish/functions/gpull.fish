function gpull --wraps 'git pull' --description 'Pull from GitLab with auto-login'
    if not glab auth status >/dev/null 2>&1
        echo "Logging into GitLab..."
        glab auth login
    end
    git pull $argv
end
