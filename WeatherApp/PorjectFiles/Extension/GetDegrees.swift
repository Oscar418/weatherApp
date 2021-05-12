import UIKit

extension UIViewController {
    func getDegrees(kelvin: Double) -> String {
        let degrees = kelvin - 273.15
        let degreesRounded = String(format: "%.0fº", degrees)
        return degreesRounded
    }
}
