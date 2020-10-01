1. #!/bin/bash
2. if [[ -z "$NGROK_TOKEN" ]]; then
3.   echo "Please set 'NGROK_TOKEN'"
4.   exit 2
5. fi
6. if [[ -z "$SSH_PASSWORD" ]]; then
7.   echo "Please set 'SSH_PASSWORD' for user: $USER"
8.   exit 3
9. fi
10. wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip
11. unzip ngrok-stable-linux-386.zip
12. chmod +x ./ngrok
13. echo -e "$SSH_PASSWORD\n$SSH_PASSWORD" | sudo passwd "$USER"
14. rm -f .ngrok.log
15. ./ngrok authtoken "$NGROK_TOKEN"
16. ./ngrok tcp 22 --log ".ngrok.log" &
17. sleep 10
18. HAS_ERRORS=$(grep "command failed" < .ngrok.log)
19. if [[ -z "$HAS_ERRORS" ]]; then
20.   echo ""
21.   echo "To connect: $(grep -o -E "tcp://(.+)" < .ngrok.log | sed "s/tcp:\/\//ssh $USER@/" | sed "s/:/ -p /")"
22.   echo ""
23. else
24.   echo "$HAS_ERRORS"
25.   exit 4
26. fi
