#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/librabbitmq.sh

# Load RabbitMQ environment variables
eval "$(rabbitmq_env)"

# Ensure RabbitMQ environment variables settings are valid
rabbitmq_validate
# Ensure RabbitMQ is stopped when this script ends.
trap "rabbitmq_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$RABBITMQ_DAEMON_USER" "$RABBITMQ_DAEMON_GROUP"
# Ensure RabbitMQ is initialized
rabbitmq_initialize

USERS=$(rabbitmqctl list_users)
if [[ "$USERS" =~ (xray) ]]
then
    rabbitmqctl authenticate_user xray xray
else
    rabbitmqctl add_user xray xray
fi
rabbitmqctl set_user_tags xray administrator
rabbitmqctl set_permissions -p / xray ".*" ".*" ".*"