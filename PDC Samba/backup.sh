#!/bin/bash
# Setando variaveis de Data e Hora.
data=`date +%d-%m-%y-%H.%M`
# Acessando a pasta onde sera compactado o backup.
cd /backup
# removendo backups antigos
rm -rf /backup/*.tar.gz
# compactando backup. 
tar -czf paxa-"$data".tar.gz /focus 
# Movendo backup para a fita
tar -cvf /dev/st0 /backup/*.tar.gz
# Redirecionando Log Backup Finalizado
echo "backup concluido"
echo "Backup Concluido ""$data" >> /focus/samba/log_backup/backup_compartilhamento_"$data".txt
# ejetando Fita Dat
eject /dev/st0 

