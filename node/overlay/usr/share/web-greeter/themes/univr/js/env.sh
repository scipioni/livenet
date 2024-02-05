DEVNAME=$(ip address | grep 'state UP' | awk '{print $2}' | sed s/://g)
IPNAME=$(ip address show dev $DEVNAME | grep -w inet | awk '{print $2}' | cut -f 1 -d /)
RELEASE=$( cat /etc/livenet/release | cut -d'=' -f2)
echo "env = {"
echo "  PROFILE: '$PROFILE',"
echo "  IPNAME: '$IPNAME',"
echo "  VERSION: '$RELEASE'"
echo "}"
