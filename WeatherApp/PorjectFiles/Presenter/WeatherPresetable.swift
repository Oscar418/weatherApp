import Foundation

protocol WeatherPresentable {
    var view: WeatherPresenterViewable?{get set}
    func fetchWeather(city: String)
    func fetchForecast(city: String)
    func onFetchWeatherSuccess(weather: WeatherEntity)
    func onFetchForecastSuccess(data: Forecast)
    func onFetchWeatherFailure(with error: Error?)
}
