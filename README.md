Requires
========
Ruby
PostGres

Since the data source only returns the last 30 days of data
we need to run the updater periodically. Below is an example
of using cron to run the rake task once a day at midnight.
```
0 0 * * * cd /path/to/dir rake earthquakes:update_local
```