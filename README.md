# taudem_docker
Up-to-date TauDEM Docker image

*This TauDEM Docker image includes* `catchhydrogeo`*.*


**The following instructions are for Docker. Instructions for Singularity are below**.

TauDEM commands may be run as one-off commands using this Docker image using the following shell command as a template:

```
docker run --name hand_taudem_bash --rm -i -t dhardestylewis/taudem:tacc --mount type=bind,source="$(pwd)",target="/mnt/host" pitremove -z /mnt/host/DEM.tif -fel /mnt/host/DEMfel.tif
```

or multiple TauDEM commands may be run in sequence bringing up the Docker image once for all commands using the following shell command as a template:

```
docker run --name taudem_bash --rm -i -t dhardestylewis/taudem:tacc --mount type=bind,source="$(pwd)",target="/mnt/host" bash taudem_commands.sh
```

where `taudem_commands.sh` is written according to this template:

```
#!/bin/bash
pitremove -z /mnt/host/DEM.tif -fel /mnt/host/DEMfel.tif
```


**Singularity instructions.**

The Singularity pull command is similar to the Docker pull command:

```
singularity pull \
    --name taudem.sif \
    docker://dhardestylewis/taudem_docker:tacc
```

Once pulled, a one-off TauDEM command using Singularity can be issued:

```
singularity exec \
    taudem.sif \
    bash -c "pitremove -z /mnt/host/DEM.tif -fel /mnt/host/DEMfel.tif"
```

An interactive shell in the Singularity container may be used for troubleshooting or debugging:

```
singularity exec \
    taudem.sif \
    bash
```


**TauDEM combined with other commands in a shell script**

TauDEM may be wrapped in a shell script and run using Docker:

```
docker run \
    --name taudem_bash \
    --rm \
    -i \
    -t \
    dhardestylewis/taudem_docker:tacc \
    --mount type=bind,source="$(pwd)",target="/mnt/host" \
    bash -c './taudem_commands.sh'
```

where the file `taudem_commands.sh` may be written as:

```
#!/bin/bash

## Execute TauDEM
pitremove -z /mnt/host/DEM.tif -fel /mnt/host/DEMfel.tif 
```

To do the same using Singularity, execute:

```
singularity exec \
    taudem.sif \
    bash -c './taudem_commands.sh'
```    

where `taudem_commands.sh` is written as above.


