//
//  DynamicFormSegmentViewModel.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import RxSwift

//class DynamicFormSegmentViewModel: DynamicFormSectionRow {
//    
//    var disposable: Disposable?
//    var autoCollectAfterSet = true
//    var items: [RadioListDataItem] = [] {
//        didSet {
//            (widgetView as? SegmentControlInputGroup)?.segmentProvider = Observable.from(items)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                if self.autoCollectAfterSet {
//                    self.viewModel?.formController.collectValueFor(field: (self.widgetView as! SegmentControlInputGroup))
//                }
//            }
//            
//        }
//    }
//    override init() {
//        super.init()
//        let view = SegmentControlInputGroup(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
//        view.contentView?.layer.borderColor = UIColor.clear.cgColor
//        disposable = view.onBlurObservable.subscribe(onNext: { (value) in
//            self.requestNextFieldAddition()
//        }, onError: { (error) in
//            
//        }, onCompleted: {
//            
//        }, onDisposed: {
//            
//        })
//        if let bag = disposeBag {
//            disposable?.disposed(by: bag)
//        }
//        
//        self.rowHeight = 40
//        self.widgetView = view
//        
//    }
//    
//    override func prepareForDisposal() {
//        super.prepareForDisposal()
//        self.disposable?.dispose()
//    }
//}

