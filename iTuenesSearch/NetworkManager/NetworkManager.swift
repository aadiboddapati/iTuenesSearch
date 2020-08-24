//
//  ViewModel.swift
//  iTuenesSearch
//
//  Created by chiranjeevi macharla on 23/08/20.
//  Copyright © 2020 Adinarayana. All rights reserved.
//


import Foundation
import UIKit

enum HTTPMethodType: String {
    case POST = "POST" , GET = "GET", DELETE = "DELETE", UPDATE = "UPDATE" , PUT = "PUT"
}

typealias completionBlock =  (_ response :HTTPURLResponse?, _ results : Data?, _ error : Error?) -> Void


class Networkmanager {
    
    lazy var networkSession: URLSession = {
        let aSessionConfiguration = URLSessionConfiguration.default
        aSessionConfiguration.httpMaximumConnectionsPerHost = 6
        let session = URLSession(configuration: aSessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
        return session
    }()
    
    private static let sharedInstance : Networkmanager = {
        return Networkmanager()
    }()
    
    private init()
    {
    }
    
    class func shared() -> Networkmanager {
        return sharedInstance
    }
    
    
   // MARK: API's
    func getApiApiWithParmeters(apiName : String, httpType : HTTPMethodType , callBack : @escaping completionBlock)
    {
        let  api =  apiName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let  requestURL = URL(string: api)
        var request  = URLRequest(url: requestURL!)
        request.httpMethod = httpType.rawValue
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                
        let  dataTask = networkSession.dataTask(with: request, completionHandler: { (data, response, error ) in
            let httpResponse = response as? HTTPURLResponse
            if let data = data {
                 print("response \(String(describing: data))")
                callBack(httpResponse,data,error)
            } else {
                callBack(httpResponse,nil,error)
            }
        })
        dataTask.resume()
    }
    
}
