//
//  DynamicFormViewModel.swift
//  FCMB-Mobile
//
//  Created by Kembene Nkem-Etoh on 4/2/18.
//  Copyright © 2018 FCMB. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class DynamicFormTableViewModel: NSObject {
    
    fileprivate var currentSections: [DynamicFormSectionData] = []
    fileprivate var sectionsSubject: BehaviorRelay<[DynamicFormSectionData]>!
    var formController: InputFieldGroupFormController = InputFieldGroupFormController(parentView: nil)
    var forceShowError = true
    
    fileprivate var boundView: UIView?

    
    var sections: Observable<[DynamicFormSectionData]> {
        return sectionsSubject.asObservable()
    }
    
    var sectionsCount: Int {
        return self.currentSections.count
    }
    
    override init() {
        super.init()
        sectionsSubject = BehaviorRelay(value: currentSections)
    }
    
    func bindToView(view: UIView) {
        self.boundView = view
        formController.view = view
    }
    
    func hasSectionWidgetWithId(widgetId: String)-> Bool {
        for section in currentSections {
            for item in section.items {
                if item.getWidgetId() == widgetId {
                    return true
                }
            }
        }
        return false
    }
    
    func hasSectionWidgetWithName(name: String)-> Bool {
        for section in currentSections {
            for item in section.items {
                if item.getFieldName() == name {
                    return true
                }
            }
        }
        return false
    }
    
    func findRowWithName(name: String)-> DynamicFormSectionRow? {
        for section in currentSections {
            for item in section.items {
                if item.getFieldName() == name {
                    return item
                }
            }
        }
        return nil
    }
    
    func findRowWithWidgetId(widgetId: String)-> DynamicFormSectionRow? {
        for section in currentSections {
            for item in section.items {
                if item.getWidgetId() == widgetId {
                    return item
                }
            }
        }
        return nil
    }
    
    func getSectionForItem(item: DynamicFormSectionRow)-> DynamicFormSectionData? {
        if let indexPath = item.indexPath {
            if indexPath.section < self.currentSections.count {
                return self.currentSections[indexPath.section]
            }
        }
        return nil
    }
    
    func getSectionWithIndex(sectionRow: Int)-> DynamicFormSectionData? {
        if sectionRow < self.currentSections.count {
            return self.currentSections[sectionRow]
        }
        return nil
    }
    
    func setSections(sections: [DynamicFormSectionData]) {
        self.currentSections.removeAll()
        
        for section in sections {
            for item in section.items {
                item.viewModel = self
                item.prepare()
            }
            self.currentSections.append(section)
            self.addSectionToViewController(section: section)
        }
        self.sectionsSubject.accept(self.currentSections)
        
    }
    
    func findAllSectionsAfter(index: Int)->[DynamicFormSectionData] {
        var count = 0
        var sectionsFound: [DynamicFormSectionData] = []
        for section in self.currentSections {
            if count > index {
                sectionsFound.append(section)
            }
            count += 1
        }
        return sectionsFound
    }
    
    func removeSectionAfterIndex(index: Int) {
        var count = 0
        var newIdexes: [DynamicFormSectionData] = []
        var removeIndexes: [DynamicFormSectionData] = []
        for section in self.currentSections {
            if count < self.currentSections.count && count <= index {
                newIdexes.append(section)
            }
            else {
                removeIndexes.append(section)
            }
            count += 1
        }
        self.currentSections = newIdexes
        for removeSection in removeIndexes {
            self.removeSectionFromFormController(section: removeSection)
            removeSection.prepareForDisposal(viewModel: self)
        }
        self.sectionsSubject.accept(self.currentSections)
    }
    
    func removeAllSections() {        
        for section in currentSections {
            self.removeSectionFromFormController(section: section)
            section.prepareForDisposal(viewModel: self)
        }
        currentSections = []
        self.sectionsSubject.accept(self.currentSections)
    }
    
    func removeSection(sectionIndex: Int) {
        let removedSection = self.currentSections.remove(at: sectionIndex)
        self.removeSectionFromFormController(section: removedSection)
        removedSection.prepareForDisposal(viewModel: self)
        self.sectionsSubject.accept(self.currentSections)
    }
    
    func addSection(section: DynamicFormSectionData) {
        self.currentSections.append(section)
        for item in section.items {
            item.viewModel = self
            item.prepare()
        }
        self.sectionsSubject.accept(self.currentSections)
        self.addSectionToViewController(section: section)
    }
    
    func insertAtBeginningOfSection(section: DynamicFormSectionData) {
        currentSections.insert(section, at: 0)
        for item in section.items {
            item.viewModel = self
            item.prepare()
        }
        self.sectionsSubject.accept(self.currentSections)
        self.addSectionToViewController(section: section)
    }
    
    func insertSection(afterIndex: Int, section: DynamicFormSectionData) {
        let nextPosition = afterIndex + 1
        if nextPosition < currentSections.count {
            currentSections.insert(section, at: nextPosition)
        }
        else {
            currentSections.append(section)
        }
        for item in section.items {
            item.viewModel = self
            item.prepare()
        }
        self.sectionsSubject.accept(self.currentSections)
        self.addSectionToViewController(section: section)
    }
    
    func validateAndSave()-> Bool {
        return formController.collectFieldValueAfterDone()
    }
    
    fileprivate func removeSectionFromFormController(section: DynamicFormSectionData) {
        for row in section.items {
            if let inputGroup = row.getInputFieldGroup() {
                formController.removeFieldGroup(inputField: inputGroup)
            }
        }
        let _ = formController.checkFieldsValidity()
    }
    
    fileprivate func addSectionToViewController(section: DynamicFormSectionData) {
        var required = false
        for row in section.items {
            if let inputGroup = row.getInputFieldGroup() {
                formController.addInputFieldGroup(fieldGroup: inputGroup)
                // when we add an item to the view, we silent errors from being shown
                let _ = formController.checkFieldsValidity(field: inputGroup, forceShowError: false)
            }
            else {
                if let view = row.widgetView {
                    formController.addInputGroupsFromView(view: view)
                }
            }
            if row.isRequired {
                required = true
            }
        }
        section.validRequired = required
    }
}
