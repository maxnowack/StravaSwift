//
//  SwiftyJSONRequest.swift
//  StravaSwift
//
//  Created by Matthew on 15/11/2015.
//  Copyright © 2015 Matthew Clarkson. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension Request {
    
    public static func StravaSerializer<T: Strava>(keyPath: String?) -> ResponseSerializer<T, NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            if let json = result.value {
                let object = T.init(JSON(json))
                return .Success(object)
            }
            
            let failureReason = "StravaSerializer failed to serialize response."
            let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
            return .Failure(error)
        }
    }

    public func responseStrava<T: Strava>(completionHandler: Response<T, NSError> -> Void) -> Self {
        return responseStrava(nil, keyPath: nil, completionHandler: completionHandler)
    }
    
    public func responseStrava<T: Strava>(keyPath: String, completionHandler: Response<T, NSError> -> Void) -> Self {
        return responseStrava(nil, keyPath: keyPath, completionHandler: completionHandler)
    }
    
    public func responseStrava<T: Strava>(queue: dispatch_queue_t?, keyPath: String?, completionHandler: Response<T, NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.StravaSerializer(keyPath), completionHandler: completionHandler)
    }
    
    public static func StravaArraySerializer<T: Strava>(keyPath: String?) -> ResponseSerializer<[T], NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else {
                return .Failure(error!)
            }
            
            guard let _ = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            if let json = result.value {
                var results:[T] = []
                JSON(json).array?.forEach {
                    results.append(T.init($0))
                }

                return .Success(results)
            }
  
            let failureReason = "StravaSerializer failed to serialize response."
            let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
            return .Failure(error)
        }
    }
    
    public func responseStravaArray<T: Strava>(completionHandler: Response<[T], NSError> -> Void) -> Self {
        return responseStravaArray(nil, keyPath: nil, completionHandler: completionHandler)
    }
    
    public func responseStravaArray<T: Strava>(keyPath: String, completionHandler: Response<[T], NSError> -> Void) -> Self {
        return responseStravaArray(nil, keyPath: keyPath, completionHandler: completionHandler)
    }
    
    public func responseStravaArray<T: Strava>(queue: dispatch_queue_t?, completionHandler: Response<[T], NSError> -> Void) -> Self {
        return responseStravaArray(queue, keyPath: nil, completionHandler: completionHandler)
    }
    
    public func responseStravaArray<T: Strava>(queue: dispatch_queue_t?, keyPath: String?, completionHandler: Response<[T], NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.StravaArraySerializer(keyPath), completionHandler: completionHandler)
    }
}