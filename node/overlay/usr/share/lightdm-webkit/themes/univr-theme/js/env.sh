DEVNAME=$(ip address | grep 'state UP' | awk '{print $2}' | sed s/://g)
IPNAME=$(ip address show dev $DEVNAME | grep inet | awk '{print $2}' | cut -f 1 -d /)

echo "env = {"
echo "  PROFILE: '$PROFILE',"
echo "  IPNAME: '$IPNAME'"
echo "}"
