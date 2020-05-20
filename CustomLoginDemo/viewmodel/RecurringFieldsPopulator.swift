//
//  RecurringFieldsPopulator.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//


import Foundation
import Alamofire

class RecurringFieldsPopulator {
    
    fileprivate var recurringType: RecurringFieldType = RecurringFieldType.instant
    fileprivate var startDate: Date?
    fileprivate var endDate: Date?
    fileprivate var endTime: Date?
    fileprivate var frequency: RecurringFrequencyFieldType?
    fileprivate var customFrequencyCount: Int?
    var valid = true
    
    fileprivate init(){}
    
    class func populateFrom(viewModel: BaseViewModelPopulator) ->RecurringFieldsPopulator {
        let populator = RecurringFieldsPopulator()
        populator.populate(viewModel: viewModel)
        return populator
    }
    
    fileprivate func populate(viewModel: BaseViewModelPopulator) {
        if let type = viewModel.getFieldValue(fieldName: viewModel.FIELD_NAME_RECURRING_TYPE) as? RecurringFieldType{
            self.recurringType = type
        }
        if recurringType == .repeating {
            if let frequency = viewModel.getFieldValue(fieldName: viewModel.FIELD_NAME_RECURRING_FREQUENCY) as? RecurringFrequencyFieldType {
                self.frequency = frequency
            }
            else {
                if self.recurringType == .repeating {
                    self.frequency = RecurringFrequencyFieldType.daily
                }
            }
        }
        
        if let date = viewModel.getFieldValue(fieldName: viewModel.FIELD_NAME_RECURRING_START_DATE) as? Date {
            self.startDate = date
        }
        if let endDate = viewModel.getFieldValue(fieldName: viewModel.FIELD_NAME_RECURRING_END_DATE) as? Date {
            self.endDate = endDate
        }
        
        if let frequencyCount = viewModel.getFieldValue(fieldName: viewModel.FIELD_NAME_RECURRING_FREQUENCY_NUMBER_OF_DAYS) as? String {
            if let count = Int(frequencyCount) {
                self.customFrequencyCount = count
            }
        }
        
//        if let endTime = viewModel.getFieldValue(fieldName: viewModel.FIELD_NAME_RECURRING_END_DATE) as? Date {
//            self.endTime = endTime
//            if let endDate = self.endDate {
//                let dateString = ApplicationUtility.basicDateFormatter.string(from: endDate)
//                let timeString = ApplicationUtility.basicTimeFormatter.string(from: endTime)
//                let endDateAndTimeString = "\(dateString) \(timeString)"
//                if let endDateAndTime = ApplicationUtility.basicDateTimeFormatter.date(from: endDateAndTimeString) {
//                    self.endDate = endDateAndTime
//                }
//            }
//        }
        
        if startDate != nil && endDate != nil && customFrequencyCount != nil{
//            if let days = Calendar.current.dateComponents([.day], from: startDate!, to: endDate!).day {
//                if customFrequencyCount! > days {
//                    valid = false
//                    let title = "Invalid Frequency"
//                    let message = "Your frequency (\(customFrequencyCount!) days) cannot exceed \(days)"
//                    let _ = UIAlertControllerUtility.showAlert(title: title, message: message)
//                }
//            }
        }
        
    }
    
//    func mapToRequestData(requestParam: Parameters, mapper: RecurringFieldsMapper)-> Parameters {
//        var params: Parameters = requestParam
//        params[mapper.PARAM_NAME_recurringType] = recurringType.getParameterValue()
//        switch recurringType {
//        case .later:
//            if let date = self.startDate {
//                params[mapper.PARAM_NAME_startDate] = date.millisecondsSince1970
//            }
//        case .repeating:
//            if let date = self.startDate {
//                params[mapper.PARAM_NAME_startDate] = date.millisecondsSince1970
//            }
//            if let date = self.endDate {
//                params[mapper.PARAM_NAME_endDate] = date.millisecondsSince1970
//            }
//            if let frequency = self.frequency {
//                params[mapper.PARAM_NAME_Frequency] = frequency.getParameterValue()
//            }
//            if let customFrequency = self.customFrequencyCount {
//                params[mapper.PARAM_NAME_CUSTOM_FREQUENCY] = customFrequency
//            }
//        default:
//            break
//        }
//        return params
//    }
}


//class RecurringFieldsMapper {
//    var PARAM_NAME_recurringType = "paymentType"
//    var PARAM_NAME_startDate = "payDate"
//    var PARAM_NAME_endDate = "payEndDate"
//    var PARAM_NAME_CUSTOM_FREQUENCY = "frequency"
//}

