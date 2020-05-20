//
//  FormValidators.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa


typealias EmptyCallback = () -> Void

enum Validators {
    case required
    case email
    
    func instance(config: Any?)-> Validator {
        switch self {
        case .required:
            return RequiredValidator()
        case .email:
            return EmailValidator()
        }
    }
}

class Validator: NSObject {
    var enabled = true
    var identifier: String {
        get {
            return "\(self)"
        }
    }
    func validateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?)-> String? {
        return nil
    }
}

class AsyncValidator: Validator {
    var resultIsAvaliable = false
    // defaults to waiting for a maximum of to seconds
    var maximumTimeout: TimeInterval = 10000
    var lastErrorMessage: String?
    
    override func validateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?)-> String? {
        self.resultIsAvaliable = false
        self.lastErrorMessage = nil
        
        let group = DispatchGroup()
        group.enter()
        
        self.doValidateAgainst(testValue, groupDelegate: groupDelegate) { (error) in
            self.lastErrorMessage = error
            self.resultIsAvaliable = true
            group.leave()
        }
        
        let _ = group.wait(timeout: DispatchTime.now() + 10)
        
        return lastErrorMessage
    }
    
    func doValidateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?, callback: @escaping ((_ message: String?)->Void)) {
        callback(nil)
    }
    
    
}

class EmailValidator: Validator {
    fileprivate static let instance = EmailValidator()
    override func validateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?)-> String? {
        if testValue == nil {
            return nil
        }
        if let value = testValue as? String{
            if value.isEmpty {
                return nil
            }
            if value.isValidEmail() {
                return nil
            }
        }
        return "Enter a valid email address"
    }
}

class RequiredValidator: Validator {
    fileprivate static let instance = RequiredValidator()
    override func validateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?)-> String? {
        if let value = testValue {
            if let valueString = value as? String {
                if valueString.count > 0 {
                    return nil
                }
                return "This field is required"
            }
            return nil
        }
        return "This field is required"
    }
}

class MinLengthValidator: Validator {
    var number: Int!
    var message: String!
    init(number: Int = 0, message: String = "A minimum of :number characters required") {
        self.number = number
        self.message = message
    }
    
    override func validateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?)-> String? {
        if let value = testValue as? String{
            if value.count >= number {
                return nil
            }
        }
        return getErrorMessage()
    }
    
    func getErrorMessage()-> String {
        return self.message.replacingOccurrences(of: ":number", with: "\(self.number ?? 0)")
    }
}

class ConfirmUsernameAsyncValidator: AsyncValidator {
    var inputField: InputFieldGroup?
    var oldUsername: String?
    var oldUserNameIsValid = false
    var disposeable: Disposable?
    init(inputField: InputFieldGroup?) {
        self.inputField = inputField
       
    }
    
    override func doValidateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?, callback: @escaping ((_ message: String?)->Void)){
        if let value = testValue as? String{
            if (oldUsername != value || !oldUserNameIsValid) && value.count > 0{
                self.validateUsername(username: value, callback: callback)
                return
            }
        }
        callback(nil)
    }
    
    func validateUsername(username: String, callback: @escaping ((_ message: String?)->Void)) {
        disposeable?.dispose()
        oldUserNameIsValid = false
        inputField?.showProgressIndicator(show: true)
        self.oldUsername = username
//        disposeable = OnBoardingDatasource.shared.hasUsername(username: username, accountType: accountType).subscribe(onNext: { (success) in
//            self.inputField?.showProgressIndicator(show: false)
//            if success {
//                self.oldUserNameIsValid = true
//                callback(nil)
//            }
//            else {
//                callback("Username is already taken.")
//            }
//        }, onError: { (error) in
//            self.inputField?.showProgressIndicator(show: false)
//            let message = UIViewController.getErrorMessagesFromError(error: error, defaultMessage: "username check failure") ?? "username check failure"
//            callback(message)
//        }, onCompleted: {
//
//        }) {
            
       // }
    }
}

class MaxLengthValidator: Validator {
    var number: Int!
    var message: String!
    init(number: Int = 0, message: String = "A maximum of :number characters required") {
        self.number = number
        self.message = message
    }
    
