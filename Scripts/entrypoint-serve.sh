#!/bin/sh
set -e

./Run serve --env $ENV --hostname $HOSTNAME --port $PORT
#./Run generateScenarioFile --folder $FOLDER --output-file $OUTPUT_FILE
#./Run serve --env prod --hostname 0.0.0.0 --port 80