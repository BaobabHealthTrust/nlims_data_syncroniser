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

* Database creation
	rake db:migrate -- it creates two tables (sites and site_sync_frequncies) in the "lims_db" database, the "lims_db_database" is the database which is created by the nlims_controller module
	rake db:seed	-- it load sites data into the sites table which is found in the lims_db database, the seed load from a file named sites.yml which is found in the public folder,
			   please make sure the file is present.



* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
