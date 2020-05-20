//
//  BottomSheetViewController.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//
import UIKit
import RxSwift

class BottomSheetViewController: UIViewController, OverlayViewController, CloseableOverlayDelegate, ViewControllerPresentedDidDisappear {
    var didRemoveViewControllerSubject: PublishSubject<Any?>?
    fileprivate var overlayStatePublisher = PublishSubject<CloseableOverlayState>()
    typealias BottomSheetDisplayCallback = (UIViewController) -> Void
//    var delegate: BottomSheetCloseDelegate?
    public var navigationBarIsHidden = true;
    weak var contentView: UIView?
    var config: BottomSheetConfig?
    var viewControllerWillDisappearData: Any?
    @IBOutlet weak var contentWrapper: UIView!
    @IBOutlet weak var bottomButton: UIButton?
    @IBOutlet weak var buttonBar: UIView?
    @IBOutlet weak var iconLabel: RoundedIconButton?
    @IBOutlet weak var buttonBarHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var buttonBarBottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var contentWrapperHeightContraint: NSLayoutConstraint?
    @IBOutlet weak var totalContentContainer: UIView!
    
    @IBOutlet weak var mainButtonTwo: UIButton?
    @IBOutlet weak var subButton: UIButton?
    
    @IBOutlet weak var twoButtonContainer: UIView?
    
    var contentAnimated = false
    var contentAnimationDirection: BottomSheetConfigContentAnimationDirection? = nil
    var applyHeightConstraint = true
    
    @IBOutlet weak var mainContainerBottom: NSLayoutConstraint?
    @IBOutlet weak var mainContainerLeft: NSLayoutConstraint?
//    var subViewNimName: String?
    
    var overlayStateObservable: Observable<CloseableOverlayState> {
        return overlayStatePublisher.asObservable()
    }
    
    func closeButtonSheet() {
        self.dismissController()
    }
    
