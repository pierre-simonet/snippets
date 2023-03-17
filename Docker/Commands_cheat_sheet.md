# Docker advanced cheat sheet

## ***Debugging*** Show complete log during build 
Add this to your `docker build` command : `--progress=plain`

## ***Debugging*** How to expose intermediate containers
Edit your docker build with : `DOCKER_BUILDKIT=0 docker build ...`

<br/>

# Dockerfile examples

## DB2 database

### DB2 client in container
- [Makefile](DB2/DB2_client_in_container/Makefile)
- [Dockerfile](DB2/DB2_client_in_container/Dockerfile)

### DB2 server in container
- [Makefile](DB2/DB2_server_in_container/Makefile)
- [Dockerfile](DB2/DB2_server_in_container/Dockerfile)

### DB2 server in ibmcom/db2 container
- [Makefile](DB2/DB2_server_in_ibmcom_db2_container/Makefile)

## Oracle database
### Oracle server in container
- [Makefile](Oracle/Oracle_server_in_container/Makefile)
- [Dockerfile](Oracle/Oracle_server_in_container/Dockerfile)