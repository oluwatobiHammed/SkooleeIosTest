//
//  StringResource.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation

enum StringResource: String {
    case lets_get_started = "onBoardingGetStarted"
    case welcome_back = "welcome_back"
    case welcome_back_description = "ob_welcome_back_description"
    case i_have_an_fcmb_account = "ob_have_account"
    case i_dont_have_an_fcmb_account = "ob_dont_have_account"
    case enter_your_bank_account = "enter_your_bank_account"
    case username = "username"
    case password = "password"
    case email = "email"
    case invalid_account = "invalid_account"
    case invalid_account_msg = "invalid_account_msg"
    case enter_pin = "enter_pin"
    case we_cant_find_you = "we_cant_find_you"
    case ob_we_cant_find_you_text = "ob_we_cant_find_you_text"
    case enter_otp_here = "enter_otp_here"
    case ob_otp_cant_find_text = "ob_otp_cant_find_text"
    case lets_create_your_profile = "lets_create_your_profile"
    case setup_mobile_pin = "setup_mobile_pin"
    case too_weak = "too_weak"
    case weak = "weak"
    case strong = "strong"
    case confirm_password = "confirm_password"
    case confirm_pin = "confirm_pin"
    case enter_your_bvn = "enter_your_bvn"
    case looks_link_you_are_new = "looks_link_you_are_new"
    case looks_link_you_are_new_text = "looks_link_you_are_new_text"
    case phone_validation = "phone_validation"
    case phone_validation_text = "phone_validation_text"
    case enter_code = "enter_code"
    case open_new_account = "open_new_account"
    case country = "country"
    case date_of_birth = "date_of_birth"
    case title = "title"
    case first_name = "first_name"
    case last_name = "last_name"
    case middle_name = "middle_name"
    case gender = "gender"
    case marital_status = "marital_status"
    case select_nationality = "select_nationality"
    
    var resourceValue: String {
        return localizedString(forResource: self)
    }
}


func localizedString(forKey key: String) -> String {
    var result = Bundle.main.localizedString(forKey: key, value: nil, table: nil)
    
    if result == key {
        result = Bundle.main.localizedString(forKey: key, value: nil, table: "Default")
    }
    
    return result
}

func localizedString(forResource key: StringResource)-> String {
    return localizedString(forKey: key.rawValue)
}
