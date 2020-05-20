//
//  DynamicFormTable.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class DynamicFormTable: UITableView {
    
    var viewModel: DynamicFormTableViewModel!
    var disposeBag = DisposeBag()
    var internalDisposeBag: DisposeBag?
    var formDatasource: DynamicFormViewDatasource!
    var registeredDisposed: Disposable?
    var horizontalPadding: CGFloat = 25
    
    var delegateAdapter: UITableViewDelegate?
    
    public override init(frame: CGRect, style: UITableView.Style){
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func prepareTable() {
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 44
        self.backgroundColor = UIColor.clear
        self.separatorStyle = .none
        self.allowsSelection = false
        
        
        self.rx.setDelegate(self).disposed(by: self.disposeBag)
        self.register(DynamicFormTableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        
        self.formDatasource = DynamicFormViewDatasource(configureCell: {(datasource, tableView, indexPath, data) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DynamicFormTableViewCell
            
            cell.horizontalPadding = self.horizontalPadding
            let sectionData = datasource.sectionModels[indexPath.section].items[indexPath.row]
            sectionData.indexPath = indexPath
            
            if let view = sectionData.getEmbeddedView(){
                self.formDatasource.addViewToCell(cell: cell, view: view)
            }
            
            if let heightObserver = sectionData.heightObserver {
                heightObserver.subscribe(onNext: { (changed) in
                    self.beginUpdates()
                    self.endUpdates()
                }).disposed(by: self.disposeBag)
            }
            if let renderObserver = sectionData.reRenderObserver {
                renderObserver.subscribe(onNext: {
                    (renderPath) in
                    if let path = renderPath {
                        let indexSet: IndexSet = IndexSet(integersIn: path.section...path.section)
                        self.reloadSections(indexSet, with: .fade)
                    }
                }).disposed(by: self.disposeBag)
            }
            return cell
        })
        
        self.formDatasource.titleForHeaderInSection = { ds, index in
            if index < ds.sectionModels.count {
                let section = ds.sectionModels[index]
                if section.showHeader {
                    var required = ""
                    if section.validRequired {
                        required = " *"
                    }
                    
                    if var header = ds.sectionModels[index].header {
                        if !header.isEmpty {
                            header += required
                        }
                        return header
                    }
                    return nil
                }
            }
            
            return nil
        }
    }
    
    func bindToViewModel(viewModel: DynamicFormTableViewModel? = nil) {
        if viewModel == nil {
            self.viewModel = DynamicFormTableViewModel()
        } else {
            self.viewModel = viewModel
        }
        registeredDisposed?.dispose()
        self.viewModel.bindToView(view: self)
        
        registeredDisposed = self.viewModel.sections
            .bind(to: self.rx.items(dataSource: self.formDatasource))
        registeredDisposed?.disposed(by: disposeBag)
        
    }

}


extension DynamicFormTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let adapter = delegateAdapter {
//            if let height = adapter.tableView?(tableView, heightForRowAt: indexPath) {
//                return height
//            }
//        }
        return self.formDatasource.sectionModels[indexPath.section].items[indexPath.row].getCellHeight()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let item = cell as? DynamicFormTableViewCell {
            item.renderView()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerTitle = formDatasource.tableView(tableView, titleForHeaderInSection: section) {
            let label = IconTextLabel()
            label.horizontalSpacing = horizontalPadding
            label.verticalSpacing = 0
            label.numberOfLines = 0
            label.backgroundColor = UIColor.clear
            //label.usingFont(of: .Default)
            label.textColor = UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 0.76)
            label.labelText = headerTitle
            
            return label
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = formDatasource.tableView(tableView, titleForHeaderInSection: section) {
            return 35
        }
        return 1.0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let adapter = delegateAdapter {
            adapter.scrollViewDidEndDecelerating?(scrollView)
        }
    }
}
