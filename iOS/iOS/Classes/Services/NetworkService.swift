//
//  Requester.swift
//  Daily Esport
//
//  Created by Dao Duy Duong on 10/7/15.
//  Copyright © 2015 Nover. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift

typealias callServerCompleteCallback = (DataResponse<Any>) -> Void
typealias progressBlockDownload = (_ progress: Double?, _ error: NSError?,_ index : Int, _ completed: Bool) -> Void
typealias progressBlock = (_ progress: Double?, _ error: NSError?) -> Void

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

class NetworkService {
    
    var reqManager: SessionManager
    var requests = [Request]()
    
    // MARK: - Init
    
    init() {
        let config = URLSessionConfiguration.default
        config.httpShouldSetCookies = true
        config.httpCookieAcceptPolicy = .always
        config.requestCachePolicy = .reloadRevalidatingCacheData
        config.timeoutIntervalForRequest = 60
        reqManager = Alamofire.SessionManager(configuration: config)
        reqManager.delegate.sessionDidReceiveChallengeWithCompletion = sessionDidReceiveChallengeWithCompletion
    }
    
    func post(withAction soapAction: String? = nil, body: String? = nil, additionalHeaders: HTTPHeaders? = nil) -> Observable<String> {
        return Observable.create { observer in
            let headers = self.makeHeaders(soapAction, additionalHeaders: additionalHeaders)
            let request = self.reqManager.request(Api.endpoint, method: .post, parameters: nil, encoding: body ?? URLEncoding.default, headers: headers)
            
            print("CALL API: \(soapAction ?? "")")
            
            request.responseString { response in
                print (response)
                if let error = response.result.error {
                    observer.onError(error)
                } else if let jsonString = response.result.value {
                    observer.onNext(jsonString)
                } else {
                    observer.onError(NSError.unknownError)
                }
                
                observer.onCompleted()
            }
            
            self.requests.append(request)
            
            return Disposables.create {
                self.requests = self.requests.filter { $0 !== request }
                request.cancel()
            }
        }
    }
    
    private func cancelAll() {
        while let request = requests.popLast() {
            request.cancel()
        }
    }
    
    private func cancelLastRequest() {
        if let request = requests.popLast() {
            request.cancel()
        }
    }
    
    private func makeHeaders(_ soapAction: String?, additionalHeaders: HTTPHeaders?) -> HTTPHeaders {
        var headers = ["Content-Type": "text/xml; charset=utf-8"]
        if let soapAction = soapAction {
            headers["SOAPAction"] = soapAction
        }
        
        if let additionalHeaders = additionalHeaders {
            additionalHeaders.forEach { pair in
                headers.updateValue(pair.value, forKey: pair.key)
            }
        }
        
        return headers
    }
    
    private func sessionDidReceiveChallengeWithCompletion(_ session: URLSession, _ challenge: URLAuthenticationChallenge, _ completionHandler: ((URLSession.AuthChallengeDisposition, URLCredential?) -> Void)) {
        
        completionHandler(.performDefaultHandling, nil)
        
    }
    
    // MARK: Upload images
    
    func upload(withAction soapAction: String, images: [UIImage]?) -> Observable<String> {
        return Observable.create { observer in
            let headers = ["Content-Type": "multipart/form-data"]

            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for i in images! {
                    let imgData = i.jpegData(compressionQuality: 1)
                    if let data = imgData {
                        multipartFormData.append(data, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
                    }
                }
            }, to:Api.endpoint + soapAction, headers: headers) { (result) in
                switch result {
                case .success(let upload, _, _):

                    upload.uploadProgress(closure: { progressCurrent in
                        print("upload: " + "\(progressCurrent.fractionCompleted)")
                    })
                    
                    upload.responseJSON(completionHandler: { response in
                        if let jsonString = response.result.value {
                            observer.onNext((jsonString as! NSDictionary).toJSON() ?? "")
                        }
                    })
                    
                case .failure(let error):
                    observer.onError(error)
                    break
                }
            }
            
            return Disposables.create()
        }
        

    }
    
}


