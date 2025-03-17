class FetchWeatherForecast
  include Interactor

  def call
    context.fail!
  end
end
