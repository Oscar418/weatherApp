import Foundation

class WeatherInterator: WeatherInteractable {
    var service: DataServiceProtocol?
    var weatherPresentable: WeatherPresentable?
    
    func fetchWeather(city: String) {
        self.service?.get(with: .weather, city: city, completion: { (response, error) in
            if let failure = error {
                self.weatherPresentable?.onFetchWeatherFailure(with: failure)
            } else {
                let value = response as? [String: Any]
                let weather = WeatherEntity(with: value)
                self.weatherPresentable?.onFetchWeatherSuccess(weather: weather)
            }
        })
    }
    
    func fetchForecast(city: String) {
        self.service?.get(with: .forecast, city: city, completion: { (response, error) in
            if let failure = error {
                self.weatherPresentable?.onFetchWeatherFailure(with: failure)
            } else {
                let value = response as? [String: Any]
                let forecastData = Forecast(with: value)
                self.weatherPresentable?.onFetchForecastSuccess(data: forecastData)
            }
        })
    }
}
