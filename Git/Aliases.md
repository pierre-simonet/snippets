# Git aliases

Add in `~/.gitconfig` these aliases :
```
[alias]

        hist = log --color --graph --pretty=format:'%Cred%h%Creset %C(bold white)%ad%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --date=short --abbrev-commit
        ha = log --all --color --graph --pretty=format:'%Cred%h%Creset %C(bold white)%ad%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --date=short --abbrev-commit
        ls = log --pretty=format:'%Cred%h%Creset%C(yellow)%d %Creset%s%C(bold blue) <%cn>' --decorate
        ll = log --pretty=format:'%Cred%h%C(yellow)%d %Creset%s%C(bold blue) <%cn>' --decorate --numstat
        lds = log --pretty=format:'%Cred%h %C(bold white)%ad%C(yellow)%d %Creset%s%C(bold blue) <%cn>' --decorate --date=short
        ld = log --pretty=format:'%Cred%h%C(yellow)%d %Creset%s %Cgreen(%ad)%C(bold blue) <%cn>' --decorate --date=relative
        f = "!git ls-files | grep -i"
        dl = "!git ll -1"
        dlc = diff --cached HEAD^
        sh = show HEAD
        cp = cherry-pick
        mylog = log --pretty=format:"%ad:%an:%d:%B" --date=short --reverse --all --author=Pierre
        latest = for-each-ref --count=30 --sort=committerdate refs/heads/ --format='%(refname:short)'
        hs = "!git hist -n30"
        has = "!git ha -n30"
        ls-files = diff-tree --no-commit-id --name-status -r
        dc = diff --cached
        st = status -s
        sh = show HEAD
        diff = diff --word-diff
        sl = stash list
        ss = stash save
        su = stash save -u
        sp = stash pop
        sa = stash apply
        sd = stash drop
        sad = "!f() { git stash apply "$1" && git stash drop "$1"; }; f"
```