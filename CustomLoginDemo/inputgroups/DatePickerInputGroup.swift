//
//  DatePickerInputGroup.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import UIKit

class DatePickerInputGroup: InputFieldGroup {

    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var useDateAsValue = true
    @IBInspectable var minimumDateField: String?
    var incrementMinimumDateByMinutes: Int?
    
    @IBInspectable var pickerMode: String = "datetime" {
        didSet {
            switch pickerMode {
            case "datetime":
                datePicker.datePickerMode = .dateAndTime
            case "date":
                datePicker.datePickerMode = .date
            case "time":
                datePicker.datePickerMode = .time
            default:
                break
            }
        }
    }
    
    override func setupXnib() {
        self.isTextInput = false
        super.setupXnib()
        createDatePicker()
    }

    override func shouldAllowTextEditing()-> Bool{
        return false
    }
    
//    override func activateField() {
//        createDatePicker()
//    }
    
    func setMinimumDateTo(date: Date? = nil) {
        self.datePicker.minimumDate = date ?? Date()
    }
    
    func createDatePicker() {
        titleToolbarButtonText = "Pick a date"
        inputField!.inputView = datePicker
        inputField?.addTarget(self, action: #selector(onTextFieldTouched), for: UIControl.Event.editingDidBegin)
    }
    
    override func toolbarDoneButtonClicked() {
        setDateValue(date: datePicker.date)
        super.toolbarDoneButtonClicked()
    }
    
    @objc func onTextFieldTouched() {
        if let fieldName = self.minimumDateField {
            if let value = self.inputFieldGroupDelegate?.getFieldValue?(fieldName: fieldName) {
                if let date = value as? Date {
                    if let incrementByMinute = self.incrementMinimumDateByMinutes{
                        self.datePicker.minimumDate = Calendar.current.date(byAdding: Calendar.Component.minute, value: incrementByMinute, to: date)
                    }
                    else{
                        self.datePicker.minimumDate = date
                    }
                }
            }
        }
    }
    
    func formatSelectedDate(date: Date? = nil)-> String {
        let theDate: Date = date ?? datePicker.date
        return self.formatDate(date: theDate)
    }
    
    func setDateValue(date: Date) {
        datePicker.date = date
        inputField?.text = formatSelectedDate(date: date)
        if useDateAsValue {
            self.fieldValue = datePicker.date
        }
    }
    
    func formatDate(date: Date)-> String {
        switch datePicker.datePickerMode {
        case .date:
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
        case .time:
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .medium
        case .dateAndTime:
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
        default:
            break
        }
        return dateFormatter.string(from: date)
    }
}
