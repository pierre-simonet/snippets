# Docker advanced cheat sheet

## ***Debugging*** Show complete log during build 
Add this to your `docker build` command : `--progress=plain`

## ***Debugging*** How to expose intermediate containers
Edit your docker build with : `DOCKER_BUILDKIT=0 docker build ...`