# Docker aliases

Add in `~/.bashrc` these aliases :
```sh
# Docker aliases
alias dps='docker ps -a'
alias dim='docker images -a'
alias dvo='docker volume ls'
alias drm='docker rm'
alias ds='docker stop'
alias drma='docker rm -f $(docker ps -a -q)'
alias dimp='docker image prune'
alias dimpa='docker image prune -a'
alias dsypa='docker system prune -a'
alias dhist='docker history --no-trunc'
alias dst='docker stats'
alias dtop='docker top'
de() {
        docker exec -it $1 $2
}
drun() {
        docker run -dit --name $1 $2
}
```