import Foundation
import Swinject

struct DependencyContainer {
    
    static func container() -> Container {
        let container = Container()
        
        container.register(WeatherPresentable.self) { r in
            let presenter = WeatherPresenter()
            let weatherInteractor = WeatherInterator()
            presenter.interactor = weatherInteractor
            weatherInteractor.service = r.resolve(DataServiceProtocol.self)
            weatherInteractor.weatherPresentable = presenter
            return presenter
        }
        
        container.register(DataServiceProtocol.self) { r in
            return DataService()
        }
        
        return container
    }
}
