//
//  NetConsumer.swift
//  radio
//
//  Created by MacBook 13 on 7/14/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation
import SwiftHTTP

struct Response: Codable {
    let status: String?
    let error: String?
}


enum MyError: Error {
    case RuntimeError(String)
}

class NetConsumer:NetProtocol {
    
    var url:String!=nil
    
    
    
    
    func consume() throws {
        
        if(self.url==nil) {
            throw MyError.RuntimeError("self.url==nill")
        }
        
        /*
        HTTP.GET(self.url)  { response in
            if let err = response.error { //err.localizedDescription
                throw MyError.RuntimeError("Exception in " + err.localizedDescription)
            }
            else{ //response.data, response.description
                result.result(data: result)
            }
        }
 */
    }

}
