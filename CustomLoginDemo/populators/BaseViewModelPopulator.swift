//
//  BaseViewModelPopulator.swift
//  FCMB-Mobile
//
//  Created by Kembene Nkem-Etoh on 4/19/18.
//  Copyright © 2018 FCMB. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModelPopulator: NSObject {
    
    let FIELD_NAME_RECURRING_TYPE = "recurring"
    let FIELD_NAME_RECURRING_START_DATE = "recurringStartDate"
    let FIELD_NAME_RECURRING_END_DATE = "recurringEndDate"
    let FIELD_NAME_RECURRING_TRANSFER_TIME = "recurringTransferTime"
    let FIELD_NAME_RECURRING_FREQUENCY = "recurringFrequency"
    let FIELD_NAME_RECURRING_FREQUENCY_NUMBER_OF_DAYS = "recurringFrequencyNumberOfDays"
    
    var viewModel = DynamicFormTableViewModel()
    var disposeBag: DisposeBag? = DisposeBag()
    var buttonBar: ButtomActionButton?
    
    init(viewModel: DynamicFormTableViewModel? = nil) {
        if let model = viewModel {
            self.viewModel = model
        }
    }
    
    func bindToViewModel(viewModel: DynamicFormTableViewModel, removeSections: Bool = true) {
        // clear the current form before reassigning the view model
        self.removeAllSections()
        self.viewModel = viewModel
        if removeSections {
            self.removeAllSections()
        }
    }
    
    func kickOff(buttonBar: ButtomActionButton?) {
        if let bar = buttonBar {            
            viewModel.formController.bind(bottomAction: bar, validateOnBlur: true)
        }
        self.buttonBar = buttonBar
        self.addFirstField()
    }
    
    func addFirstField() {
        
    }
    
    func hasField(withName fieldName: String)-> Bool {
        return viewModel.hasSectionWidgetWithName(name: fieldName)
    }
    
    func hasField(withId fieldId: String)-> Bool {
        return viewModel.hasSectionWidgetWithId(widgetId: fieldId)
    }
    
    func createAndAddSectionHeader(title: String, header: String? = "")-> BrandLabel? {
        let row = DynamicFormSectionRow()
        let label = BrandLabel(frame: CGRect.zero)
        label.text = title
        label.numberOfLines = 0
        //label.usingFont(of: .Medium, sizeBy: 2)
        row.widgetView = label
        let fieldName = title.lowercased().replacingOccurrences(of: " ", with: "_")
        let _ = DynamicFormSectionData.addSection(toModel: self.viewModel, formField: row, fieldName: fieldName, headerTitle: header)
        return label
    }
    
    func createAndAddSection(forView: UIView, fieldName: String, header: String? = nil, rowHeight: CGFloat = 60, inputField: InputFieldGroup? = nil, insertAfterFieldWithName: String? = nil, insertBefore: Bool = false)-> DynamicFormSectionRow? {
        let row = DynamicFormSectionRow()
        row.widgetView = forView
        row.rowHeight = rowHeight
        row.fieldGroup = inputField
        let _ = DynamicFormSectionData.addSection(toModel: self.viewModel, formField: row, fieldName: fieldName, headerTitle: header, insertAfterFieldWithName: insertAfterFieldWithName, insertBefore: insertBefore)
        return row
    }
    
    func createAndAddSectionHeader(title: NSAttributedString, header: String? = "", rowHeight: CGFloat? = nil, fieldName: String? = nil, widgetId: String? = nil)-> BrandLabel? {
        let row = DynamicFormSectionRow()
        row.widgetName = widgetId
        let label = BrandLabel(frame: CGRect.zero)
        label.attributedText = title
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
//        label.usingFont(of: .Medium, sizeBy: 2)
        row.widgetView = label
        if let height = rowHeight {
            row.rowHeight = height
        }
        let fieldName = fieldName ?? (header ?? "empty").lowercased().replacingOccurrences(of: " ", with: "_")
        let _ = DynamicFormSectionData.addSection(toModel: self.viewModel, formField: row, fieldName: fieldName, headerTitle: header)
        return label
    }
    
    func addTextField(fieldName: String, placeholder: String?, header: String?, autoAdd: Bool = true, insertAfterFieldWithName: String? = nil, insertBefore: Bool = false, required: Bool = true )-> DynamicSimpleInputGroupViewModel {
        let row = DynamicSimpleInputGroupViewModel()
        row.inputGroup.placeholder = placeholder
        row.isRequired = required
        let _ = DynamicFormSectionData.addSection(toModel: self.viewModel, formField: row, fieldName: fieldName, headerTitle: header, insertAfterFieldWithName: insertAfterFieldWithName, insertBefore: insertBefore)
        return row
    }
    
    func addDateField(fieldName: String, placeholder: String?, header: String?, autoAdd: Bool = true, insertAfterFieldWithName: String? = nil, insertBefore: Bool = false, required: Bool = true, pickerMode: DynamicFormDateTimePickerMode = .dateTime ) -> DynamicFormDateTimeViewModel {
        let row = DynamicFormDateTimeViewModel()
        row.enableScrollToBottom = false
        row.pickerMode = pickerMode
        row.datePicker.placeholder = placeholder
        row.datePicker.validRequired = required
        let _ = DynamicFormSectionData.addSection(toModel: self.viewModel, formField: row, fieldName: fieldName, headerTitle: header, autoAdd: autoAdd, insertAfterFieldWithName: insertAfterFieldWithName, insertBefore: insertBefore)
        return row
    }
    
    func disposePopulator() {
        disposeBag = nil
        buttonBar = nil
        viewModel.removeAllSections()
    }
    
    func removeAllFieldsAfterFieldWithName(fieldName: String) {
        if let row = viewModel.findRowWithName(name: fieldName) {
            if let indexPath = row.indexPath {
//                let sections = viewModel.findAllSectionsAfter(index: indexPath.section)
//                sections.forEach { (section) in
//                    if section.items.count > 0 {
//                        let name = section.items[0].getFieldName()
//                        self.removeFieldWithName(fieldName: name)
//                    }
//                }
                viewModel.removeSectionAfterIndex(index: indexPath.section)
            }
        }
    }
    
    func removeAllSections() {
        viewModel.removeAllSections()
    }
    
    func removeAllFieldsAfterFieldWithIndex(section: Int) {
        viewModel.removeSectionAfterIndex(index: section) 
    }
    
    func removeFieldWithName(fieldName: String) {
        if let row = viewModel.findRowWithName(name: fieldName) {
            if let path = row.indexPath {
                viewModel.removeSection(sectionIndex: path.section)
            }
        }
    }
    
    func removeFieldWithId(widgetId: String) {
        if let row = viewModel.findRowWithWidgetId(widgetId: widgetId) {
            if let path = row.indexPath {
                viewModel.removeSection(sectionIndex: path.section)
            }
        }
    }
    
    func hasField(fieldName: String)-> Bool {
        return viewModel.hasSectionWidgetWithName(name: fieldName)
    }
    
    func getFieldValue(fieldName: String)-> Any? {
        return viewModel.formController.fieldValues[fieldName]
    }
    
    func getFieldValueAsString(fieldName: String)-> String? {
        if let data = getFieldValue(fieldName: fieldName) {
            return String(describing: data)
        }
        return nil
    }
    
    func getFieldValueAsBool(fieldName: String, defaultValue: Bool = false)-> Bool {
        if let selection = getFieldValue(fieldName: fieldName) as? YesNoSingleItem {
            switch selection {
            case .no:
                return false
            case .yes:
                return true
            }
        }
        return defaultValue
    }
    
    func getFieldValueAsDouble(fieldName: String, convertToKobo: Bool = false)-> Double? {
        if let value = self.getFieldValue(fieldName: fieldName) as? String {
            if let amount = Double(value.replacingOccurrences(of: ",", with: "")) {
                if convertToKobo {
                    return amount * 100.0
                }
                return amount
            }
        }
        return 0
    }
    
    func getFieldValueAsInt(fieldName: String)-> Int? {
        if let value = self.getFieldValue(fieldName: fieldName) as? String {
            if let amount = Int(value.replacingOccurrences(of: ",", with: "")) {
                return amount
            }
        }
        return 0
    }
    
