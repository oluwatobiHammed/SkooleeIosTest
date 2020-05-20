//
//  DynamicSimpleInputGroupViewModel.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import RxSwift

class DynamicSimpleInputGroupViewModel: DynamicFormSectionRow {
    var inputGroup: InputFieldGroup!
    var disposable: Disposable?
    override init() {
        super.init()
        inputGroup = self.createInputFieldGroup()
        
        self.rowHeight = 60
        disposable = inputGroup.onBlurObservable.subscribe(onNext: { (value) in
            self.onFieldBlurOccurred()
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }
        
        if let bag = self.disposeBag {
            disposable?.disposed(by: bag)
        }
        self.widgetView = inputGroup
    }
    
    func onFieldBlurOccurred() {
        self.requestNextFieldAddition()
    }
    
    override func prepareForDisposal() {
        super.prepareForDisposal()
        self.disposable?.dispose()
        self.disposeBag = nil
    }
    
    func createInputFieldGroup()-> InputFieldGroup {
        return InputFieldGroup(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
    }
}

