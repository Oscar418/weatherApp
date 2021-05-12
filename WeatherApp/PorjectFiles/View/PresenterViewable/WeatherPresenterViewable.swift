import Foundation

protocol WeatherPresenterViewable {
    func showOnSuccess(with weather: WeatherEntity)
    func showOnSuccessForecast(with data: Forecast)
    func showOnFailure(with error: Error?)
}