//    func getSaveAsBeneficary(fieldName: String)-> Bool {
//        if let selection = getFieldValue(fieldName: fieldName) as? YesNoSingleItem {
//            switch selection {
//            case .no:
//                return false
//            case .yes:
//                return true
//            }
//        }
//        return false
//    }
    
//    func loadRecurringFields(afterAddCallback: EmptyCallback? = nil) {
//        self.addRecuringFieldType()
//        afterAddCallback?()
//    }
    
    func getRecurringPopulator()-> RecurringFieldsPopulator {
        return RecurringFieldsPopulator.populateFrom(viewModel: self)
    }
    
//    fileprivate func addRecuringFieldType() {
//        if !hasField(fieldName: self.FIELD_NAME_RECURRING_TYPE) {
//            let field = DynamicFormSegmentViewModel()
//
//            field.nextFieldCallable = { (currentField: DynamicFormSectionRow, viewModel: DynamicFormTableViewModel) in
//                self.addRecurringExtraFields()
//            }
//
//            field.items = [RecurringFieldType.instant, RecurringFieldType.later, RecurringFieldType.repeating]
//            let _ = DynamicFormSectionData.addSection(toModel: viewModel, formField: field, fieldName: self.FIELD_NAME_RECURRING_TYPE, headerTitle: "")
//        }
//    }
    
