//
//  LoginViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var formTable: DynamicFormTable!
    @IBOutlet weak var callToAction: ButtomActionButton!
    @IBOutlet weak var signUpbutton: UIButton!
    var formFields: SiginViewModel!
    var dynamicFormViewModel = DynamicFormTableViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkifLoogedin()
        callToAction.delegate = self
        self.formTable.prepareTable()
        self.formTable.bindToViewModel(viewModel: dynamicFormViewModel)
        formFields = SiginViewModel(viewModel: dynamicFormViewModel)
        formFields.kickOff(buttonBar: callToAction)
        setupSignUpButton()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
         let  _ = StoryBoardsID.boardMain.requestNavigation(to: .SignUpViewController, requestData: nil)
    }
    func isLoggedin() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedin")
    }
    func checkifLoogedin () {
        if isLoggedin() {
           
        }else {
            print("User not logged in ")
        }
    }
    func loginUser(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
           
                self.displayErrorMessage(title: "failed to validate user", message: "\(error.localizedDescription)")
                return
            }
            let keyWindow = UIApplication.shared.connectedScenes
                          .filter({$0.activationState == .foregroundActive})
                          .map({$0 as? UIWindowScene})
                          .compactMap({$0})
                          .first?.windows
                          .filter({$0.isKeyWindow}).first
            guard let nvc = keyWindow?.rootViewController as? UINavigationController else {return }
            guard  let controller = nvc.viewControllers[0] as? HomeViewController else { return }
            controller.configueViewComponet()
            self.dismiss(animated: true, completion: nil)
            print("successfully save user")
        }
    }
    func validateAccountNumber(request: ValidateNoBVNCreateProfileRequest){
        self.currentLoadingModal = LoadingViewController.showViewController(self, mainTitle: "Validating Account", subTitle: "please wait....")
        if let email = request.email, let password = request.password {
            loginUser(withEmail: email, password:password)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismissCurrentLoadingModal()
            let  _ = StoryBoardsID.boardMain.requestNavigation(to: .HomeVC, requestData: nil)
            //self.transitionToHome()
        }
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    func setupSignUpButton(){
        let attributedTitle = NSMutableAttributedString(string: "Don't have an Account", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: "  Sign Up", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]))
        signUpbutton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
}

extension LoginViewController: ButtomButtonClickDelegate {
    func onButtonClicked(button: UIButton) {
        if let request = formFields.getRequestData() {
            validateAccountNumber(request: request)
        }
    }
}