    deinit {
        print("Destroying bottom sheet")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        twoButtonContainer?.isHidden = true
        contentWrapper.backgroundColor = UIColor.white
        buttonBar?.backgroundColor = ThemeManager.currentTheme().backgroundColor
        lineBottomBar()
        var bottomContentMargin: CGFloat = 20.0
        var leadingContentMargin: CGFloat = 15
        var trailingContentMargin: CGFloat = 15
        var topContentMargin: CGFloat = 55
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        
        if let sheetConfig = self.config {
            self.applyHeightConstraint = sheetConfig.applyHeightConstraint
            bottomContentMargin = sheetConfig.bottomContentMargin
            leadingContentMargin = sheetConfig.leadingContentMargin
            trailingContentMargin = sheetConfig.trailingContentMargin
            topContentMargin = sheetConfig.topContentMargin
            
            if !sheetConfig.showCancelButton {
                buttonBarHeightConstraint?.constant = 0
                buttonBarBottomConstraint?.constant = -60
            }
            else {
                if let text = sheetConfig.cancelButtonText {
                    bottomButton?.setTitle(text, for: .normal)
                }
            }
            if sheetConfig.showTopIcon {
                if let color = sheetConfig.topOvalColor{
                    iconLabel?.circleColor = color
                }
                if let color = sheetConfig.topIconColor{
                    iconLabel?.iconColor = color
                }
                if let size = sheetConfig.iconSize{
                    iconLabel?.iconSize = size
                }
                if let icon = sheetConfig.icon {
                    iconLabel?.icon = icon
                }
            }
            else {
                iconLabel?.isHidden = true
            }
            
            if let secondButtonText = sheetConfig.secondButtonText {
                self.prepareForDualButton(buttonText: secondButtonText)
            }
            
            if sheetConfig.animateContent {
                self.contentAnimationDirection = sheetConfig.animationDirection
                switch sheetConfig.animationDirection {
                case .bottom:
                    swipeDown.direction = .down
                case .top:
                    swipeDown.direction = .up
                case .left:
                    swipeDown.direction = .left
                case .right:
                    swipeDown.direction = .right
                }
                self.prepareContentForAnimate(direction: sheetConfig.animationDirection)
            }
        }
        if let content = contentView {
            let height = content.frame.height
//            content.frame = CGRect(x: content.frame.minX, y: content.frame.minY, width: contentWrapper.frame.width, height: content.frame.height)
            content.translatesAutoresizingMaskIntoConstraints = false

            self.view.addSubview(content)
            
            
            NSLayoutConstraint(item: content, attribute: .leading, relatedBy: .equal, toItem: contentWrapper, attribute: .leading, multiplier: 1.0, constant: leadingContentMargin).isActive = true
            
            NSLayoutConstraint(item: contentWrapper, attribute: .trailing, relatedBy: .equal, toItem: content, attribute: .trailing, multiplier: 1.0, constant: trailingContentMargin).isActive = true
            
            NSLayoutConstraint(item: content, attribute: .top, relatedBy: .equal, toItem: contentWrapper, attribute: .top, multiplier: 1.0, constant: topContentMargin).isActive = true
            
            NSLayoutConstraint(item: contentWrapper, attribute: .bottom, relatedBy: .equal, toItem: content, attribute: .bottom, multiplier: 1.0, constant: bottomContentMargin).isActive = true
            
            if applyHeightConstraint {
                content.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
            }
            self.contentWrapperHeightContraint?.isActive = false
            
            if let overlay = content as? CloseableOverlayView {
                overlay.setOverlayCloseDelegate(delegate: self)
            }
        }
        self.totalContentContainer.addGestureRecognizer(swipeDown)
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                self.dismissController(slideTowards: SlideDirection.right)
            case UISwipeGestureRecognizer.Direction.down:
                dismissController(slideTowards: SlideDirection.bottom)
            case UISwipeGestureRecognizer.Direction.left:
                dismissController(slideTowards: SlideDirection.left)
            case UISwipeGestureRecognizer.Direction.up:
                dismissController(slideTowards: SlideDirection.top)
            default:
                break
            }
        }
    }
    
    /**
     Prepares this bottom sheet to have two buttons displayed at the bottom
    */
    func prepareForDualButton(buttonText: String) {
        twoButtonContainer?.isHidden = false
        bottomButton?.isHidden = true
        subButton?.setTitle(buttonText, for: UIControl.State.normal)
        
        if let sheetConfig = self.config {
            if let text = sheetConfig.cancelButtonText {
                mainButtonTwo?.setTitle(text, for: .normal)
            }
        }
        
    }
    
    func prepareContentForAnimate(direction: BottomSheetConfigContentAnimationDirection) {

        switch direction {
        case .top:
            mainContainerBottom?.constant = 0.0 - self.view.frame.height
        case .bottom:
            mainContainerBottom?.constant = self.view.frame.height
        case .left:
            mainContainerLeft?.constant = 0.0 - self.view.frame.width
        case .right:
            mainContainerLeft?.constant = self.view.frame.width
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let direction = self.contentAnimationDirection {
            if !contentAnimated {
                switch direction {
                case .top:
                    self.mainContainerBottom?.constant = 0
                case .bottom:
                    self.mainContainerBottom?.constant = 0
                case .left:
                    self.mainContainerLeft?.constant = 0
                case .right:
                    self.mainContainerLeft?.constant = 0
                }
                self.contentAnimated = true
                UIView.animate(withDuration: 0.6) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if self.isMovingFromParentViewController {
//            self.onRemovingFromParent()
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func dismissController(slideTowards: SlideDirection? = .bottom) {
        overlayStatePublisher.onNext(.willClose)
        self.removeFromFCMBParent(slideTowards: nil)
        overlayStatePublisher.onNext(.didClose)
        overlayStatePublisher.onCompleted()
        self.onRemovingFromParent()
    }
    
    func lineBottomBar() {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 15, y: 0))
        bezierPath.addLine(to: CGPoint(x: (buttonBar!.frame.width - 15) , y: 0  ))
        let lineLayer = CAShapeLayer()
        lineLayer.path = bezierPath.cgPath
        lineLayer.strokeColor = ThemeManager.currentTheme().borderColor.cgColor
        lineLayer.lineWidth = 1
        buttonBar?.layer.addSublayer(lineLayer)
    }
    
    @IBAction func onButtonClicked() {
        viewControllerWillDisappearData = true
        dismissController()
    }
    
    @IBAction func onSecondButtonClicked() {
        self.config?.secondButtPreClickedCallback?()
        dismissController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.config?.secondButtonClickedCallback?()
        }
//        self.config = nil
    }
    
    @IBAction func onIconLabelTapped() {
        viewControllerWillDisappearData = true
        dismissController()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    class func display(on: UIViewController, content: UIView, completion: ((UIViewController) -> Void)? = nil) {
        display(on: on, content: content, config: nil, completion: completion)
    }
    
    class func display(on: UIViewController, content: UIView, config: BottomSheetConfig?, completion: BottomSheetDisplayCallback? = nil) {
//        if let controller = StoryBoardsID.boardMain.get(for: .main__bottomSheet) {
//            let bottomController = controller as! BottomSheetViewController
//            bottomController.config = config
//            bottomController.contentView = content
//            on.addToParent(controller)
//            completion?(bottomController)
//        }
    }
    
    class func display(content: UIView, completion: ((UIViewController) -> Void)? = nil)->ViewControllerPresentRequest? {
        return display(content: content, config: nil, completion: completion)
    }
    
    class func display(content: UIView, config: BottomSheetConfig?, completion: BottomSheetDisplayCallback? = nil)->ViewControllerPresentRequest? {
//        if let controller = StoryBoardsID.boardMain.get(for: .main__bottomSheet) {
//            let bottomController = controller as! BottomSheetViewController
//            bottomController.config = config
//            bottomController.contentView = content
//            let request = ViewControllerPresentRequest(mode: .addToParent, viewController: bottomController)
//            ViewControllerPresenter.shared.presentViewController(request: request)
//            completion?(bottomController)
//            return request
//        }
        return nil
    }

}