    override func validateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?)-> String? {
        if let value = testValue as? String{
            if value.count <= number {
                return nil
            }
        }
        return getErrorMessage()
    }
    
    func getErrorMessage()-> String {
        return self.message.replacingOccurrences(of: ":number", with: "\(self.number ?? 0)")
    }
}

class MinIntegerValidator: Validator {
    var number: Int!
    var message: String!
    init(number: Int = 0, message: String = "Minumum value is :number") {
        self.number = number
        self.message = message
    }
    
    override func validateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?)-> String? {
        var doubleValue: Double? = nil
        if let v = testValue as? Int {
            doubleValue = Double(v)
        }
        else if let v = testValue as? String {
            doubleValue = Double(v)
        }
        
        if let value = doubleValue{
            let numberDouble = Double(number)
            if value >= numberDouble {
                return nil
            }
        }
        return getErrorMessage()
    }
    
    func getErrorMessage()-> String {
        return self.message.replacingOccurrences(of: ":number", with: "\(self.number ?? 0)")
    }
}

class MaxIntegerValidator: Validator {
    var number: Int!
    var message: String!
    init(number: Int = 0, message: String = "Maximum value is :number") {
        self.number = number
        self.message = message
    }
    
    override func validateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?)-> String? {
        var intValue: Int? = nil
        if let v = testValue as? Int {
            intValue = v
        }
        else if let v = testValue as? String {
            intValue = Int(v)
        }
        
        if let value = intValue{
            if value <= number {
                return nil
            }
        }
        return getErrorMessage()
    }
    
    func getErrorMessage()-> String {
        return self.message.replacingOccurrences(of: ":number", with: String(describing: self.number))
    }
}

class ExactLengthValidator: Validator {
    var number: Int!
    var otherNumber: Int?
    var message: String!
    init(number: Int = 0, message: String = "Must contain exactly :number :other characters") {
        self.number = number
        self.message = message
    }
    
    override func validateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?)-> String? {
        if let value = testValue as? String{
            if let other = otherNumber {
                if value.count == number || value.count == other{
                    return nil
                }
            }
            else{
                if value.count == number {
                    return nil
                }
            }
        }
        return getErrorMessage()
    }
    
    func getErrorMessage()-> String {
        let length = self.number ?? 1
        var otherMessage = ""
        if let num = otherNumber {
            otherMessage = " or \(num) "
        }
        return self.message.replacingOccurrences(of: ":number", with: "\(length)").replacingOccurrences(of: ":other", with: "\(otherMessage)")
    }
}

class FieldsValueComparisonValidator: Validator {
    fileprivate let defaultMessage = "Values do not match"
    var fieldNames: [String]!
    var errorMessages: [String] = []
    init(compareFieldNames: [String] = [], errorMessages: [String] = []) {
        self.fieldNames = compareFieldNames
        self.errorMessages = errorMessages
    }
    override func validateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?)-> String? {
        var errorMessage: String? = nil
        if let delegate = groupDelegate {
            var index = 0
            for fieldName in fieldNames {
                let getValue = delegate.getFieldValue?(fieldName: fieldName)
                if let equal = getValue?.isEqual(testValue) {
                    if !equal {
                        if index < errorMessages.count {
                            errorMessage = errorMessages[index]
                            break
                        }
                        else {
                            errorMessage = defaultMessage
                            break
                        }
                    }
                }
                index += 1
            }
            
            
        } else {
            errorMessage = defaultMessage
        }
        return errorMessage
    }
}


class UsernameValidValidator: Validator {
    var message: String!
    var validUsername: String?
    init(message: String = "Username \":username\" already exists") {
        self.message = message
    }
    
    override func validateAgainst(_ testValue: AnyObject?, groupDelegate: InputFieldGroupDelegate?)-> String? {
        if let value = testValue as? String{
            if let valid = self.validUsername {
                if valid == value {
                    return nil
                }
            }
        }
        return getErrorMessage(failedUsername: "\(testValue as? String ?? "")")
    }
    
    func getErrorMessage(failedUsername: String)-> String {
        return self.message.replacingOccurrences(of: ":username", with: String(describing: failedUsername))
    }
}

