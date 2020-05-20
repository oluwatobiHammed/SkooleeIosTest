//
//  ViewControllerExtension.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import ContactsUI

/**
 This protocol is to be implemented by viewcontrollers that only want to enable scrolling when keyboard is made active
 */
protocol ScrollOnlyOnKeyboardResponderDelegate {
    func getScrollView()-> UIScrollView?
    func shouldDisableScrollingOnKeyboardDismiss()-> Bool
}
var KEYBOARD_IS_SHOWN = false
var KEYBOARD_TAP_GESTURE: UITapGestureRecognizer?
var OLD_KEYBOARD_TAP_GESTURE: UITapGestureRecognizer?

protocol OverlayViewController {
    var navigationBarIsHidden: Bool { get set }
}

@objc protocol ChildControllerRemovedDelegate {
    @objc optional func willRemoveChildController(controller: UIViewController)
    @objc optional func didRemoveChildController(controller: UIViewController)
}

enum ViewControllerPresentationMode {
    case present
    case presentForce
    case modal
    case addToParent
    case root
}

class ViewControllerPresenter {
    fileprivate var requestSubject = PublishSubject<ViewControllerPresentRequest>()
    
    static let shared = ViewControllerPresenter()
    
    var presentViewControllerObserver: Observable<ViewControllerPresentRequest> {
        return requestSubject.asObserver()
    }
    
    fileprivate init() {}
    
    func presentViewController(request: ViewControllerPresentRequest) {
        if let presenter = request.presenter {
            presenter.displayViewController(fromRequest: request)
        }
        else {
            self.requestSubject.onNext(request)
        }
    }
}

protocol ViewControllerPresentRequestDataReceiver {
    var presentRequestData: Any? {get set}
}

protocol ViewControllerPresentedDidDisappear {
    var viewControllerWillDisappearData: Any? {get set}
    var didRemoveViewControllerSubject: PublishSubject<Any?>? {get set}
}

class ViewControllerPresentRequest {
    var mode: ViewControllerPresentationMode
    var viewController: UIViewController
    var presenter: UIViewController?
    var requestData: Any?
    fileprivate var didPresentSubject = BehaviorSubject<Bool>(value: false)
    fileprivate var didRemoveSubject = PublishSubject<Any?>()
    
    var didPresent: Observable<Bool> {
        return didPresentSubject.asObservable()
    }
    
    var didRemove: Observable<Any?> {
        return didRemoveSubject.asObservable()
    }
    
    init(mode: ViewControllerPresentationMode, viewController: UIViewController) {
        self.mode = mode
        self.viewController = viewController
    }
    
    deinit {
        print("Destroying ViewControllerPresentRequest")
    }
    
}

enum SlideDirection {
    case left
    case right
    case top
    case bottom
}

@objc protocol ViewControllerKeyboardOpeningDelegate {
    @objc optional func keyboardDidOpen()
    @objc optional func keyboardDidClose()
    
    @objc optional func keyboardWillOpen()
    @objc optional func keyboardWillClose()
}

protocol OnScreenKeyboardOffsetProvider {
    func offsetScreenOnKeyboardBy()-> CGFloat?
}

extension UIViewController {
    
    func applyUIChange() {
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        self.getNavigationViewController()?.navigationBar.shadowImage = UIImage()
        // we don't want the title label to display.
        navigationItem.titleView = UILabel()
    }
    
    func getNavigationViewController()-> UINavigationController? {
        if let navController = self.parent as? UINavigationController {
            return navController
        }
        return nil
    }
    
    func addTopBrandBar() {
        let barView = UIView(frame: .zero)
        barView.backgroundColor = ThemeManager.currentTheme().accentColor
        self.view.addSubview(barView)
        barView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            barView.heightAnchor.constraint(equalToConstant: 3),
            barView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            barView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        ])
    }
    
