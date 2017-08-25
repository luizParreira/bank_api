## Build the project

### Docker (recommended)

If you are on Linux, install docker for Linux:
- https://docker.github.io/engine/installation/

If you are on MacOS, install Docker, VirtualBox, docker-machine and NFS.
- https://docs.docker.com/docker-for-mac/
- https://www.virtualbox.org/wiki/Downloads
- https://docs.docker.com/machine/install-machine/
- Run `docker-machine create default --driver virtualbox --virtualbox-memory "3072"`, to create a VM.
- Run `eval $(docker-machine env)`
- Install NFS https://github.com/adlogix/docker-machine-nfs

### Building the project

1. Give execute permissions to the start script: `chmod +x script/start.sh` (from the project's root)
2. Run `docker-compose build`
3. Once the project is built, run `docker-compose up`
4. Once it finishes compiling and bringing the app up, you should be able to access the app on:
  - Run: `docker-machine ip`
  - You should be able to access the app by routing to the docker-machine ip printed from the command above. For example, `http://192.168.99.100:4000`.
  - Or you might have already mapped this locally to `localhost` or `dev. For example, `http://localhost:4000` or `http://dev:4000`.

### Locally

You will need to have all these dependencies installed:

- Elixir installed
- Phoenix Framework
- Postgres

Once you have installed it, you should:

1. Give permission to the script to execute `chmod +x script/start.sh`.
2. Run the script `./script/start.sh`

