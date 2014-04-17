# uHoused Web Application

##When Uploading To Heroku
Nothing to do

### HowTo Create a Dev DB from a Production DB
```
heroku pgbackups:capture --app agile-reef-8725
curl -o latest.dump `heroku pgbackups:url --app agile-reef-8725`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U alex -d uhoused_2_development latest.dump
```

### HowTo Create a Production DB from a Dev DB
Created a local dump file: ```pg_dump uhoused_2_development > uhoused_2_development.dump```

Now upload the dumpfile to S3 and create a public https://DOWNLOAD_URL.

Push the db to heroku: ```heroku pgbackups:restore HEROKU_POSTGRESQL_PINK_URL  -a agile-reef-8725 --confirm agile-reef-8725 'DOWNLOAD_URL'```

### HowTo launch on a dev machine	
Redis: ```redis-server /usr/local/etc/redis.conf```

Postgres: ```postgres -D /usr/local/var/postgres```

Rails: ```rails s```

###Merges
For difficult merges, use ```git mergetool -t opendiff```

###Load Testing
For load testing, use siege