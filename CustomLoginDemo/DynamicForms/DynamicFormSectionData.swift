//
//  DynamicFormSectionData.swift
//  FCMB-Mobile
//
//  Created by Kembene Nkem-Etoh on 4/2/18.
//  Copyright © 2018 FCMB. All rights reserved.
//

import Foundation
import RxDataSources

class DynamicFormSectionData: SectionModelType {
    var original: DynamicFormSectionData?
    var header: String?
    var items: [SectionItemData]
    var showHeader = true
    var validRequired = false
    typealias SectionItemData = DynamicFormSectionRow
    
    required init(original: DynamicFormSectionData, items: [DynamicFormSectionRow]) {
        self.original = original
        self.items = items
        self.header = original.header
        self.showHeader = original.showHeader
        self.validRequired = original.validRequired
    }
    
    init(header:String, items: [DynamicFormSectionRow], showHeader: Bool = true) {        
        self.items = items
        self.header = header
        self.showHeader = showHeader
    }
    
    func prepareForDisposal(viewModel: DynamicFormTableViewModel) {
        for item in items {
            item.prepareForDisposal()
        }
    }
    
    class func addSection(toModel: DynamicFormTableViewModel, formField: DynamicFormSectionRow, fieldName: String, headerTitle: String?, autoAdd: Bool = true, insertAfterFieldWithName: String? = nil, insertBefore: Bool = false)-> DynamicFormSectionData {
        let showHeader: Bool = headerTitle != nil
        formField.fieldName = fieldName
        let section = DynamicFormSectionData(header: "\(headerTitle ?? "")", items: [formField], showHeader: showHeader)
        if autoAdd {
            
            var addedSection = false
            
            if let insertAfterName = insertAfterFieldWithName {
                if insertBefore {
                    if let indexPath = toModel.findRowWithName(name: insertAfterName)?.indexPath {
                        var insertIndex = indexPath.section
                        if insertIndex > 0 {
                            insertIndex = insertIndex - 1
                            toModel.insertSection(afterIndex: insertIndex, section: section)
                            addedSection = true
                        }
                        else{
                            toModel.insertAtBeginningOfSection(section: section)
                            addedSection = true
                        }
                        
                    }
                }
                else {
                    if let indexPath = toModel.findRowWithName(name: insertAfterName)?.indexPath {
                        toModel.insertSection(afterIndex: indexPath.section, section: section)
                        addedSection = true
                    }
                }
            }
            if !addedSection {
                toModel.addSection(section: section)
            }
        }
        return section
    }
    
}
