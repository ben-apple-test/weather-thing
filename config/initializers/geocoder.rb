Geocoder.configure(
  cache: Rails.cache,
  cache_options: {
    expiration: 1.day
  }
)
