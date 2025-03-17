module WeatherCacheable
  extend ActiveSupport::Concern

  def read_cache(key)
    Rails.cache.read(cache_key_for(key))
  end

  def write_cache(key, value)
    Rails.cache.write(cache_key_for(key), value, expires_in: cache_ttl)
  end

  private

  def cache_key_for(key)
    "#{key}_#{zip_code}"
  end

  def zip_code
    context.zip_code
  end

  def cache_ttl
    30.minutes
  end
end
