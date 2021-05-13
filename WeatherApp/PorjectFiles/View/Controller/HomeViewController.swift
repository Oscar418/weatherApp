import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var minDegreeLabel: UILabel!
    @IBOutlet weak var maxDegreeLabel: UILabel!
    @IBOutlet weak var currentDegreeLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet var backgroundView: UIView!
    
    var presenter: WeatherPresentable?
    var weatherEntity: WeatherEntity?
    var forecastData: Forecast?
    var weatherData: Weather?
    var forecastDictionary = [String: String]()
    let dependancyContainer = DependencyContainer.container()
    let currentLocation = GetCurrentLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = dependancyContainer.resolve(WeatherPresentable.self)
        presenter?.view = self
        setupForecastTableViewCell()
        getCurrentLocation()
    }
    
    func getCurrentLocation() {
        currentLocation.getUserCurrentLocation(viewController: self)
        currentLocation.didUpdatedLocation = {
            self.fetchWeather(defaultCity: self.currentLocation.suburbName)
        }
    }
    
    func setupForecastTableViewCell() {
        let nib = UINib(nibName: "ForecastTableViewCell", bundle: nil)
        forecastTableView.register(nib, forCellReuseIdentifier: "forecastCell")
        forecastTableView.separatorStyle = .none
        forecastTableView.isScrollEnabled = false
    }
    
    func fetchWeather(defaultCity: String) {
        guard Reachability.isConnected() else {
            let messageLibrary = MessageLibrary(.network)
            self.showErrorMessage(library: messageLibrary)
            return
        }
        showBusyView()
        presenter?.fetchWeather(city: defaultCity)
        presenter?.fetchForecast(city: defaultCity)
    }
}

extension HomeViewController: WeatherPresenterViewable {
    func showOnSuccess(with weather: WeatherEntity) {
        hideBusyView()
        self.weatherEntity = weather
        displayResults()
    }
    
    func showOnSuccessForecast(with data: Forecast) {
        self.forecastData = data
        loadForecastDays()
    }
    
    func showOnFailure(with error: Error?) {
        hideBusyView()
        let messageLibrary = MessageLibrary(.serverFailure)
        showErrorMessage(library: messageLibrary)
    }
}

extension HomeViewController {
    func displayResults() {
        degreesLabel.text = getDegrees(kelvin: weatherEntity?.weatherTemperatures?.mainTemp ?? 0.0)
        weatherConditionLabel.text = weatherEntity?.weatherCondition?.first?.condition
        minDegreeLabel.text = getDegrees(kelvin: weatherEntity?.weatherTemperatures?.minTemp ?? 0.0)
        maxDegreeLabel.text = getDegrees(kelvin: weatherEntity?.weatherTemperatures?.maxTemp ?? 0.0)
        currentDegreeLabel.text = getDegrees(kelvin: weatherEntity?.weatherTemperatures?.mainTemp ?? 0.0)
        setWeatherImageBackground(condition: weatherEntity?.weatherCondition?.first?.condition ?? "")
    }
    
    func loadForecastDays() {
        let forecastFututeData = forecastData?.list
        for i in 0..<forecastFututeData!.count {
            let conditionStatus = forecastData?.list?[i].weather?.first?.condition ?? ""
            let date = forecastData?.list?[i].date ?? ""
            let day = getDay(dateAsString: date)
            let forecastMainTemp = getDegrees(kelvin:forecastData?.list?[i].weatherTemperatures?.mainTemp ?? 0.0)
            forecastDictionary["day \(day)"] = "\(day)"
            forecastDictionary["condition \(day)"] = conditionStatus
            forecastDictionary["temp \(day)"] = forecastMainTemp
        }
        forecastTableView.reloadData()
    }
    
    func setWeatherImageBackground(condition: String) {
        switch condition {
        case "Clear":
            weatherImage.image = UIImage(named: "forest_sunny")
            backgroundView.backgroundColor = UIColor(red: 71/255, green: 171/255, blue: 47/255, alpha: 1)
        case "Cloudy":
            weatherImage.image = UIImage(named: "forest_cloudy")
            backgroundView.backgroundColor = UIColor(red: 84/255, green: 113/255, blue: 122/255, alpha: 1)
        default:
            weatherImage.image = UIImage(named: "forest_rainy")
            backgroundView.backgroundColor = UIColor(red: 87/255, green: 87/255, blue: 89/255, alpha: 1)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day = forecastDictionary["day \(indexPath.row)"]
        let dayCondition = forecastDictionary["condition \(indexPath.row)"]
        let dayTemp = forecastDictionary["temp \(indexPath.row)"] ?? ""
        if let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as? ForecastTableViewCell {
            cell.conditionImage.image = dayCondition == "Clear" ? UIImage(named: "clear") : dayCondition == "Cloudy" ?  UIImage(named: "partlysunny") :  UIImage(named: "rain")
            cell.dayLabel.text = day == "1" ? "Monday" : day == "2" ? "Tuesday" : day == "3" ? "Wednesday" : day == "4" ? "Thursday" : day == "5" ? "Friday" : day == "6" ? "Saturday" : "Sunday"
            cell.degreesLabel.text = dayTemp
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dayAsInt = forecastDictionary["day \(indexPath.row)"]
        return dayAsInt != nil ? 50 : 0
    }
}
