import Foundation

class Forecast {
    var list: [ForecastData]?
    
    init(with dictionary: [String: Any]?) {
        self.list = [ForecastData]()
        
        guard let weatherConditions = dictionary?["list"] as? [[String:Any]] else {
            return
        }
        
        for item in weatherConditions {
            self.list?.append(ForecastData(with: item))
        }
    }
}
