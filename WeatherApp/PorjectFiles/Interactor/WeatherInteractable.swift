import Foundation

protocol WeatherInteractable {
    func fetchWeather(city: String)
    func fetchForecast(city: String)
}
