#!/bin/bash
echo "Programa de backup full"
echo " "
NARQ="bkp-WK_CS"
###############################################################################
dadosfull() {
###############################################################################
SRARQ=/trab/backup/files-backup.lst  #arquivo que contem os diretorios que serao feito backup
DSTDIR=/trab/backup #diretorio de destino do backup
DATA=`date +%d-%m-%Y-%H.%M.%S`
#DATA=`date +%x-%k%M%S` #pega data atual
TIME_BKCP=+30 #numero de dias em que seráeletado o arquivo de backup
#Criar dump da Tabela Mysql
rm /trab/backup/dump/*  -rf > /dev/null
mysqldump --user=SEUUSUARIO --password=SUASENHA --database SEUDATABASE > /trab/backup/dump/dump-acsf-WK-$DATA
#criar o arquivo .rar no diretó de destino
NARQ="bkp-WK_CS"
ARQ=$DSTDIR/$NARQ-$DATA.rar
#data de inicio backup
DATAIN=`date +%c`
echo "Data de inicio: $DATAIN"

}
###############################################################################
backupfull(){
###############################################################################
sync
rar a -dh $ARQ @$SRARQ >> /var/log/backup.log
if [ $? -eq 0 ] ; then
   echo "----------------------------------------"
   echo "Backup Full concluido com Sucesso"
   DATAFIN=`date +%c`
   echo "Data de termino: $DATAFIN"
   echo "Backup realizado com sucesso" >> /var/log/backup_full.log
   echo "Criado pelo usuario: $USER" >> /var/log/backup_full.log
   echo "INICIO: $DATAIN" >> /var/log/backup_full.log
   echo "FIM: $DATAFIN" >> /var/log/backup_full.log
   echo "-----------------------------------------" >> /var/log/backup_full.log
   echo " "
   echo "Log gerado em /var/log/backup_full.log"
else
   echo "ERRO! Backup do dia $DATAIN" >> /var/log/backup_full.log
fi
}
###############################################################################
procuraedestroifull(){
###############################################################################
#apagando arquivos mais antigos (a mais de dias que existe)
find $DSTDIR -name "$NARQ*" -ctime $TIME_BKCP -exec rm -f {} ";"
   if [ $? -eq 0 ] ; then
      echo "Arquivo de backup mais antigo eliminado com sucesso!"
   else
      echo "Erro durante a busca e destruicao do backup antigo!"
   fi
}
###############################################################################
dadosfull
backupfull
procuraedestroifull

###############PREPARANDO PARA GRAVAR NO DVD+RW###############################
umount /dev/dvd
echo "Formatando DVD..."
/usr/bin/dvd+rw-format -force /dev/dvd > /var/log/backdvd.log 2>&1
echo "Gravando dados no DVD..."
growisofs -speed=2 -Z /dev/dvd -R -J /trab/backup/$NARQ-"$DATA".rar
eject

####################TESTANDO A GRAVACAO#######################################
#echo "Iniciando teste de gravacao"
#mount /dev/dvd
#INITESTE=`date +%d-%m-%Y-%H.%M.%S`
#INITESTE=`date +%c`
#echo "Teste de midia iniciado em $INITESTE" > /var/log/backdvd.log
#rar t /media/cdrom0/SACIBACKUP-"$DATA".rar >> /var/log/backdvd.log
#FIMTESTE=`date +%c`
#echo "Teste de midia finalizado em $FIMTESTE" >> /var/log/backdvd.log
#umount /dev/dvd
exit 0
