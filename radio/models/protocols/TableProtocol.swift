//
//  TableProtocol.swift
//  radio
//
//  Created by MacBook 13 on 8/20/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation


protocol TableProtocol{
    
    /*
        When the scroll of the table ends
     */
    func onScrollEnd()
    
    /*
        Before make a server request
     */
    func beforeServerConnection()
}
