//
//  DynamicFormDateTimeViewModel.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import RxSwift

enum DynamicFormDateTimePickerMode: String {
    case date = "date"
    case time = "time"
    case dateTime = "datetime"
}

class DynamicFormDateTimeViewModel: DynamicFormSectionRow {
    
    var disposable: Disposable?
    var datePicker: DatePickerInputGroup!
    var showPlaceholder = true {
        didSet {
            if !showPlaceholder {
                (self.widgetView as? DatePickerInputGroup)?.placeholder = ""
            }
            
        }
    }
    
    var pickerMode: DynamicFormDateTimePickerMode = .dateTime {
        didSet {
            datePicker.pickerMode = pickerMode.rawValue
            if pickerMode == .time{
                datePicker.leftIcon = "time"
            }
            if showPlaceholder {
                datePicker.placeholder = datePicker.formatDate(date: Date())
            }
            else{
                datePicker.placeholder = nil
            }
        }
    }
    
    override init() {
        super.init()
        let view = DatePickerInputGroup(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        self.datePicker = view
        view.leftIcon = "calendar"
        
        view.placeholder = view.formatDate(date: Date())
        self.rowHeight = 60
        disposable = view.onBlurObservable.subscribe(onNext: { (value) in
            self.requestNextFieldAddition()
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }
        
        if let bag = self.disposeBag {
            disposable?.disposed(by: bag)
        }
        self.widgetView = view
    }
    
    override func prepareForDisposal() {
        super.prepareForDisposal()
        self.disposable?.dispose()
        self.disposeBag = nil
    }
}

