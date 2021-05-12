import Foundation

class WeatherPresenter: WeatherPresentable {
    
    var view: WeatherPresenterViewable?
    var interactor: WeatherInteractable?
    
    func fetchWeather(city: String) {
        self.interactor?.fetchWeather(city: city)
    }
    
    func fetchForecast(city: String) {
        self.interactor?.fetchForecast(city: city)
    }
    
    func onFetchWeatherSuccess(weather: WeatherEntity) {
        self.view?.showOnSuccess(with: weather)
    }
    
    func onFetchForecastSuccess(data: Forecast) {
        self.view?.showOnSuccessForecast(with: data)
    }
    
    func onFetchWeatherFailure(with error: Error?) {
        self.view?.showOnFailure(with: error)
    }
}
