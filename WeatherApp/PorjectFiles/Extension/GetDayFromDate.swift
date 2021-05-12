import UIKit

extension UIViewController {
    func getDay(dateAsString: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateAsString)!
        let day = Calendar.current.component(.weekday, from: date)
        return day
    }
}
