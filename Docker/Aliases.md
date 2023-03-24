# Docker aliases

Add in `~/.bashrc` these aliases :
```sh
# Docker aliases
alias dp='docker ps -a'
alias di='docker images -a'
alias dv='docker volume ls'
alias dr='docker rm'
alias dra='docker rm -f $(docker ps -a -q)'
alias dip='docker image prune'
alias dipa='docker image prune -a'
alias dspa='docker system prune -a'
```