//    fileprivate func addRecurringExtraFields() {
//        if let type = self.getRecurringType() {
//            self.removeAllFieldsAfterFieldWithName(fieldName: self.FIELD_NAME_RECURRING_TYPE)
//            switch type {
//            case .instant:
//                break
//            case .later:
//                self.addRecurringStartDate(withTime: true)
//            case .repeating:
//                self.addRecurringStartDate(withTime: true)
//                self.addRecurringEndDate()
////                self.addRecurringTransferTime()
//                self.addRecurringFrequency()
//            }
//            
//        }
//    }
    
    fileprivate func addRecurringStartDate(withTime: Bool = false) {
        if !hasField(fieldName: self.FIELD_NAME_RECURRING_START_DATE) {
            let field = DynamicFormDateTimeViewModel()
            field.datePicker.setMinimumDateTo(date: nil)
            field.isRequired = true
            var label = "Set Start Date & Time"
            if !withTime {
                label = "Start Date"
                field.pickerMode = .date
            }
            let _ = DynamicFormSectionData.addSection(toModel: viewModel, formField: field, fieldName: self.FIELD_NAME_RECURRING_START_DATE, headerTitle: label)
        }
    }
    
    fileprivate func addRecurringEndDate() {
        if !hasField(fieldName: self.FIELD_NAME_RECURRING_END_DATE) {
            let field = DynamicFormDateTimeViewModel()
            field.datePicker.minimumDateField = self.FIELD_NAME_RECURRING_START_DATE
            field.isRequired = true
//            field.pickerMode = "date"
            let _ = DynamicFormSectionData.addSection(toModel: viewModel, formField: field, fieldName: self.FIELD_NAME_RECURRING_END_DATE, headerTitle: "End Date")
        }
    }
    
    fileprivate func addRecurringTransferTime() {
        if !hasField(fieldName: self.FIELD_NAME_RECURRING_TRANSFER_TIME) {
            let field = DynamicFormDateTimeViewModel()
            field.isRequired = true
            field.pickerMode = .time
            let _ = DynamicFormSectionData.addSection(toModel: viewModel, formField: field, fieldName: self.FIELD_NAME_RECURRING_TRANSFER_TIME, headerTitle: "Transfer Time")
        }
    }
    
//    fileprivate func addRecurringFrequency() {
//        if !hasField(fieldName: self.FIELD_NAME_RECURRING_FREQUENCY) {
//            let field = DynamicFormSegmentViewModel()
//
//            field.nextFieldCallable = { (currentField: DynamicFormSectionRow, viewModel: DynamicFormTableViewModel) in
//
//                self.removeAllFieldsAfterFieldWithName(fieldName: self.FIELD_NAME_RECURRING_FREQUENCY)
//                if let frequency = self.getFieldValue(fieldName: self.FIELD_NAME_RECURRING_FREQUENCY) as? RecurringFrequencyFieldType {
//                    switch frequency{
//                    case .custom:
//                        self.addRecurringFrequencyNumberOfDays()
//                    default:
//                        break
//                    }
//                }
//            }
//
//            field.items = [RecurringFrequencyFieldType.daily, RecurringFrequencyFieldType.weekly, RecurringFrequencyFieldType.monthly, RecurringFrequencyFieldType.custom]
//            let _ = DynamicFormSectionData.addSection(toModel: viewModel, formField: field, fieldName: self.FIELD_NAME_RECURRING_FREQUENCY, headerTitle: "")
//        }
//    }
    
    fileprivate func addRecurringFrequencyNumberOfDays() {
        if !hasField(fieldName: self.FIELD_NAME_RECURRING_FREQUENCY_NUMBER_OF_DAYS) {
            let row = DynamicFormSectionRow()
            let field = InputFieldGroup(frame: CGRect.zero)
            field.keyboardType = "number"
            field.leftIcon = "time"
            field.placeholder = "0"
            field.showLeftIcon = true
            field.showRightIcon = true
            field.rightIcon = "days"            
            field.rightAddon?.font = FontIcon.days.font(9)!
            row.widgetView = field
            row.rowHeight = 65
            row.isRequired = true
            let _ = DynamicFormSectionData.addSection(toModel: viewModel, formField: row, fieldName: self.FIELD_NAME_RECURRING_FREQUENCY_NUMBER_OF_DAYS, headerTitle: "Frequency")
        }
    }
    
    //MARK: Data Retrievers
    
    func getRecurringType(usingDefault: RecurringFieldType? = RecurringFieldType.instant)-> RecurringFieldType? {
        if let type = self.getFieldValue(fieldName: self.FIELD_NAME_RECURRING_TYPE) as? RecurringFieldType {
            return type
        }
        return usingDefault
    }
    
    func getFormDataItems()-> Any? {
        return nil
    }
}
