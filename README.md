# About the project

This is a project to test [Traefik](https://docs.traefik.io) and [Blue-Green Deployment](https://martinfowler.com/bliki/BlueGreenDeployment.html) using Docker Containers.

### How to run

First, you must to run this command to start Traefik and base network:

```
./setup-traefik-and-network.sh my_traefik_network
```

Now, you can run this command to deploy containers behind Traefik:

```
./deployment.sh primal-cd 3 my_traefik_network

or

./deployment.sh state-cd 3 my_traefik_network
```

By the end of each command execution, the environment color will have changed.

You can verify, running this command:

```
docker ps --format "{{.Names}}"
```

Finally, you can access the project in web browser or using curl.

* http://primal-cd.docker.localhost
* http://state-cd.docker.localhost
