//
//  SignUpViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: BaseViewController {

    @IBOutlet weak var formTable: DynamicFormTable!
    @IBOutlet weak var callToAction: ButtomActionButton!
    var formFields: SigUpViewModel!
    var dynamicFormViewModel = DynamicFormTableViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
             callToAction.delegate = self
             self.formTable.prepareTable()
             self.formTable.bindToViewModel(viewModel: dynamicFormViewModel)
             formFields = SigUpViewModel(viewModel: dynamicFormViewModel)
             formFields.kickOff(buttonBar: callToAction)
        // Do any additional setup after loading the view.
  
    }
    
    
    
    func signUPUser(withEmail email: String, password: String , username: String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                //self.displayErrorMessage(title: "failed to validate user", message: "\(error.localizedDescription)")
            }
             let db = Firestore.firestore()
            guard  let uid = result?.user.uid else {return}
            db.collection("users").addDocument(data: ["username":username ,"uid": uid, "password": password ]) { (error) in
                                    if error != nil {
                                        // Show error message
                                        //self.displayErrorMessage(title: "Error saving user data", message: "\(String(describing: error?.localizedDescription))")
                                        print("\(String(describing: error?.localizedDescription))")
                                        return
                                    }
                
                let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first

                guard let nvc = keyWindow?.rootViewController  as? UINavigationController else {return }
                        guard  let controller = nvc.viewControllers[0] as? HomeViewController else { return }
                        controller.configueViewComponet()
             self.dismiss(animated: true, completion: nil)
                print("successfully save user")
                                }
        }
    }
 
    
    func transitionToHome() {

        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController

        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()

    }
    
    func validateAccountNumber(request: ValidateNoBVNCreateProfileRequest){
          self.currentLoadingModal = LoadingViewController.showViewController(self, mainTitle: "Validating Account", subTitle: "please wait....")
        if let email = request.email, let password = request.password, let username = request.FullName {
             signUPUser(withEmail: email, password:password ,username: username)
        }
          DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
              self.dismissCurrentLoadingModal()
            self.transitionToHome()
          }
      }
    
}
extension SignUpViewController: ButtomButtonClickDelegate {
    func onButtonClicked(button: UIButton) {
     if let request = formFields.getRequestData() {
              validateAccountNumber(request: request)
          }
    }
}

