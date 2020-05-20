//
//  DynamicFormViewDatasource.swift
//  FCMB-Mobile
//
//  Created by Kembene Nkem-Etoh on 4/2/18.
//  Copyright © 2018 FCMB. All rights reserved.
//

import UIKit
import RxDataSources

class DynamicFormViewDatasource: RxTableViewSectionedReloadDataSource<DynamicFormSectionData> {
    
    func addViewToCell(cell: DynamicFormTableViewCell, view: UIView) {
        cell.attachCellContent(view)
    }
    
    open func getHorizontalPaddingForCell(cell: DynamicFormTableViewCell, view: UIView)-> CGFloat {
        return 0.0
    }
}
