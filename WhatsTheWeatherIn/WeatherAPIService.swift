
//
//  WeatherAPIService.swift
//  WhatsTheWeatherIn
//
//  Created by Marin Benčević on 16/05/16.
//  Copyright © 2016 marinbenc. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import SwiftyJSON

class WeatherAPIService {
    
    fileprivate struct Constants {
        static let APPID = "6a700a1e919dc96b0a98901c9f4bec47"
        static let baseURL = "http://api.openweathermap.org/"
    }
    
    enum ResourcePath: String {
        case Forecast = "data/2.5/forecast"
        case Icon = "img/w/"
        
        var path: String {
            return Constants.baseURL + rawValue
        }
    }
    
    enum APIError: Error {
        case cannotParse
    }
    
    func search(withCity city: String)-> Observable<Weather> {
        
        let encodedCity = city.withPercentEncodedSpaces
        
        let params: [String: AnyObject] = [
            "q": encodedCity as AnyObject,
            "units": "metric" as AnyObject,
            "type": "like" as AnyObject,
            "APPID": Constants.APPID as AnyObject
        ]
        print("do search... \(ResourcePath.Forecast.path) \(params)")
        
        
        
        return json(.get, ResourcePath.Forecast.path, parameters: params, encoding: URLEncoding.default, headers: nil).flatMap { json -> Observable<Weather> in
            print(json)
            guard let weather = Weather(json: json as! JSON) else {
                return Observable.error(APIError.cannotParse)
            }
            
            return Observable.just(weather)
        }
        
        
        
        
        
//        return request(.get, ResourcePath.Forecast.path, parameters: params, encoding: .URLEncodedInURL)
//            .rx_JSON()
//            .map(JSON.init)
//            .flatMap { json -> Observable<Weather> in
//                guard let weather = Weather(json: json) else {
//                    return Observable.error(APIError.CannotParse)
//                }
//                
//                return Observable.just(weather)
//            }
    }
//        return request(.GET, ResourcePath.Icon.path + imageID + ".png").rx_data()
    func weatherImage(forID imageID: String) -> Observable<Data>{
//        return request(.GET, ResourcePath.Icon.path + imageID + ".png").rx_data()
//        return request(.get, ResourcePath.Icon.path + imageID + ".png")
        return RxAlamofire.data(.get, ResourcePath.Icon.path + imageID + ".png")
    }
}
