//    func showForgotPasswordController() {
//        // todo provide a parameter that will specify where the application will be navigated to after completion
//        let _ = StoryBoardsID.boardLogin.navigate(to: .login__forgotPassword, from: self)
//    }
    
    func showErrorAsToastMessage(error: Error, defaultMessage: String?, duration: Double = 15) {
        let request = ToastMessageRequest.instance()
        request.duration = duration
        var showToast = false
        if let theError = error as? TranslatedNetError {
            request.message = theError.getMessage(defaultMessage: defaultMessage)
            showToast = true
        }
        else if let theMessage = defaultMessage {
            request.message = theMessage
            showToast = true
        }
        if showToast {
            request.present()
        }
    }
    
    static func getErrorMessagesFromError(error: Error, defaultMessage: String?, showLocalizedMessage: Bool = true)-> String? {
        if let errorT = error as? TranslatedNetError {
            return errorT.getMessage(defaultMessage: defaultMessage)
        }
        if showLocalizedMessage{
            return (defaultMessage ?? "") + " (\(error.localizedDescription))"
        }
        return nil
        
    }
    
    func showTransactioErrorMessage(error: Error, title: String?, defaultMessage: String?, showLocalizedMessage: Bool = true, completion: EmptyCallback? = nil) {
        let message: String? = UIViewController.getErrorMessagesFromError(error: error, defaultMessage: defaultMessage, showLocalizedMessage: showLocalizedMessage) ?? defaultMessage
        self.displayErrorMessage(title: title ?? "", message: message, completion: completion)
    }
    
    func displayErrorMessage( title: String?, message: String?, completion: EmptyCallback? = nil) {
        StatusMessagesPresenter.errorMessage(title: title ?? "", message: message!).present(buttonText: "Ok", completion: completion)
    }
    
    func displayErrorMessage( title: String?, message: NSAttributedString?, completion: EmptyCallback? = nil) {
        StatusMessagesPresenter.errorMessage(title: title ?? "", message: message!).present(buttonText: "Ok", completion: completion)
    }
    
    func displaySuccessMessage( title: String?, message: String?, completion: EmptyCallback? = nil) {
        StatusMessagesPresenter.successMessage(title: title ?? "", message: message!).present(buttonText: "Ok", completion: completion)
    }
    
    func displaySuccessMessage( title: String?, message: NSAttributedString, completion: EmptyCallback? = nil) {
        StatusMessagesPresenter.successMessage(title: title ?? "", message: message).present(buttonText: "Ok", completion: completion)
    }
    
    func displayWarningMessage( title: String?, message: String?, buttonText: String = "Ok", completion: EmptyCallback? = nil) {
        StatusMessagesPresenter
            .successMessage(title: title ?? "", message: message ?? "")
            .configure { (bottomButton, header) in
                bottomButton.icon = FontIcon.info
                bottomButton.iconSize = 30
                bottomButton.topOvalColor = ThemeManager.currentTheme().accentColor
        }.present(buttonText: buttonText, completion: completion)
    }
    
    func addKeyboardOpeningEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name(rawValue: NSNotification.Name.UIKeyboardDidShow.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name(rawValue: NSNotification.Name.UIKeyboardWillHide.rawValue), object: nil)
    }
    
    func removeKeyboardOpeningEvent() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NSNotification.Name.UIKeyboardDidShow.rawValue), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NSNotification.Name.UIKeyboardWillHide.rawValue), object: nil)
    }
    
    func displayViewController(fromRequest: ViewControllerPresentRequest) {
        
        if var disappearSubject = fromRequest.viewController as? ViewControllerPresentedDidDisappear {
            disappearSubject.didRemoveViewControllerSubject = fromRequest.didRemoveSubject
        }
        
        if var requestSetter = fromRequest.viewController as? ViewControllerPresentRequestDataReceiver {
            requestSetter.presentRequestData = fromRequest.requestData
        }
        switch fromRequest.mode {
        case .modal:
            fromRequest.viewController.modalPresentationStyle = .overCurrentContext
            self.present(fromRequest.viewController, animated: true) {
                fromRequest.didPresentSubject.onNext(true)
//                fromRequest.didPresentSubject.onCompleted()
            }
        case .presentForce:
            self.present(fromRequest.viewController, animated: true){
                fromRequest.didPresentSubject.onNext(true)
//                fromRequest.didPresentSubject.onCompleted()
            }
        case .present:
            if let navController = self.navigationController {
                navController.pushViewController(fromRequest.viewController, animated: true)
                fromRequest.didPresentSubject.onNext(true)
//                fromRequest.didPresentSubject.onCompleted()
            }
            else{
                self.present(fromRequest.viewController, animated: true) {
                    fromRequest.didPresentSubject.onNext(true)
//                    fromRequest.didPresentSubject.onCompleted()
                }
            }
        case .root:
           // let _ = StoryBoardsID.makeAsRoot(using: fromRequest.viewController)
            fromRequest.didPresentSubject.onNext(true)
//            fromRequest.didPresentSubject.onCompleted()
        case .addToParent:
            self.addToParent(fromRequest.viewController)
            fromRequest.didPresentSubject.onNext(true)
//            fromRequest.didPresentSubject.onCompleted()
        }
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        
        if let presented = self.presentedViewController {
            if type(of: presented) == CNContactPickerViewController.self {
                return
            }
        }
        
        KEYBOARD_IS_SHOWN = true
        
        if KEYBOARD_TAP_GESTURE == nil {
            KEYBOARD_TAP_GESTURE = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(recognizer:reset:)))
            self.view.addGestureRecognizer(KEYBOARD_TAP_GESTURE!)
        }
        
        if let notifyer = self as? ViewControllerKeyboardOpeningDelegate {
            notifyer.keyboardWillOpen?()
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            //OnScreenKeyboardOffsetProvider
            var height = keyboardSize.height
            if let provider = self as? OnScreenKeyboardOffsetProvider, let providerHeight = provider.offsetScreenOnKeyboardBy() {
                height = providerHeight
            }
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - height)
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let scrolling = self as? ScrollOnlyOnKeyboardResponderDelegate {
                if let scroller = scrolling.getScrollView() {
                    scroller.isScrollEnabled = true
                    if let responder = UIResponder.currentFirstResponder {
                        if let view = responder as? UIView {
                            let scrollPosition = view.convert(view.center, to: scroller)
                            let rect = CGRect(x: scrollPosition.x, y: scrollPosition.y, width: view.frame.width, height: view.frame.height)
                            scroller.scrollRectToVisible(rect, animated: true)
                        }
                    }
                }
            }
        }
        
        if let notifyer = self as? ViewControllerKeyboardOpeningDelegate {
            notifyer.keyboardDidOpen?()
        }
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        
        if let presented = self.presentedViewController {
            if type(of: presented) == CNContactPickerViewController.self {
                return
            }
        }
        KEYBOARD_IS_SHOWN = false
        if let rec = KEYBOARD_TAP_GESTURE {
            self.view.removeGestureRecognizer(rec)
            KEYBOARD_TAP_GESTURE = nil
        }
        if let notifyer = self as? ViewControllerKeyboardOpeningDelegate {
            notifyer.keyboardWillClose?()
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            var height = keyboardSize.height
            if let provider = self as? OnScreenKeyboardOffsetProvider, let providerHeight = provider.offsetScreenOnKeyboardBy() {
                height = providerHeight
            }
            
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + height)
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
        if let scrolling = self as? ScrollOnlyOnKeyboardResponderDelegate {
            if let scroller = scrolling.getScrollView() {
                
                if scrolling.shouldDisableScrollingOnKeyboardDismiss() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        scroller.scrollRectToVisible(CGRect(x: 0, y:0, width:10, height: 10), animated: true)
                        scroller.isScrollEnabled = false
                    }
                }
                
            }
        }
        if let notifyer = self as? ViewControllerKeyboardOpeningDelegate {
            notifyer.keyboardDidClose?()
        }
    }
    
    func hideKeyboardWhenTappedAround(){
    }
    
    func hideKeyboardWhenTappedAroundView(){
//                let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(recognizer:)))
//                self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(recognizer: UITapGestureRecognizer? = nil, reset: Bool = false){
        if KEYBOARD_IS_SHOWN {
            view.endEditing(true)
            if reset {
                KEYBOARD_IS_SHOWN = false
            }
        }
    }
    
    func addToParent(_ child: UIViewController, slideFrom: SlideDirection? = nil, duration: TimeInterval = 0.5, completion: EmptyCallback? = nil) {
        // ensure keyboard is dismissed
        self.dismissKeyboard()
        
    
        var navigationBar: UINavigationBar? = nil
        if var buttonSheetController = child as? OverlayViewController {
            if let navControl = self.getNavigationViewController() {
                navigationBar = navControl.navigationBar
                buttonSheetController.navigationBarIsHidden = true
            }
        }
        
        let childView = child.view
        
        if let slideFrom = slideFrom {
            switch slideFrom {
            case .top:
                childView?.frame.origin.y = 0.0 - self.view.frame.height
            case .bottom:
                childView?.frame.origin.y = self.view.frame.height
            case .left:
                childView?.frame.origin.x = 0.0 - self.view.frame.width
            case .right:
                childView?.frame.origin.x = self.view.frame.width
            }
        }
        else {
            childView?.alpha = 0
        }
        
        addChildViewController(child)
        self.view.addSubview(child.view)
        
        
        UIView.animate(withDuration: duration, animations: {
            if let slideFrom = slideFrom {
                switch slideFrom {
                case .top:
                    childView?.frame.origin.y = 0
                case .bottom:
                    childView?.frame.origin.y = 0
                case .left:
                    childView?.frame.origin.x = 0
                case .right:
                    childView?.frame.origin.x = 0
                }
            }
            else {
                childView?.alpha = 1
            }
        }){ (completed: Bool) in
            child.didMove(toParentViewController: self)
            if let completion = completion {
                completion()
            }
        }
        
        UIView.animate(withDuration: duration + 0.3, animations: {
            if let navBar = navigationBar {
//                navBar.alpha = 0
            }
        }) {
            (completed: Bool) in
            if completed {
                if let navBar = navigationBar {
                    navBar.isHidden = true
                }
            }
        }
        
    }
    
    func removeFromFCMBParent(slideTowards: SlideDirection? = .bottom, duration: TimeInterval = 0.5, completion: EmptyCallback? = nil) {
        guard parent != nil else {
            return
        }
        
        let parentView = parent!.view!
        var navigationBar: UINavigationBar? = nil
        if let buttonSheetController = self as? OverlayViewController {
            if let navControl = self.parent!.getNavigationViewController() {
                if buttonSheetController.navigationBarIsHidden {
                    navigationBar = navControl.navigationBar
                }
            }
        }
        
        willMove(toParentViewController: nil)
        
        if let navBar = navigationBar {
            navBar.isHidden = false
//            navBar.alpha = 1
        }
        let parentController = self.parent as? ChildControllerRemovedDelegate
        if let parent = parentController {
            parent.willRemoveChildController?(controller: self)
        }
        UIView.animate(withDuration: 1, animations: {
            
            if let slideTowards = slideTowards {
                switch slideTowards {
                case .top:
                    self.view.frame.origin.y = 0.0 - parentView.frame.height
                case .bottom:
                    self.view.frame.origin.y = parentView.frame.height
                case .left:
                    self.view.frame.origin.x = 0.0 - parentView.frame.width
                case .right:
                    self.view.frame.origin.x = parentView.frame.width
                }
            }
            else {
                self.view.alpha = 0
            }
            
        }){ (completed: Bool) in
            
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
            if let parent = parentController {
                parent.didRemoveChildController?(controller: self)
            }
            
            UIView.animate(withDuration: duration, animations: {
                if let navBar = navigationBar {
//                    navBar.alpha = 1
                }
            }){
                (completed: Bool) in
                if completion != nil {
                    completion!()
                }
            }
            
        }
    }
    
    func popBackViewControllers(_ stepsBack: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < stepsBack else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - stepsBack], animated: true)
                return
            }
        }
    }
    
    func onRemovingFromParent() {
        if var invoker = self as? ViewControllerPresentedDidDisappear {
            invoker.didRemoveViewControllerSubject?.onNext(invoker.viewControllerWillDisappearData)
            invoker.didRemoveViewControllerSubject?.onCompleted()
            invoker.didRemoveViewControllerSubject = nil
        }
    }
}


extension UINavigationController {
    func popViewControllerItem(animated: Bool = true, completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
}
