# Weather Thing

A Ruby on Rails application that provides weather forecasts based on US addresses and zip codes.

## Infrastructure
+ Database SQLite
+ Caching SolidCache

This uses default Ruby on Rails 8 settings out of the box which opts for SQLite and Solidcache for the database store and caching. Other production setups typically reach for Postgresql and Redis, but for this usecase, these options are more than plenty and simplify things for deploying to a cloud provider like Digital Ocean. 

If we were scaling or had multiple instances of our weather app Postgresql and Redis would probably be a more appropriate choice for a shared and consistent state.

## Weather Data
This app uses [OpenMeteo](https://open-meteo.com/en/docs) for weather data, which is free and does not require any api validation. It just requires you to have the Latitude and Longitude and know what kind of information you want to lookup for that particular location.

### Caching Strategy - Zip Code over Complete Address
The prompt specified that the forecast data be cached based on zip code rather than the entire address, so when we do the coordinate look up and and the subsequent forecast fetch we only use the zipcode. We do collect and validate complete address information in the main form so its possible for us to do more with it in the future, but the most granular bit of location data we actually use is the zip code.

## Location Data
### Geocoder
Geocoder is a well established gem that by default uses OpenStreetmap data to lookup coordinates and location data. In real life production we would probably want to use a paid service or host our own but it works out of the box and is easy for now. 

### ZipCodes
This app has a ZipCodes table that contains a dump of all of the ZipCodes available from the USPS website. This table is used to do some validation on the supplied zip codes that are fed into Geocoder



