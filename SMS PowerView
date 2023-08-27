#!/bin/bash
while true
do

echo " " > /home/administrador/Temp/Powerview_A
echo " " > /home/administrador/Temp/Powerview_B
echo " " > /home/administrador/Temp/Powerview_C

tmux new-session -d -s SMS '/home/administrador/SMS/powerview -c | tee -a /home/administrador/Temp/Powerview_A'
sleep 2
tmux send-keys -t SMS: "1"
sleep 2
tmux send-keys -t SMS: "Enter"
sleep 2
sed '/^$/d' /home/administrador/Temp/Powerview_A > /home/administrador/Temp/Powerview_B
tmux send-keys -t SMS: "0"
sleep 2
tmux send-keys -t SMS: "Enter"
sleep 2
tmux send-keys -t SMS: "0"
sleep 2
tmux send-keys -t SMS: "Enter"
sleep 2

echo " " > /home/administrador/Temp/Powerview_A

tmux new-session -d -s SMS '/home/administrador/SMS/powerview -c | tee -a /home/administrador/Temp/Powerview_A'
sleep 2
tmux send-keys -t SMS: "2"
sleep 2
tmux send-keys -t SMS: "Enter"
sleep 2
sed '/^$/d' /home/administrador/Temp/Powerview_A >> /home/administrador/Temp/Powerview_B
tmux send-keys -t SMS: "0"
sleep 2
tmux send-keys -t SMS: "Enter"
sleep 2
tmux send-keys -t SMS: "0"
sleep 2
tmux send-keys -t SMS: "Enter"
sleep 2

sed '1,8d' "/home/administrador/Temp/Powerview_B" > "/home/administrador/Temp/Powerview_C"
sed '10,16d' "/home/administrador/Temp/Powerview_C" > "/home/administrador/Temp/Powerview_B"

sed -i 's/$/<br>/' "/home/administrador/Temp/Powerview_B"

info=$(cat /home/administrador/Temp/Powerview_B)

echo "<!DOCTYPE html>
<html><meta http-equiv="refresh" content="30" >
<head><title>Nobreak SMS</title></head><font size="+2">
<body>
<h2>Nobreak SMS - Leitura em Tempo Real</h2>
$info
<h4>AutoRefresh a cada 30s!</h4>
</body>
</font></html>
" > /srv/containers/apache2/Data/index.html

done

# Maintenance
# tmux attach-session -t SMS
# tmux kill-session -t SMS
