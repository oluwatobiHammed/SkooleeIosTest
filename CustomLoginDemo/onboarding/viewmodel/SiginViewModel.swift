//
//  SiginUpViewModel.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 20/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SiginViewModel: BaseViewModelPopulator {
    
    var usernameValidation: Disposable?
    var usernameInput: InputFieldGroup?
  
    let FIELD_EMAIL = "email"
    let FIELD_PASSWORD = "password"
    var passwordProgress: UIProgressView!
    
    
    override func addFirstField() {
        self.addEmail()
        self.addPassword()
    }


    func addEmail() {
          let row = self.addTextField(fieldName: FIELD_EMAIL, placeholder: "Email", header: "", required: true)
        row.getInputFieldGroup()?.keyboardTypeValue = .email
        row.getInputFieldGroup()?.removeLeftIconSpace = true
        row.getInputFieldGroup()?.validEmail = true
      }
    func addPassword() {
          let row = self.addTextField(fieldName: FIELD_PASSWORD, placeholder: "Signup Password", header: "", required: true)
        row.getInputFieldGroup()?.keyboardType = "password"
        row.getInputFieldGroup()?.removeLeftIconSpace = true
        row.getInputFieldGroup()?.passwordVisibility = true
    }
   
    
    func getRequestData()-> ValidateNoBVNCreateProfileRequest? {
         if self.viewModel.validateAndSave() {
             let request = ValidateNoBVNCreateProfileRequest()
            request.email = self.getFieldValueAsString(fieldName: FIELD_EMAIL)
            request.password = self.getFieldValueAsString(fieldName: FIELD_PASSWORD)
            return request
         }
         return nil
     }
    
}
