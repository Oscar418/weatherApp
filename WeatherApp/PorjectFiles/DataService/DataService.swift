import Foundation
import Alamofire

class DataService: DataServiceProtocol {
    
    let baseURL = "https://api.openweathermap.org/data/2.5"
    
    func get(with path: Path, city: String, completion: @escaping (Any?, Error?) -> Void) {
        let url = "\(self.baseURL)\(path.rawValue)"
        let parameters = ["q": city,
                          "appid": "b1480af94fc55e1d23fe57b19595d5f8"]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding(destination: .queryString)).responseJSON { response in
            switch (response.result) {
            case .success(let value):
                completion(value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
