#
# Creates a Drupal 8.2.7 Website from Scratch.
#
# Define a timestamp function
if [ "$1" = "" ]
then
  echo "**"
  echo "* Syntax: $0 <DOC_ROOT>"
  # <DB_NAME> <DB_USER> <DB_PASSWORD> <SETTINGS_PHP_PATH>"
  #echo "* Enter the document root, db name, db user, and db password"
  #echo "* Enter the FULL path to the settings.php file to replace after the build"
  echo "**"
  exit
fi
echo -n "START TIME: "
timestamp
DOC_ROOT=$1 

echo "**"
echo "* Clear cache files (without this it was causing problems.)"
echo "**"
echo "composer clear-cache"
composer clear-cache

#rm all files
echo "**"
echo "* Remove all files from $DOC_ROOT"
echo "**"
echo "mkdir -p $DOC_ROOT"
rm -rf $DOC_ROOT/.git
rm -rf $DOC_ROOT/.gitignore
rm -rf $DOC_ROOT/*

mkdir -p $DOC_ROOT

echo "**"
echo "* Composer init"
echo "**"
composer create-project drupal-composer/drupal-project:8.x-dev $DOC_ROOT --stability dev --no-interaction

cd $DOC_ROOT
rm -rf web/

echo "**"
echo "* Copy composer.json.8.2.7 and run composer update "
echo "**"
cp ../composer.json.8.3.7 ./composer.json
cp ../missing_argument_4_in_2743715-6.patch .

echo "You should have your composer.json"

# Run composer update
echo "**"
echo "* composer update drupal/core --with-dependencies\n**"
echo "**"
composer update
# Run composer update
drush cr
