# Weather Thing

A Ruby on Rails application that provides weather forecasts based on US addresses and zip codes.

## Infrastructure
+ Database => SQLite
+ Caching => SolidCache
+ Location => Geocoder/Nominatim

This uses default Ruby on Rails 8 settings out of the box which opts for SQLite and Solidcache for the database store and caching. Other production setups typically reach for Postgresql and Redis, but for this usecase, these options are more than plenty and simplify things for deploying to a cloud provider like Digital Ocean. 

If we were scaling or had multiple instances of our weather app Postgresql and Redis would probably be a more appropriate choice for a shared and consistent state.

## Weather Data
This app uses [OpenMeteo](https://open-meteo.com/en/docs) for weather data, which is free and does not require any api validation. It just requires you to have the Latitude and Longitude and know what kind of information you want to lookup for that particular location.

## Location Data
### Geocoder
Geocoder is a well established gem that by default uses Nominatim data to lookup coordinates and location data. In real life production we would probably want to use a paid service or host our own but it works out of the box and is easy for now. 

### ZipCodes
This app has a ZipCodes table that contains a dump of all of the ZipCodes available from the USPS website. This table is used to do validation on the supplied zip code that is fed into Geocoder. This also narrows the set of supported zip codes to just zipcodes from the united states.


