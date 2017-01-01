#!/bin/sh

# kFreeBSD do not accept scripts as interpreters, using #!/bin/sh and sourcing.
if [ true != "$INIT_D_SCRIPT_SOURCED" ] ; then
  set "$0" "$@"; INIT_D_SCRIPT_SOURCED=true . /lib/init/init-d-script
fi

### BEGIN INIT INFO
# Provides:          desk
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: HomeKit utility for height-adjustable desks
# Description:       desk is an Apple HomeKit utility that connects
#                    to height-adjustable desks and makes them remotely
#                    controllable.
### END INIT INFO

DESC="desk bridge"
NAME=desk
DAEMON=/home/pi/go/src/github.com/davidknezic/desk/bridge
PIDFILE=/var/run/desk.pid
SCRIPTNAME=/etc/init.d/"$NAME".sh

test -f $DAEMON || exit 0

. /lib/lsb/init-functions

case "$1" in
start)  log_daemon_msg "Starting desk utility" "desk"
        start_daemon -p $PIDFILE $DAEMON $EXTRA_OPTS
        log_end_msg $?
        ;;
stop)   log_daemon_msg "Stopping desk utility" "desk"
        killproc -p $PIDFILE $DAEMON
        RETVAL=$?
        [ $RETVAL -eq 0 ] && [ -e "$PIDFILE" ] && rm -f $PIDFILE
        log_end_msg $RETVAL
        ;;
restart) log_daemon_msg "Restarting desk utility" "desk"
        $0 stop
        $0 start
        ;;
status)
        status_of_proc -p $PIDFILE $DAEMON $NAME && exit 0 || exit $?
        ;;
*)      log_action_msg "Usage: /etc/init.d/desk {start|stop|status|restart}"
        exit 2
        ;;
esac
exit 0
