//
//  XRadioNetUtils.swift
//  radio
//
//  Created by MacBook 13 on 7/10/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation

class XRadioNetUtils{
    
    static var FORMAT_API_END_POINT:String = "/api/api.php?method=%1$s";
    static var METHOD_GET_GENRES:String = "getGenres";
    static var METHOD_GET_RADIOS:String = "getRadios";
    static var METHOD_GET_THEMES:String = "getThemes";
    static var METHOD_GET_REMOTE_CONFIGS:String = "getRemoteConfigs";
    
    static var METHOD_PRIVACY_POLICY:String = "/privacy_policy.php";
    static var METHOD_TERM_OF_USE:String = "/term_of_use.php";
    
    static var KEY_API:String = "&api_key=";
    static var KEY_QUERY:String = "&q=";
    static var KEY_GENRE_ID:String = "&genre_id=";
    static var KEY_APP_TYPE:String = "&app_type=";
    static var KEY_OFFSET:String = "&offset=";
    static var KEY_LIMIT:String = "&limit=";
    static var KEY_IS_FEATURE:String = "&is_feature=1";
    
    static var FOLDER_GENRES:String = "/uploads/genres/";
    static var FOLDER_RADIOS:String = "/uploads/radios/";
    static var FOLDER_THEMES:String = "/uploads/themes/";
}
