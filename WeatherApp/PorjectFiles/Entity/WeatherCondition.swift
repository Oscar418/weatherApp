import Foundation

class WeatherCondition {
    var condition: String?
    
    init(with dictionary: [String: Any]?) {
        self.condition = dictionary?["main"] as? String
    }
}
