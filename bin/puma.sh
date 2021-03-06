#! /bin/sh
###############################
# puma的操作脚本
# /home/wwwroot/ror.deploy
APP_PATH=/home/wwwroot/ror.deploy/shared
PUMA_CONFIG_FILE=$APP_PATH/config/puma.rb
PUMA_PID_FILE=$APP_PATH/tmp/pids/puma.pid
PUMA_SOCKET=$APP_PATH/tmp/sockets/puma.sock

# check if puma process is running
puma_is_running() {
  if [ -S $PUMA_SOCKET ] ; then
    if [ -e $PUMA_PID_FILE ] ; then
      if cat $PUMA_PID_FILE | xargs pgrep -P > /dev/null ; then
        return 0
      else
        echo "No puma process found"
      fi
    else
      echo "No puma pid file found"
    fi
  else
    echo "No puma socket found"
  fi
  return 1
}

case "$1" in
  start)
    echo "Starting puma..."
      rm -f $PUMA_SOCKET
      touch -f $PUMA_SOCKET
      touch -f $PUMA_PID_FILE
      if [ -e $PUMA_CONFIG_FILE ] ; then
        bundle exec puma -C $PUMA_CONFIG_FILE
      else
        bundle exec puma
      fi

    echo "done"
    ;;

  stop)
    echo "Stopping puma..."
      kill -s SIGTERM `cat $PUMA_PID_FILE`
      rm -f $PUMA_PID_FILE
      rm -f $PUMA_SOCKET
    echo "done"
    ;;

  restart)
    if puma_is_running ; then
      echo "Hot-restarting puma..."
      # SIGUSR2
      kill -s 12 `cat $PUMA_PID_FILE`

      echo "Doublechecking the process restart..."
      sleep 5
      if puma_is_running ; then
        echo "done"
        exit 0
      else
        echo "Puma restart failed :/"
      fi
    fi

    echo "Trying cold reboot"
    echo [ -S $PUMA_SOCKET ]
    bin/puma.sh start
    ;;

  *)
  echo "Usage: bin/puma.sh {start|stop|restart}" >&2
  ;;
esac
