//
//  GenresTableErrorConnection.swift
//  radio
//
//  Created by MacBook 13 on 8/2/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation



protocol ResponseTableConnection{
    func onError(error:AnyObject)
    func onEndResponse()
}
