//
//  NetController.swift
//  radio
//
//  Created by MacBook 13 on 7/18/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation

protocol NetError{
    func onError(error:AnyObject)
}

enum MyError: Error {
    case RuntimeError(String)
}

class NetController{
    
    var url:String! = nil //Specified url to consume
    var responseProtocol:NetProtocol? = nil //Response for consume
    
    var onError:NetError? = nil//On error case control error

    
    
    
    /*
        Run the conection to server
     */
    public func task() throws {
        
        if(url==nil){
            throw MyError.RuntimeError("Error in NetController url==nil")
        }
        if(responseProtocol==nil){
            throw MyError.RuntimeError("Error in NetController responseProtocol==nil")
        }
        
        var request = URLRequest(url: URL(string: url)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 10
        urlconfig.timeoutIntervalForResource = 10
        
        request.httpMethod = "GET"
        let session = URLSession(configuration: urlconfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)//URLSession.shared
        request.timeoutInterval = 10
        
        session.dataTask(with: request) {data, response, error in
            if error != nil {
                
                print(error) //Error to console
                
                //Send error down
                self.onError?.onError(error: error as AnyObject)
                
            } else {
                if data != nil {
                    
                    let string:String = String(data: data!, encoding: String.Encoding.utf8)! //Response string from server
                    
                    let netResponse:NetResponseModel =  self.getNetResponseModel(result: string) //Get NetResponseModel
                    
                    if(netResponse.status==200){ //All is ok
                        self.responseProtocol?.result(data: netResponse.datas) //Send the result
                    }
                }
            }
        }.resume()
        
        /*let urlString = URL(string: url)
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    
                    print(error) //Error to console
                    
                    //Send error down
                    self.onError?.onError(error: error as AnyObject)
                    
                } else {
                    if data != nil {
                        
                        let string:String = String(data: data!, encoding: String.Encoding.utf8)! //Response string from server
                        
                        let netResponse:NetResponseModel =  self.getNetResponseModel(result: string) //Get NetResponseModel
                        
                        if(netResponse.status==200){ //All is ok
                            self.responseProtocol?.result(data: netResponse.datas) //Send the result
                        }
                    }
                }
            }
            task.resume();
        }*/
    }
    
    
    /*
        Convert to dictorionary from string
     */
    internal func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
        
    /*
     Get  NetResponse model from string
     */
    private func getNetResponseModel(result:String) -> NetResponseModel{
        
        let data = convertStringToDictionary(text: result)
        let netResponseModel:NetResponseModel = NetResponseModel()
        if(data != nil){
            netResponseModel.status = data!["status"] as! NSNumber;
            netResponseModel.msg = data!["msg"] as! String;
            netResponseModel.datas = data!["datas"] as AnyObject;
        }
        
        return netResponseModel;
    }
}
