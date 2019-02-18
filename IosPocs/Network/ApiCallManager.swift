//
//  ApiCallManager.swift
//  CajaPiuraMVP
//
//  Created by Avantica on 2/7/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//let API_BASE_URL = "http://api.nandawperdana.com"

class ApiCallManager {
    
//    static let instance = ApiCallManager()
//
//    enum RequestMethod {
//        case get
//        case post
//    }
//
//    enum Endpoint: String {
//        case People = "/people.json"
//    }
    
   class func callAPIGetPeople(onSuccess successCallback: ((_ people: [PeopleModel]) -> Void)?,onFailure failureCallback: ((_ errorMessage: String) -> Void)?) {
        var dataTask: URLSessionDataTask?
        
        // call API
        let path = Constants.URLs.API_BASE_URL + Constants.URLs.getPeople
        let urlGetUsers:URL = URL(string: path)!
        WebServicesManager.contentType = .Raw
        WebServicesManager.needsAuthorization = true
        WebServicesManager.getWithURL(urlGetUsers, parameters: nil, dataTask: &dataTask){
            (webServicesResponse: WebServicesResponse) in
            
            if let response:[String :Any] = webServicesResponse.response as? [String :Any]{
                
                let responseData = response["data"] as! [[String:Any]]
                
                // Create object
                var data = [PeopleModel]()
                for item in responseData {
                    let single = PeopleModel.build(item as [String : AnyObject])
                    data.append(single)
                }
                // Fire callback
                successCallback?(data)
            } else {
                failureCallback?("An error has occured.")
              }
                
            }
    
   
            
        
        
//        self.createRequest(
//            url, method: .get, headers: nil, parameters: nil,
//            onSuccess: {(responseObject: JSON) -> Void in
//                // Create dictionary
//                if let responseDict = responseObject["data"].arrayObject {
//                    let peopleDict = responseDict as! [[String:AnyObject]]
//
//                    // Create object
//                    var data = [PeopleModel]()
//                    for item in peopleDict {
//                        let single = PeopleModel.build(item)
//                        data.append(single)
//                    }
//
//                    // Fire callback
//                    successCallback?(data)
//                } else {
//                    failureCallback?("An error has occured.")
//                }
//        },
//            onFailure: {(errorMessage: String) -> Void in
//                failureCallback?(errorMessage)
//        })
    }
    
//    func createRequest(_ url: String,method: HTTPMethod,headers: [String: String]?,parameters: AnyObject?, onSuccess successCallback: ((JSON) -> Void)?,
//        onFailure failureCallback: ((String) -> Void)?) {
//
//        Alamofire.request(url, method: method).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                successCallback?(json)
//            case .failure(let error):
//                if let callback = failureCallback {
//                    // Return
//                    callback(error.localizedDescription)
//                }
//            }
//        }
//
//        let path:URL = URL(string: url)!
//
//
//        URLSession.shared.dataTask(with: path){ (data, response, error) in
//            if error != nil {
//                print(error!.localizedDescription)
//            }
//
//            guard let data = data else {return}
//            print(data)
//
//
//        }
//
//    }
    
}
