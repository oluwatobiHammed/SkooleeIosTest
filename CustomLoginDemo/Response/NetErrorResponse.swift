//
//  NetErrorResponse.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import ObjectMapper

class NetError: NSObject, Mappable {
    var message: String?
    var code: Int?
    
    
    init(message: String) {
        super.init()
        self.message = message
    }
    required init?(map: Map) {
        super.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        message     <- map["message"]
        code     <- map["code"]
    }
    
}

class TranslatedNetError: Error {
    var errors: [NetError] = []
    var defaultMessage: String?
    init(errors: [NetError]) {
        self.errors = errors
    }
    
    func getMessage(defaultMessage: String?)-> String? {
        var messageText: String? = ""
        let messages = self.errors.filter { (error) -> Bool in
            return error.message != nil
            }.map { (error) -> String in
                return error.message!
        }
        if messages.count > 0 {
            messageText = messages.joined(separator: ", ")
        }
        else {
            messageText = defaultMessage ?? self.defaultMessage
        }
        return messageText
    }
}

class NetErrorResponse: NSObject, Mappable {
    var success: Bool?
    var errors: [NetError]?
    
    required init?(map: Map) {
        super.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        success     <- map["success"]
        errors     <- map["errors"]
    }
}

//class EncryptedNetErrorResponse: NSObject, Mappable  {
//
//    var netMessage: NetErrorResponse? = nil
//
//    required init?(map: Map) {
//        super.init()
//    }
//
//    // Mappable
////    func mapping(map: Map) {
////        var secretKey: String? = nil
////        var secretIV: String? = nil
////
////        secretKey       <- map["secretKey"]
////        secretIV        <- map["secretKey"]
////
////        let transformer: EncryptionResponseBodyTransformer<NetErrorResponse> = ApplicationUtility.getDecryptionTransformer(secretKey: secretKey, iv: secretIV)
////        netMessage            <- (map["body"], transformer)
////    }
//}

