//
//  IXRadioConstants.swift
//  radio
//
//  Created by MacBook 13 on 7/10/18.
//  Copyright © 2018 MacBook 13. All rights reserved.
//

import Foundation


class IXRadioConstants{
    
    static var DEBUG:Bool = false;
    
    static var TAG:String = "DCM";
    
    static var NUMBER_INSTALL_DAYS:Int = 0;//it is the number install days to show dialog rate.default is 0
    static var NUMBER_LAUNCH_TIMES:Int = 3;//it is the number launch times to show dialog rate.default is 3
    static var REMIND_TIME_INTERVAL = 1;//it is the number repeat days to show dialog rate.default is 1
    
    static var YOUR_CONTACT_EMAIL:String = "YOUR_CONTACT_EMAIL";
    static var URL_FACEBOOK:String = "URL_FACEBOOK";
    static var URL_TWITTER:String = "URL_TWITTER";
    static var URL_WEBSITE:String = "URL_WEBSITE";
    static var URL_INSTAGRAM :String = "URL_INSTAGRAM";
    
    static var OFFLINE_UI_CONFIG:Bool = false;
    
    static var SHOW_ADS:Bool = true; //enable all ads
    
    static var AUTO_PLAY_IN_SINGLE_MODE:Bool = true; //enable auto play in single mode
    static var BLUR_BACKGROUND_IN_SINGLE_MODE:Bool = true; //Blur background in single mode
    
    static var INTERSTITIAL_FREQUENCY:Int = 3; //click each item radio to show this one
    
    static var RESET_TIMER:Bool = true; // reset timer when exiting application
    
    static var DIR_CACHE:String = "xradio";
    
    static var ADMOB_TEST_DEVICE:String = "D4BE0E7875BD1DDE0C1C7C9CF169EB6E";
    static var FACEBOOK_TEST_DEVICE:String = "fa7ca73be399926111af1f5aa142b2d2";
    
    static var NUMBER_ITEM_PER_PAGE:Int = 10;
    static var MAX_PAGE:Int = 20;
    
    static var TYPE_TAB_FEATURED:Int = 2;
    static var TYPE_TAB_GENRE:Int = 3;
    static var TYPE_TAB_THEMES:Int = 4;
    static var TYPE_TAB_FAVORITE:Int = 5;
    static var TYPE_UI_CONFIG:Int = 6;
    static var TYPE_DETAIL_GENRE:Int = 7;
    static var TYPE_SEARCH:Int = 8;
    static var TYPE_SINGLE_RADIO:Int = 9;
    
    static var KEY_ALLOW_MORE:String = "allow_more";
    static var KEY_IS_TAB:String = "is_tab";
    static var KEY_TYPE_FRAGMENT:String = "type";
    static var KEY_ALLOW_READ_CACHE:String = "read_cache";
    static var KEY_ALLOW_REFRESH:String = "allow_refresh";
    static var KEY_ALLOW_SHOW_NO_DATA:String = "allow_show_no_data";
    static var KEY_READ_CACHE_WHEN_NO_DATA:String = "cache_when_no_data";
    static var KEY_GENRE_ID:String = "cat_id";
    static var KEY_SEARCH:String = "search_data";
    
    static var KEY_NUMBER_ITEM_PER_PAGE:String = "number_item_page";
    static var KEY_MAX_PAGE:String = "max_page";
    static var KEY_OFFLINE_DATA:String = "offline_data";
    
    static var DIR_TEMP:String = ".temp";
    
    static var FILE_CONFIGURE:String = "config.json";
    static var FILE_RADIOS:String = "radios.json";
    static var FILE_THEMES:String = "themes.json";
    static var FILE_UI:String = "ui.json";
    
    
    static var TYPE_APP_SINGLE:Int = 1;
    static var TYPE_APP_MULTI:Int = 2;
    
    static var UI_FLAT_GRID:Int = 1;
    static var UI_FLAT_LIST:Int = 2;
    static var UI_CARD_GRID:Int = 3;
    static var UI_CARD_LIST:Int = 4;
    static var UI_MAGIC_GRID:Int = 5;
    
    static var UI_BG_JUST_ACTIONBAR:Int = 0;
    static var UI_BG_FULL:Int = 1;
    
    static var UI_PLAYER_SQUARE_DISK:Int = 1;
    static var UI_PLAYER_CIRCLE_DISK:Int = 2;
    static var UI_PLAYER_ROTATE_DISK:Int = 3;
    
    static var RATE_MAGIC_HEIGHT:CFloat =  1.5;
    
    static var TAG_FRAGMENT_DETAIL_GENRE:String = "TAG_FRAGMENT_DETAIL_GENRE";
    static var TAG_FRAGMENT_DETAIL_SEARCH:String = "TAG_FRAGMENT_DETAIL_SEARCH";
    static var ALLOW_DRAG_DROP_WHEN_EXPAND:Bool = false;
    
    static var FORMAT_LAST_FM:String = "http://ws.audioscrobbler.com/2.0/?method=track.search&track=%1$s&api_key=%2$s&format=json&limit=1";
    
    static var DELTA_TIME:CLong = 30000;
    static var DEGREE:CLong = 6;
    static var ONE_HOUR:CLong = 3600000;
    
    static var MAX_SLEEP_MODE:Int = 120;
    static var MIN_SLEEP_MODE:Int = 5;
    static var STEP_SLEEP_MODE:Int = 5;
}
