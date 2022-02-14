printf "\ec\e[46;34m\ainstalling...\n"
gcc -o ega SDL.c -lSDL -lm
sudo cp ega /usr/bin
cp /etc/mime.types /tmp
chmod 777 /tmp/mime.types
mv /tmp/mime.types /tmp/mime2.types
echo "application/ega ega " >> /tmp/mime2.types
sort /tmp/mime2.types > /tmp/mime.types
sudo cp /tmp/mime.types /etc/mime.types
sudo cp ega.desktop /usr/share/applications
xdg-mime install egathings-ega.xml
sudo update-mime-database /usr/share/mime
