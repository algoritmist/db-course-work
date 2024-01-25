#/bin/sh


# Fill data
chmod +x backend/sql/quick-populate.sh
sh backend/sql/quick-populate.sh

# set new public html
rm -rf ~/public_html
cp -r site/* ~/public_html

# start php server
cd site/php && php -S localhost:5050