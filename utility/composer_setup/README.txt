#ssh into server as centos user
#Login as root
sudo su

#Clone icrp and checkout branch icrp_1.3
#Change to drupal user
su drupal
cd ~
#Option 1: (If you haven't cloned)
git clone https://github.com/CBIIT/icrp.git && cd icrp && git checkout icrp_1.3
#Option 2:  (If a clone of icrp exists)
cd icrp
git pull
git branch (Check to make sure you are on the icrp_1.3 branch)

#Uninstall panelizer
cd /local/drupal/icrp
drush pmu panelizer -y
drush cr
exit

#Change user to Super User
#You should already be root or 'sudo su'

#Move Site out of the way
cd /local/drupal
mv icrp icrp-old
rm -f moveit.sh composerit.sh composer.json.8.3.7 missing_argument_4_in_2743715-6.patch
cp -p /home/drupal/icrp/utility/composer_setup/scripts/* /local/drupal
chown drupal:drupal moveit.sh composerit.sh composer.json.8.3.7 missing_argument_4_in_2743715-6.patch
#Create directory
mkdir icrp
chown drupal:drupal icrp
chmod -R 755 icrp

#Create a Compser Site
#Change to drupal user
su drupal
cd /local/drupal
./composerit.sh icrp
exit

#Move ICRP Assets
#Change user to Super User
#You should be root user or 'sudo su'
cd /local/drupal
./moveit.sh icrp

#Clean Up
#You should already be root or 'sudo su'
rm -f moveit.sh composerit.sh composer.json.8.3.7 missing_argument_4_in_2743715-6.patch
rm -rf icrp-old

#Clear Cache
su drupal
cd /local/drupal/icrp
drush cr