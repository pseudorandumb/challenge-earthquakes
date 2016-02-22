Coding Challenge
================
This project uses Earthquake data from http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson. The source returns data from the previous 30 days but data furthur back is needed. In order to store more days the data needs to be periodically pulled and saved. There is an example cron job below to enable such a thing. The "most dangerous places" can be found by using the bash script "./most-dangerous-places num_places(int) num_days(int)"

TODO / Changes
--------------
I would use different sources like the 1 day source if polling every day rather than using the 30 day everytime. Looking at the documentation it looks like I could actually use a different query to actively look at past data and save it locally to allow for queries going furthur back, but didn't use it since I was suppose to only use the 30 day query. Saving to the databse is slow because it creates/updates one record at a time. Ideally I'd do a bulk update but figured since this wasn't time sensitive and would be running as a job it was an ok solution.

Requires
--------
* Ruby
* PostGres
* Homebrew (suggested)

Installation
------------
A setup script is included to install dependencies and setup the database(assumes homebrew and ruby already installed).
```
./setup
```
...or if you prefer to manually install things:
```
homebrew install postgres
bundle install
rake db:create
rake db:migrate
```
Usage
-----
Database is used to store and query data.
To run the postgres in the foreground:
```
postgres -D /usr/local/var/postgres
```
background:
```
  brew services start postgres
```

To retrieve 5 most dangerous cities in the past 10 days run:  
./most-dangerous-places num_places num_days
```
./most-dangerous-places 5 10
```

Rakefile is given to update the local store of earthquakes.
```
rake earthquakes:update_local
```

Since the data source only returns the last 30 days of data
we need to run the updater periodically. Below is an example
of using cron to run the rake task once a day at midnight.
```
0 0 * * * cd /path/to/dir rake earthquakes:update_local
```
