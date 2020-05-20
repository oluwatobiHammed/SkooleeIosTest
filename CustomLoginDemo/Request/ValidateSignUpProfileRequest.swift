//
//  ValidateSignUpProfileRequest.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import Alamofire

class ValidateNoBVNCreateProfileRequest:ParameterProvider {
    var baseParameter: Parameters = [:]
    
    var FullName: String? {
        didSet {
            // when the api is ready, you know what the actual property name will be
            self.baseParameter["username"] = FullName
        }
    }
    
    
    var email: String? {
          didSet{
              self.baseParameter["email"] = email
          }
      }
    var password: String?{
        didSet{
            self.baseParameter["password"] = password
        }
    }
    
    func provideParameter() -> Parameters {
        return self.baseParameter
    }
}
