# gcloud-scripts
A set of scripts developed while working with google cloud instances, probably useful for any other cloud computing engine.

## Scripts
* `shutdown_hook.sh`: A hook script in charge of shutting down your machine after computing is finished. Just provide a PID and it will poweroff when the process is done. Obviously it has to run inside the cloud instance.
* `gcloud_poll.sh`: Sometimes machines just hang. This script runs in a another machine monitoring the cloud instance. When it stops responding ssh (i.e.: it has hanged), it send a power-off signal through gcloud command-line. **it requires gcloud command-line and gcloud.env file**
* `gcloud.env`: Settings for the `gcloud_poll` script.

## MIT License

