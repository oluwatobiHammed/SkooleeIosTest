//
//  LoadingViewController.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class LoadingViewController: UIViewController, OverlayViewController, ViewControllerPresentedDidDisappear {
    var navigationBarIsHidden = true
    @IBOutlet weak var mainTitleLabel: UILabel?
    @IBOutlet weak var subTitleLabel: UILabel?
    @IBOutlet weak var activity: UIActivityIndicatorView?
    var mainTitle: String?
    var subTitle: String?
    var didRemoveViewControllerSubject: PublishSubject<Any?>?
    var viewControllerWillDisappearData: Any?
    
    deinit {
        print("Destroying LoadingViewController")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTitleLabel?.text = mainTitle
        subTitleLabel?.text = subTitle
        self.mainTitleLabel?.useCaptionFont(by: 3)
        subTitleLabel?.useDefaultFont(by: 1.8)
        activity?.color = ThemeManager.currentTheme().mainColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if self.isMovingFromParentViewController {
//            self.onRemovingFromParent()
//        }
    }
    
    
    func dismissController() {
        self.removeFromFCMBParent()
        self.onRemovingFromParent()
    }
    
    class func showViewController(_ parent: UIViewController, mainTitle: String? = nil, subTitle: String? = nil)-> UIViewController {
        let controller = StoryBoardsID.boardMain.get(for: .LoadingViewController)!
        if let controller = controller as? LoadingViewController {
            controller.mainTitle = mainTitle
            controller.subTitle = subTitle
        }
        parent.addToParent(controller, slideFrom: nil, duration: 0.5)
        return controller
    }
    
    class func showViewController(mainTitle: String? = nil, subTitle: String? = nil)-> ViewControllerPresentRequest {
        let controller = StoryBoardsID.boardMain.get(for: .LoadingViewController)!
        if let controller = controller as? LoadingViewController {
            controller.mainTitle = mainTitle
            controller.subTitle = subTitle
        }
        let request = ViewControllerPresentRequest(mode: .addToParent, viewController: controller)
        ViewControllerPresenter.shared.presentViewController(request: request)
        return request
    }
}

