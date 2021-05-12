import Foundation

class ForecastData {
    var weather: [WeatherCondition]?
    var weatherTemperatures: Weather?
    var date: String?
    
    init(with dictionary: [String: Any]?) {
        self.weather = [WeatherCondition]()
        self.weatherTemperatures = Weather(with: dictionary?["main"] as? [String:Any])
        self.date = dictionary?["dt_txt"] as? String
        
        guard let weatherConditions = dictionary?["weather"] as? [[String:Any]] else {
            return
        }
        
        for item in weatherConditions {
            self.weather?.append(WeatherCondition(with: item))
        }
    }
}
