#!/bin/sh

# Definitions
TARGETIP=192.168.0.100
PATH=$HOME/embedded-linux-ng-labs/integration/buildroot-2022.02.3/output/host/bin:$PATH
EXEC=nunchuk-mpd-client
CROSS_COMPILE=arm-linux-

# Rebuild executable
${CROSS_COMPILE}gcc -g -o $EXEC $EXEC.c $(pkg-config --libs --cflags libmpdclient)

# Kill gdbserver on the target
ssh root@$TARGETIP killall gdbserver

# Copy over new executable
scp $EXEC root@$TARGETIP:/root/

# Start gdbserver on the target
ssh -n -f root@$TARGETIP "sh -c 'nohup gdbserver localhost:2345 /root/nunchuk-mpd-client > /dev/null 2>&1 &'"
