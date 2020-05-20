//
//  BaseViewController.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//


import UIKit
import RxSwift
//import DropDown

class BaseViewController: UIViewController, ViewControllerPresentRequestDataReceiver,ViewControllerPresentedDidDisappear {

    static var displayingViewController: UIViewController?
    //var contextMenu: DropDown?
    var lastContextMenuRequest: ContextMenuRequest?
    var presentRequestData: Any?
    var didRemoveViewControllerSubject: PublishSubject<Any?>?
    var disposeBag: DisposeBag? = DisposeBag()
    var viewControllerPresenterDisposable: Disposable?
    var contactDisplayRequesterDisposable: Disposable?
    var viewControllerWillDisappearData: Any?
    //var searchBar: TopSearchBarComponent?
    var topSearchBarHeight: NSLayoutConstraint?
    var addKeyboardEventListener: Bool {
        get {
            return true
        }
    }
    
    fileprivate var searchingDisposeable: Disposable?
    fileprivate var searchBarCloseButtonDisposable: Disposable?
    fileprivate var shareDisposable: Disposable?
    
    open var searchBarPresented = false
    open var searchBarWaitTimeout = 255
    
    var currentLoadingModal: UIViewController?
    
    deinit {
        print("Disposing \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyUIChange()
        self.addTopBrandBar()
//        if canDisplayContextMenu() {
//            self.configureContextMenu()
//        }
        
        // Do any additional setup after loading the view.
    }
    
    @objc func applicationWillBecomeInactive() {
        self.dismissKeyboard(recognizer: nil, reset: true)
    }
    
//    fileprivate func addShareListener() {
//        self.shareDisposable = RxNotificationCenterRequest.shared.shareNotification.subscribe(onNext: { (data) in
//            if let objectsToShare = data {
//                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//
//                //Excluded Activities
//                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
//                //
//
//                activityVC.popoverPresentationController?.sourceView = self.view
//                self.present(activityVC, animated: true, completion: nil)
//            }
//
//        }, onError: { (error) in
//
//        }, onCompleted: {
//
//        }) {
//
//        }
//        if let bag = self.disposeBag {
//            self.shareDisposable?.disposed(by: bag)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BaseViewController.displayingViewController = self
        self.viewControllerPresenterDisposable?.dispose()
        self.contactDisplayRequesterDisposable?.dispose()
        self.viewControllerPresenterDisposable = ViewControllerPresenter.shared.presentViewControllerObserver.subscribe(onNext: { (request) in
            self.displayViewController(fromRequest: request)
        })
//        self.contactDisplayRequesterDisposable = ContactsDisplayRequester.shared.showContactsObserver.subscribe(onNext: { (viewController) in
//            viewController.modalPresentationStyle = .overCurrentContext
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.present(viewController, animated: true, completion: nil)
//            }
//
//        })
        //self.addShareListener()
        if let dispose = disposeBag {
            self.contactDisplayRequesterDisposable?.disposed(by: dispose)
            self.viewControllerPresenterDisposable?.disposed(by: dispose)
        }
        //DynamicViewControllerPathResolver.shared.presentNextViewController()
        if addKeyboardEventListener {
            self.addKeyboardOpeningEvent()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToBottomOfView(notification:)), name: DynamicFormSectionRow.SCROLL_TO_BOTTOM, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(applicationWillBecomeInactive), name: AppDelegate.ApplicationWillBecomeInactive, object: nil)
        listenToShowToastRequest()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name(rawValue: NSNotification.Name.UIKeyboardDidShow.rawValue), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: NSNotification.Name(rawValue: NSNotification.Name.UIKeyboardWillHide.rawValue), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BaseViewController.displayingViewController = nil
        //self.hideSearchBarWidget(animate: true)
        self.searchBarCloseButtonDisposable?.dispose()
        self.searchingDisposeable?.dispose()
        self.viewControllerPresenterDisposable?.dispose()
         self.contactDisplayRequesterDisposable?.dispose()
        if self.isMovingFromParentViewController {
            self.onRemovingFromParent()
            self.disposeBag = nil
        }
        if addKeyboardEventListener {
            self.removeKeyboardOpeningEvent()
        }
        resignFromShowToastRequest()
        shareDisposable?.dispose()
        NotificationCenter.default.removeObserver(self, name: DynamicFormSectionRow.SCROLL_TO_BOTTOM, object: nil)
        //NotificationCenter.default.removeObserver(self, name: AppDelegate.ApplicationWillBecomeInactive, object: nil)
    }
    
    fileprivate func listenToShowToastRequest() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveShowToastRequest(notification:)), name: ToastPresenter.NOTIF_NAME_SHOW_TOAST, object: nil)
    }
    
    fileprivate func resignFromShowToastRequest() {
        NotificationCenter.default.removeObserver(self, name: ToastPresenter.NOTIF_NAME_SHOW_TOAST, object: nil)
    }
    
    @objc fileprivate func didReceiveShowToastRequest(notification: Notification) {
        if let info = notification.userInfo{
            if let request = info["payload"] as? ToastMessageRequest {
                self.view.makeToast(request.message, duration: request.duration, position: request.position, title: request.title, image: request.image, style: request.style, completion: request.completion)
            }
        }
    }
    
    @objc fileprivate func scrollToBottomOfView(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let scrolling = self as? ScrollOnlyOnKeyboardResponderDelegate {
                if let scroller = scrolling.getScrollView() {
                    if let info = notification.userInfo, let targetView = info["view"] as? UIView {
                        var forceScrollToBottom = false
                        if let forceToBottom = info["forceScrollToBottom"] as? Bool{
                            forceScrollToBottom = forceToBottom
                        }
                        if forceScrollToBottom {
                            let point = CGPoint(x: 0, y: scroller.contentSize.height - scroller.bounds.size.height)
                            scroller.setContentOffset(point, animated: true)
                        }
                        else {
                            
//                            if let _ = targetView as? SegmentControlInputGroup {
//                                let point = CGPoint(x: 0, y: scroller.contentSize.height - scroller.bounds.size.height)
//                                scroller.setContentOffset(point, animated: true)
//                            }
//                            else if let _ = targetView as? RadioButtonsInputGroup {
//                                let point = CGPoint(x: 0, y: scroller.contentSize.height - scroller.bounds.size.height)
//                                scroller.setContentOffset(point, animated: true)
//                            }
//                            if else {
//                                let point = targetView.convert(targetView.center, to: scroller)
//                                var frame = self.view.frame
//                                frame = CGRect(x: 0, y: point.y + 180, width: frame.width, height: 60)
//                                scroller.scrollRectToVisible(frame, animated: true)
//                            }
                            
                        }
                        
                    }
                    
                }
            }
        }
        
    }
    
