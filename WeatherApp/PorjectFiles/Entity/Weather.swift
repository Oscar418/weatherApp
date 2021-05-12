import Foundation

class Weather {
    var maxTemp: Double?
    var minTemp: Double?
    var mainTemp: Double?
    
    init(with dictionary: [String: Any]?) {
        self.maxTemp = dictionary?["temp_max"] as? Double
        self.minTemp = dictionary?["temp_min"] as? Double
        self.mainTemp = dictionary?["temp"] as? Double
    }
}
