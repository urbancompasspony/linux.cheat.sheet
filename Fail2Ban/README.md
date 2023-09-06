# Configure

sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

Set custom jail.local, and:

sudo systemctl enable fail2ban && sudo systemctl restart fail2ban

sudo ufw allow ssh

sudo ufw disable && sudo ufw enable 
