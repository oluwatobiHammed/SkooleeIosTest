//
//  DynamicFormSectionRow.swift
//  FCMB-Mobile
//
//  Created by Kembene Nkem-Etoh on 4/2/18.
//  Copyright © 2018 FCMB. All rights reserved.
//

import Foundation
import RxSwift

class DynamicFormSectionRow: NSObject {
    
    var disposeBag: DisposeBag? = DisposeBag()
    var indexPath: IndexPath?
    var observerPicked = false
    var renderObserverPicked = false
    var viewModel: DynamicFormTableViewModel?
    var enableScrollToBottom: Bool?
    var fieldGroup: InputFieldGroup?
    var otherFieldGroups: [InputFieldGroup]?
    
    static let SCROLL_TO_BOTTOM = Notification.Name("scrollToBottomOfForm")
    
    var fieldName: String? {
        didSet {
            setFieldGroupName()
        }
    }
    var widgetName: String?
    var widgetView: UIView? {
        didSet {
            setFieldGroupName()
        }
    }
    
    var isRequired: Bool{
        get {
            return getInputFieldGroup()?.validRequired ?? false
        }
        set {
            self.getInputFieldGroup()?.validRequired = newValue
        }
    }
    
    var rowHeight: CGFloat = 44
    
    var nextFieldCallable: ((_ currentField: DynamicFormSectionRow, _ viewModel: DynamicFormTableViewModel)->Void)?
    
    var heightRecomputeObserver: PublishSubject<Bool> = {
        return PublishSubject<Bool>()
    }()
    
    var reRenderSubject: PublishSubject<IndexPath?> = {
        return PublishSubject<IndexPath?>()
    }()
    
    var heightObserver: Observable<Bool>? {
        if observerPicked{
            return nil
        }
        observerPicked = true
        return self.heightRecomputeObserver.asObserver()
    }
    
    var reRenderObserver: Observable<IndexPath?>? {
        if renderObserverPicked{
            return nil
        }
        renderObserverPicked = true
        return self.reRenderSubject.asObserver()
    }
    
    fileprivate func setFieldGroupName() {
        var group: InputFieldGroup? = widgetView as? InputFieldGroup
        if group == nil {
            group = self.getInputFieldGroup()
        }
        if let widget = group {
            if let fieldname = fieldName {
                widget.fieldName = fieldname
            }
        }
    }
    
    func getEmbeddedView()-> UIView? {
        return widgetView
    }
    
    func prepare(){
        
    }
    
    func getWidgetId()-> String {
        return "\(widgetName ?? "")"
    }
    
    func getFieldName()-> String {
        return "\(fieldName ?? "")"
    }
    
    func prepareForDisposal() {
        self.widgetView = nil
        self.disposeBag = nil
        
    }
    
    func getInputFieldGroup()-> InputFieldGroup? {
        if let group = self.fieldGroup {
            return group
        }
        if let group = widgetView as? InputFieldGroup {
            return group
        }
        return __getFieldGroupForRow()
    }
    
    func __getFieldGroupForRow()-> InputFieldGroup? {
        return nil
    }
    
    func getCellHeight()-> CGFloat {
        return rowHeight
    }
    
    func requestNextFieldAddition() {
        if let callable = nextFieldCallable {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                callable(self, self.viewModel!)
                self.requestScrollToBottom()
            }            
        }
        else {
            self.requestScrollToBottom()
        }
    }
    
    func requestScrollToBottom() {
        var userInfo: [String: Any] = [:]
        if let view = self.getInputFieldGroup() {            
            userInfo["view"] = view
        }
        if let row = self.indexPath?.section {
            userInfo["forceScrollToBottom"] = row > 0
        }
        else {
            userInfo["forceScrollToBottom"] = false
        }
        if let bottomScroll = enableScrollToBottom {
            userInfo["forceScrollToBottom"] = bottomScroll
        }
        
        NotificationCenter.default.post(name: DynamicFormSectionRow.SCROLL_TO_BOTTOM, object: nil, userInfo: userInfo)
    }
    
}
