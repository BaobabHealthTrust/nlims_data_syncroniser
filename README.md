[![GitHub issues](https://img.shields.io/github/issues/BaobabHealthTrust/nlims_data_syncroniser)](https://github.com/BaobabHealthTrust/nlims_data_syncroniser/issues) [![GitHub forks](https://img.shields.io/github/forks/BaobabHealthTrust/nlims_data_syncroniser)](https://github.com/BaobabHealthTrust/nlims_data_syncroniser/network) [![GitHub stars](https://img.shields.io/github/stars/BaobabHealthTrust/nlims_data_syncroniser)](https://github.com/BaobabHealthTrust/nlims_data_syncroniser/stargazers) [![GitHub license](https://img.shields.io/github/license/BaobabHealthTrust/nlims_data_syncroniser)](https://github.com/BaobabHealthTrust/nlims_data_syncroniser)

### Brief description

Nlims Data Suncroniser is a Laboratory Information Management System (LIMS) service which is used to exchange data between two sites. The exchange is done through Couchdb, using its sync functionality and MySQL. Data is exchanged, first, between MySQL and Couchdb before Couchdb syncronises with another CouchDB in another facility or site.

-Therefore, in order for syncing data from couchdb to couchdb, you have to add the sites through the user interface of this module. Two sites will have to be added, thus the site at which
 module is being installed, and the other site. The other site will probably be the molecular laboratory centre were the testing of the samples will be done.

### Dependancy

* [Nlims Controller](https://github.com/BaobabHealthTrust/nlims_controller)
* [iBLIS](https://github.com/BaobabHealthTrust/iBlis)

### Requirements

* Ruby ~> 2.5.1
* Rails ~> 5.2.1
* Bundler ~> 2.1.4
* Gem ~> 2.7.6
* MySQL ~> 5.7
* CouchDB ~> 3.1.0

### Configuration
1. Rename .example files in config.

   From the commandline, moved into config directory then rename all files with .example by removing the .example extension from then. 
   
   Here is the command: 
   ```bash
   cd config
   cp database.yml.example database.yml
   cp application.yml.example application.yml
   cp couchdb.yml.example couchdb.yml
   cp secrets.yml.example secrets.yml
   ```
   
2. Configure your site / facility.
   
   Using your text editor open application.yml in config and provide name of your site / facility, site code, district and target lab where your data will be pushing and pulling data to and fro.
   Thus, your application.yml should look like this 
   ```
   site_name: "Martin Preuss Centre"
   site_code: "MPC"
   district: 'Lilongwe'
   target_lab: "Kamuzu Central Hospital"
   ```
   
2. Configure your database.

   This section requires that [nlims_controller](https://github.com/BaobabHealthTrust/nlims_controller) be installed and running.
   While still in config folder, provide details of your nlims_controller mysql database in database.yml and nlims_controller couchdb in couchdb.yml respectively. 
   
   For database.yml, replace username with the username of your mysql and password with the password of your mysql.
   
   Here is the example:
   
   >default: &default<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;adapter: mysql2<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;encoding: utf8<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %><br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;username: **your_username**<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;password: **your_password**<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;socket: /var/run/mysqld/mysqld.sock<br>
   .<br>
   .<br>
   .<br>
   development:<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<<: *default<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;database: **your_nlims_database**<br>
   test:<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<<: *default<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;database: **your_nlims_test_database**<br>
   .<br>
   .<br>
   .<br>
   production:<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<<: *default<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;database: **your_nlims_production_database**<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;username: **your_username**<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;password: <%= ENV['NLIMS_DATABASE_PASSWORD'] %><br>
   
   In couchdb, provide details of your couchdb including protocol (whether http or https), port (normally runs on 5984, but can be replaced with your couchdb port), host, database name in form of prefix and suffix (for example, if your database name is "lims_database" then your prefix will be "lims" and "database" will be your suffix, but if your database is just "lims" then "lims" will be your prefix and no suffix), username and password.
   
   Here is an example of how your couchdb.yml will be:
   
   >development: &development<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;protocol: 'http'<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;host: **your_host**<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;port: 5984<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;prefix: **nlims**<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;suffix: **repo**<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;username: **your_username**<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;password: **your_password**<br>
   &nbsp;<br>
   test:<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<<: *development<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;suffix: test<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   production:<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<<: *development<br>
   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;protocol: 'http'<br>
   
   
### Installation

   Install ruby gems by running the following command:
   ```bash
   bundle install
   ```
   Initiate database by running this command;
   ```bash
   rails db:migrate
   rails db:seed
   ```
    
### Development

   To run the application in development server, type the following in commandline:
   ```bash
   rails s -p 3011
   ```
   Or using a passenger
   ```bash
   passenger start -p 3011
   ```
### Test

### Production

   To deploy the application in production you can either use nginx or apache2 servers. Nginx is recommended since it has been tested and approved by our deployment team.
   
   1. Initialize database
   
      To initialize database for development, in the database.yml folder in production block, provide the name of the database and the username. In your commandline type the following (replacing **your_password** with your actual password of mysql database):
      ```
      export NLIMS_DATABASE_PASSWORD='your_password'
      ```
      
      Then run the following commands to create, migrate and seed data into your database:
      ```bash
      rails db:create RAILS_ENV=production
      rails db:migrate RAILS_ENV=production
      rails db:seed RAILS_ENV=production
      ```
      
   2. Deploy
   
### Contribution

We are very much willing to have your contributions. 
Contact [BHT](http://baobabhealth.org/) software development team @ developers@bht-mw.org for such arrangements.

### Issues

Issues with the system can be logged on directy here on [git](https://github.com/BaobabHealthTrust/nlims_data_syncroniser/issues). You can also contact [BHT](http://baobabhealth.org/) software support team @ bhtsupport@bht-mw.org.

### License

[MPL-2.0](https://github.com/BaobabHealthTrust/nlims_controller/blob/master/LICENSE)
