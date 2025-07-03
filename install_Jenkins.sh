#!/bin/bash
# Jenkins Installation Script (RHEL/CentOS/Fedora with dnf)

date_var=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(basename "$0")
LOGFILE="/tmp/${SCRIPT_NAME}-${date_var}.log"

# Define color codes
R="\e[31m"  # Red for failure
G="\e[32m"  # Green for success
Y="\e[33m"  # Yellow for info
N="\e[0m"   # Reset color

# Check for root/sudo
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${R}Error: Please run this script with sudo/root access.${N}"
    exit 1
fi

# Validation function
VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2 ..... ${R}Failed${N}"
        exit 1
    else
        echo -e "$2 ...... ${G}Successful${N}"
    fi
}

echo -e "${Y}Setting up Jenkins repository...${N}"
curl -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo &>> $LOGFILE
VALIDATE $? "Downloaded Jenkins repo using curl"

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key &>> $LOGFILE
VALIDATE $? "Imported Jenkins GPG key"

echo -e "${Y}Upgrading system packages...${N}"
dnf upgrade -y &>> $LOGFILE
VALIDATE $? "System upgrade with dnf"

echo -e "${Y}Installing Java 17 and dependencies...${N}"
dnf install -y fontconfig java-17-openjdk-devel &>> $LOGFILE
VALIDATE $? "Installed fontconfig and OpenJDK 17"

echo -e "${Y}Installing Jenkins...${N}"
dnf install -y jenkins &>> $LOGFILE
VALIDATE $? "Installed Jenkins"

echo -e "${Y}Reloading systemd and starting Jenkins service...${N}"
systemctl daemon-reexec &>> $LOGFILE
systemctl daemon-reload &>> $LOGFILE

systemctl enable jenkins &>> $LOGFILE
VALIDATE $? "Enabled Jenkins service"

systemctl start jenkins &>> $LOGFILE
VALIDATE $? "Started Jenkins service"

echo -e "${Y}Checking Jenkins status...${N}"
systemctl status jenkins &>> $LOGFILE
VALIDATE $? "Jenkins is running"

echo -e "${G}Jenkins installation completed successfully!${N}"
echo -e "Access Jenkins at: http://<your-server-ip>:8080"
