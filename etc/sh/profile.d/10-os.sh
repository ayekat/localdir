# OS/distribution information

OS_NAME=''
if [ -e /etc/os-release ]; then
	OS_NAME="$(. /etc/os-release && echo "$ID")"
else
	OS_NAME="$(uname)"
fi
export OS_NAME
