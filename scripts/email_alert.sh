#!/bin/bash
set -x
set -e


USER="ubuntu"
LOG_DIR="/msmtp_logs/"

AuthPass=$1
receipent_email=$2
email_subject=$3
sender_email=$4
email_body_content=$5

sudo apt update -y

if ! sudo apt-get install msmtp mailutils -y; then
    echo "Failed to install msmtp and mailutils."
    exit 1
fi


email_smtp() {
sudo tee /etc/msmtprc > /dev/null <<EOF
    defaults
    auth           on
    tls            on
    tls_trust_file /etc/ssl/certs/ca-certificates.crt
    logfile        /msmtp_logs/msmtp.log

    account        yahoo
    host           smtp.mail.yahoo.com
    port           587
    from           ${sender_email}
    user           ${sender_email}
    password       ${AuthPass}

    account default : yahoo
EOF
}
email_smtp

mkdir -p $LOG_DIR
sudo chown -R $USER:$USER "$LOG_DIR"
sudo chmod 600 /etc/msmtprc

# Send the email using msmtp
echo -e "To: ${receipent_email}\nFrom: ${sender_email}\nSubject: ${email_subject}\n\n${email_body_content}" | msmtp --debug --from=${sender_email} ${receipent_email}
