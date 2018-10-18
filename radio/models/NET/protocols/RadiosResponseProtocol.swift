//
//  RadiosResponseProtocol.swift
//  radio
//
//  Created by MacBook 13 on 8/7/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation



/*
 Protocol for response in connection with web service and return of data
 */

protocol RadiosResponseProtocol{
    func result(data:[RadioModel]);
}
