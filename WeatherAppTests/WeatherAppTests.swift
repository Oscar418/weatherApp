import XCTest
import Alamofire
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
}

extension WeatherAppTests {
    func testWeatherValidApiCallGetsHTTPStatusCode200() throws {
        try checkNetworkConnectivity()
        let baseURL = "https://api.openweathermap.org/data/2.5"
        let path = "/weather"
        let url = "\(baseURL)\(path)"
        let parameters = ["q": "Johannesburg",
                          "appid": "b1480af94fc55e1d23fe57b19595d5f8"]
        let promise = expectation(description: "Status code: 200")
        var statusCode = 0
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString)).responseJSON { response in
            statusCode = response.response?.statusCode ?? 0
            if statusCode == 200 {
                promise.fulfill()
            } else {
                XCTFail("Status code: \(statusCode)")
            }
        }
        wait(for: [promise], timeout: 5)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testForecastValidApiCallGetsHTTPStatusCode200() throws {
        try checkNetworkConnectivity()
        let baseURL = "https://api.openweathermap.org/data/2.5"
        let path = "/forecast"
        let url = "\(baseURL)\(path)"
        let parameters = ["q": "Johannesburg",
                          "appid": "b1480af94fc55e1d23fe57b19595d5f8"]
        let promise = expectation(description: "Status code: 200")
        var statusCode = 0
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString)).responseJSON { response in
            statusCode = response.response?.statusCode ?? 0
            if statusCode == 200 {
                promise.fulfill()
            } else {
                XCTFail("Status code: \(statusCode)")
            }
        }
        wait(for: [promise], timeout: 5)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testForecastDataModel() throws {
        if let path = Bundle.main.path(forResource: "forecastJSON", ofType: "JSON") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let list = json?["list"] as? [[String: Any]]
            let viewModel = ForecastData(with: list?.first)
            let date = viewModel.date ?? ""
            let minTemperature = viewModel.weatherTemperatures?.minTemp
            let maxTemperature = viewModel.weatherTemperatures?.maxTemp
            let mainTemperature = viewModel.weatherTemperatures?.mainTemp
            let condition = viewModel.weather?.first?.condition
            XCTAssertEqual(date, "2021-05-13 15:00:00")
            XCTAssertEqual(condition, "Clear")
            XCTAssertEqual(minTemperature, 294.37)
            XCTAssertEqual(maxTemperature, 296.14)
            XCTAssertEqual(mainTemperature, 296.14)
        } else {
            print("Can't find json file")
        }
    }
    
    func testForecastModel() throws {
        if let path = Bundle.main.path(forResource: "forecastJSON", ofType: "JSON") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let viewModel = Forecast(with: json)
            let forecastCount = viewModel.list?.count
            XCTAssertEqual(forecastCount, 40)
        } else {
            print("Can't find json file")
        }
    }
    
    func testWeatherDataModel() throws {
        if let path = Bundle.main.path(forResource: "weatherDataJSON", ofType: "JSON") {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let viewModel = WeatherEntity(with: json)
            let weatherCount = viewModel.weatherCondition?.count
            XCTAssertEqual(weatherCount, 1)
        } else {
            print("Can't find json file")
        }
    }
}

extension WeatherAppTests {
    func checkNetworkConnectivity() throws {
        try XCTSkipUnless(
            Reachability.isConnected(),
            "Network connectivity needed for this test.")
    }
}
