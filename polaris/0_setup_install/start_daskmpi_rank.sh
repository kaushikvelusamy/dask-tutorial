#step 3
#start_daskmpi_rank.sh 
# create this script in the 'RAPIDS_WORKDIR' directory. make sure to change it's permission chmod 755 start_daskmpi_rank.sh 

ROLE=$1
HOSTNAME=$HOSTNAME
LOCAL_DIRECTORY=~/dask-local-directory
SCHEDULER_FILE=$LOCAL_DIRECTORY/scheduler.json
LOGDIR="$LOCAL_DIRECTORY/logs"
WORKER_DIR="/tmp/dask-workers/"
DASHBOARD_PORT=8787

# Purge Dask worker and log directories
if [ "$ROLE" = "SCHEDULER" ]; then
    rm -rf $LOCAL_DIRECTORY/*
    mkdir -p $LOGDIR
    rm -rf $WORKER_DIR/*
    mkdir -p $WORKER_DIR
fi

# Purge Dask config directories
rm -rf ~/.config/dask

# Dask/distributed configuration
export DASK_DISTRIBUTED__COMM__TIMEOUTS__CONNECT="100s"
export DASK_DISTRIBUTED__COMM__TIMEOUTS__TCP="600s"
export DASK_DISTRIBUTED__COMM__RETRY__DELAY__MIN="1s"
export DASK_DISTRIBUTED__COMM__RETRY__DELAY__MAX="60s"
export DASK_DISTRIBUTED__WORKER__MEMORY__Terminate="False"

if [ "$ROLE" = "SCHEDULER" ]
then
    # Setup scheduler
    nohup dask-scheduler --dashboard-address $DASHBOARD_PORT --scheduler-file $SCHEDULER_FILE > $LOGDIR/$HOSTNAME-scheduler.log 2>&1 &
fi

sleep 2
 
if [ "$ROLE" != "SCHEDULER" ]
then
    # Setup workers
    dask-worker --no-nanny --local-directory ${WORKER_DIR} --scheduler-file $SCHEDULER_FILE >> $LOGDIR/$HOSTNAME-worker.log 2>&1
fi
