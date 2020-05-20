//
//  GlobalControllerStoryID.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class DynamicViewControllerPathResolver {
    
    static let shared = DynamicViewControllerPathResolver()
    
    fileprivate init() {
        
    }
    
    var paths: [(String, Any?)] = []
    
    func presentNextViewController() {
        if paths.count > 0 {
            let first = paths.removeFirst()
            let _ = StoryBoardsID.resolvePath(path: first.0, requestData: first.1)
        }
    }
}

enum StoryBoardsID: String {
    case boardMain = "Main"
    
    func get(for controllerId: ViewControllerID)-> UIViewController? {
        let storyboard = UIStoryboard(name:self.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: controllerId.rawValue)
    }
    
    func initialController()-> UIViewController? {
        let storyboard = UIStoryboard(name:self.rawValue, bundle: nil)
        return storyboard.instantiateInitialViewController()
    }
    
    func loadAndRoot() {
        if let controller = initialController() {
            let _ = StoryBoardsID.makeAsRoot(using: controller)
        }
    }
    
    func makeAsRoot(using: ViewControllerID)-> Bool {
        if let controller = self.get(for: using) {
            return StoryBoardsID.makeAsRoot(using: controller)
        }
        return false
    }
    
    static func makeAsRoot(using: UIViewController)-> Bool {
        if let delegate = UIApplication.shared.delegate {
            if let window = delegate.window {
                window?.rootViewController = using
                return true
            }
        }
        return false
    }
    
//    static func gotoDashboard() {
//        let _ = StoryBoardsID.boardDashboard.makeAsRoot(using: .dashboard__root)
//    }
//    
//    static func gotoLogin() {
//        let _ = StoryBoardsID.boardLogin.makeAsRoot(using: .login__getStarted)
//    }
//    
//    static func gotoDashboard(from: UIViewController) {
//        let _ = StoryBoardsID.boardDashboard.navigate(to: .dashboard__root, from: from, asRoot: true, completion: nil)
//    }
    
    func navigate(to: ViewControllerID, from: UIViewController, asRoot: Bool = false, completion: (() -> Swift.Void)? = nil)-> Bool {
        if asRoot {
            return makeAsRoot(using: to)
        }
        else {
            if let to = get(for: to) {
                if let fromNavigation = from.getNavigationViewController() {
                    fromNavigation.pushViewController(to, animated: true)
                }
                else {
                    from.present(to, animated: true, completion: completion)
                }
                return true
            }
        }
        return true
    }
    
    func requestNavigation(to: ViewControllerID, requestData: Any?, mode: ViewControllerPresentationMode = .present)-> ViewControllerPresentRequest? {
        return self.requestNavigation(to: to, from: nil, requestData: requestData, mode: mode)
    }
    
    func requestNavigation(to: ViewControllerID, from: UIViewController?, requestData: Any?, mode: ViewControllerPresentationMode = .present)-> ViewControllerPresentRequest? {
        if let controller = self.get(for: to) {
            let request = ViewControllerPresentRequest(mode: mode, viewController: controller)
            request.presenter = from
            request.requestData = requestData
            ViewControllerPresenter.shared.presentViewController(request: request)
            return request
        }
        return nil
    }
    
    func translateToPath(controllerId: ViewControllerID)-> String {
        return "\(self.rawValue).\(controllerId.rawValue)"
    }
    
    func translateWithRequestData(controllerId: ViewControllerID, data: Any?)-> (String, Any?) {
        return (self.translateToPath(controllerId: controllerId), data)
    }
    
    static func resolvePath(path: String, requestData: Any?)-> UIViewController? {
        let splits = path.components(separatedBy: ".")
        if splits.count == 2 {
            if let storyBoard = StoryBoardsID(rawValue: splits[0]) {
                if let controllerId = ViewControllerID(rawValue: splits[1]) {
                    if let request = storyBoard.requestNavigation(to: controllerId, requestData: requestData) {
                        return request.viewController
                    }
                }
            }
        }
        return nil
    }
}

enum ViewControllerID: String{
    case LoadingViewController = "LoadingViewController"
    case HomeVC = "HomeVC"
    case SignUpViewController = "SignUpViewController"
}


