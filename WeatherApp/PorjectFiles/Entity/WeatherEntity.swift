import Foundation

class WeatherEntity {
    var weatherTemperatures: Weather?
    var weatherCondition: [WeatherCondition]?
    
    init(with dictionary: [String: Any]?) {
        self.weatherTemperatures = Weather(with: dictionary?["main"] as? [String:Any])
        self.weatherCondition = [WeatherCondition]()
        
        guard let weatherConditions = dictionary?["weather"] as? [[String:Any]] else {
            return
        }
        
        for item in weatherConditions {
            self.weatherCondition?.append(WeatherCondition(with: item))
        }
    }
}
