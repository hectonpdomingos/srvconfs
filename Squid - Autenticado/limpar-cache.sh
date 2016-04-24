#!/bin/sh
#Script Criado Por Hecton P.Domingos para lipar o cache do squid
#hectonsuport@yahoo.com.br

echo "Parando o squid"
/etc/rc.d/init.d/squid stop
echo " "
echo "Limpando o cache..."
echo " "
cd /var/spool/squid ; rm -Rvf *
echo "Excluidos os arquivos"
echo " "
echo "Reiniciando o Squid"
/etc/rc.d/init.d/squid start
echo " "
echo "Concluido"

