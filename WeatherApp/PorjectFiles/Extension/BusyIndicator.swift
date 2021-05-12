import UIKit

var activityView = UIActivityIndicatorView(style: .large)

extension UIViewController {
    
    func showBusyView() {
        activityView.center = self.view.center
        activityView.color = .white
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
    func hideBusyView() {
        activityView.stopAnimating()
        activityView.isHidden = true
        activityView.removeFromSuperview()
    }
}
