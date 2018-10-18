//
//  URLS.swift
//  radio
//
//  Created by MacBook 13 on 7/14/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation


class URLS{
    
    static let HOST = "http://192.168.1.68/RadioAPI/admin_panel/"
    static let GENRES_HOST = HOST + "uploads/genres/"
    static let RADIOS_HOST = HOST + "uploads/radios/"
    static let GENRES_LIST = HOST + "api/api.php?method=getGenres&api_key=eHJhZGlvcGVyZmVjdGFwcA"
    static let SET_FAVORITE = HOST + "api/api.php?method=setFavorite&val=%val%&id=%id%&api_key=eHJhZGlvcGVyZmVjdGFwcA"
    static let DETAIL_ONE_RADIO = HOST + "api/api.php?method=getRadios&api_key=eHJhZGlvcGVyZmVjdGFwcA&radio_id=1"
    static let TOPCHART_RADIOS_WITH_PAGING = HOST + "api/api.php?method=getRadios&api_key=eHJhZGlvcGVyZmVjdGFwcA&offset=0&limit=10&is_feature=1"
    static let RADIOS_LIST_WITH_PAGING_PARAMS = HOST + "api/api.php?method=getRadios&api_key=eHJhZGlvcGVyZmVjdGFwcA&offset=%offset%&limit=%limit%&radio_id=&q=%q%"
    static let SEARCH_RADIOS_WITH_PAGING = HOST + "api/api.php?method=getRadios&api_key=eHJhZGlvcGVyZmVjdGFwcA&offset=0&limit=10&q=edm"
    static let RADIOS_OF_GENRE_WITH_PAGING = HOST + "api/api.php?method=getRadios&api_key=eHJhZGlvcGVyZmVjdGFwcA&offset=0&limit=10&genre_id=1"
    static let THEMES_WITH_PAGING_PARAMS = HOST + "api/api.php?method=getThemes&api_key=eHJhZGlvcGVyZmVjdGFwcA&offset=%offset%&limit=%limit%"
    static let THEME_OF_SINGLE_RADIO_APP = HOST + "api/api.php?method=getThemes&api_key=eHJhZGlvcGVyZmVjdGFwcA&app_type=1"
    static let REMOTE_CONFIGS = HOST + "api.php?method=getRemoteConfigs&api_key=eHJhZGlvcGVyZmVjdGFwcA"
    static let PRIVACY_POLICY = HOST + "privacy_policy.php"
    static let TERM_OF_USE = HOST + "term_of_use.php"
}