//    func configureSearchBar(searchBar: TopSearchBarComponent, heightComponent: NSLayoutConstraint) {
//        self.searchBar = searchBar
//        self.topSearchBarHeight = heightComponent
//
//        searchBar.waitDurationInMills = searchBarWaitTimeout
//        searchBar.addSearchBar()
//        searchBar.searchField.placeholder = self.getSearchBarPlaceholder()
//        self.hideSearchBarWidget(animate: false)
//    }
    
    func getSearchBarPlaceholder()-> String? {
        return "Search"
    }
    
    func dismissCurrentLoadingModal(completion: EmptyCallback? = nil) {
        if let controller = currentLoadingModal {
            controller.removeFromFCMBParent(slideTowards: SlideDirection.bottom, duration: 0.5, completion: completion)
        }
    }
    
//    func showSearchBarWidget() {
//        searchBarCloseButtonDisposable?.dispose()
//        searchingDisposeable?.dispose()
//        searchBar?.searchField.placeholder = self.getSearchBarPlaceholder()
//
//        searchBarCloseButtonDisposable = searchBar?.closing.subscribe(onNext: { (closed) in
//            self.hideSearchBarWidget(animate: true)
//            self.searchBar?.searchField.text = ""
//            self.searchBarPresented = false
//        }, onError: { (error) in
//
//        }, onCompleted: {
//
//        }, onDisposed: {
//
//        })
//
//        searchingDisposeable = searchBar?.searching.subscribe(onNext: { (searchText) in
//            //            self.searching = true
//            self.searchBarDidRequestSearch(searchText: searchText)
//        }, onError: { (error) in
//
//        }, onCompleted: {
//
//        }) {
//
//        }
//
//        if let bag = disposeBag {
//            searchBarCloseButtonDisposable?.disposed(by: bag)
//            searchingDisposeable?.disposed(by: bag)
//        }
//
//        if let searchHeight = self.topSearchBarHeight {
//            searchBar?.showSearchBar(viewController: self, heightConstraint: searchHeight, animate: true)
//            searchBar?.searchField.becomeFirstResponder()
//            self.searchBarPresented = true
//        }
//    }
    
//    func hideSearchBarWidget(animate: Bool = true) {
//        searchBarCloseButtonDisposable?.dispose()
//        if let searchHeight = self.topSearchBarHeight {
//            searchBar?.searchField.resignFirstResponder()
//            searchBar?.hideSearchBar(viewController: self, heightConstraint: searchHeight, animate: animate)
//        }
//    }
    
    func searchBarDidRequestSearch(searchText: String?) {
        
    }
    
//    func configureContextMenu() {
//
//        contextMenu = DropDown()
//        if let dropDown = contextMenu {
//            dropDown.direction = .bottom
//            dropDown.width = 220
//            dropDown.backgroundColor = UIColor.white
//            dropDown.cornerRadius = 4
//            dropDown.shadowColor = UIColor.black.withAlphaComponent(0.6)
//            dropDown.shadowRadius = 4
//            dropDown.shadowOpacity = 0.8
//            dropDown.selectionAction = {
//                (index, value) in
//                self.lastContextMenuRequest?.sendSelectedValue(value: value)
//                self.lastContextMenuRequest?.complete()
//            }
//            dropDown.cancelAction = {
//                self.lastContextMenuRequest?.complete()
//            }
//
//            ContextMenuProvider.shared.onShowContextMenuRequested.subscribe(onNext: { request in
//                self.lastContextMenuRequest = request
//                self.contextMenu?.dataSource = request.items
//                self.contextMenu?.anchorView = request.anchorView
//                self.contextMenu?.show()
//            }, onError: {(error) in
//
//            }, onCompleted: {
//
//            }, onDisposed: {
//
//            }).disposed(by: disposeBag!)
//
//        }
//    }
    
    func canDisplayContextMenu()-> Bool {
        return false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
