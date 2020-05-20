//
//  RadioListTable.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol RadioListDataItem {
    func getItemLabel()->String
}

protocol RadioListDataItemImage {
    func getImage()-> UIImage?
}

protocol RadioListDataItemSubTitle {
    func getSubtitle()-> String?
}

protocol RadioListDataItemRightTitle {
    func getRadioRightTitle()-> String?
}

protocol RadioListItemRenderer {
    func renderForItem(table: UITableView, item: RadioListDataItem, cell: SubTitleTableCellWithRadioButton, index: Int)
}

class StringRadioListItem: RadioListDataItem {
    func getItemLabel() -> String {
        return self.string
    }
    
    var string: String
    init(_ string: String) {
        self.string = string
    }
}

fileprivate class RadioListItemMoreButton: UIView, RadioListDataItem {
    func getItemLabel()-> String {
        return "Show More"
    }
}

protocol RadioListDataProvider {
    func getSummaryItems()-> Observable<[RadioListDataItem]>
    func getFullItems()-> Observable<[RadioListDataItem]>?
    func hasExpandedList() -> Bool
}

class SimpleRadioListDataProvider: RadioListDataProvider {
    
    var summaryItems: Observable<[RadioListDataItem]>
    var fullItems: Observable<[RadioListDataItem]>?
    var expandable: Bool
    init(summaryItems: Observable<[RadioListDataItem]>, fullItems: Observable<[RadioListDataItem]>?) {
        self.summaryItems = summaryItems
        self.fullItems = fullItems
        self.expandable = fullItems != nil
    }
    
    func getSummaryItems()-> Observable<[RadioListDataItem]> {
        return self.summaryItems
    }
    func getFullItems()-> Observable<[RadioListDataItem]>? {
        return self.fullItems
    }
    func hasExpandedList() -> Bool {
        return self.expandable
    }
    
    class func fromStringItems(summaryItems: [String], fullItems: [String]?)-> SimpleRadioListDataProvider {
        var fullItemsObservable: Observable<[RadioListDataItem]>? = nil
        let summaryObservable = Observable.from(summaryItems).map { (item) -> StringRadioListItem in
            return StringRadioListItem(item)
            }.map { (item) -> RadioListDataItem in
                return item
        }.toArray()
        if let full = fullItems {
            fullItemsObservable = Observable.from(full).map { (item) -> StringRadioListItem in
                return StringRadioListItem(item)
                }.toArray().asObservable()
        }
        return SimpleRadioListDataProvider(summaryItems: summaryObservable.asObservable(), fullItems: fullItemsObservable)
    }
    
    class func toRadioListItemDataSet<A>(observable: Observable<A>)->Observable<[RadioListDataItem]> {
        return observable
            .filter { (item) -> Bool in
                return (item as? RadioListDataItem) != nil
            }
            .toArray().asObservable().map { (rawItems) -> [RadioListDataItem] in
                return rawItems.map({ (item) -> RadioListDataItem in
                    return item as! RadioListDataItem
                })
            }
    }
    
    class func toRadioListItemDataSet<A>(observable: Observable<[A]>)->Observable<[RadioListDataItem]> {
        return observable.map { (items) -> [RadioListDataItem] in
            return items.filter({ (item) -> Bool in
                return (item as? RadioListDataItem) != nil
            }).map({ (item) -> RadioListDataItem in
                return item as! RadioListDataItem
            })
        }
    }
}

enum RadioListViewMode {
    case summary
    case collapsed
    case expanded
}

protocol RadioListTableUIViewMoreItemRequested {
    func requestMoreItems(listView: RadioListTableUIView)-> Observable<[RadioListDataItem]?>
}

class RadioListTableUIView: UIView {
    var radioListTable: RadioListTable!
    //var moreViewButton: IconTextButton!
    var collapsible: Bool = true
    var tableViewMode: RadioListViewMode = .summary
    
    var moreItemsDelegate: RadioListTableUIViewMoreItemRequested?
    
    fileprivate var tableHeightAnchor: NSLayoutConstraint!
    fileprivate var buttonHeightAnchor: NSLayoutConstraint!
    fileprivate var heightChangeSubject = PublishSubject<CGFloat>()
    
    var heightChanged: Observable<CGFloat> {
        return heightChangeSubject.asObservable()
    }
    
    
    var tableRowHieght: CGFloat = 60 {
        didSet {
            radioListTable.rowHeight = self.tableRowHieght
        }
    }
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        //self.moreViewButton = IconTextButton(type: .system)
        //self.moreViewButton.setTitle("Show More", for: .normal)
        //self.moreViewButton.titleFont = FontStyle.SemiBold.getFont()
        //self.moreViewButton.setTitleColor(UIColor.colorFromHexString("Show More"), for: .normal)
        //self.moreViewButton.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.57)
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 40)
        radioListTable = RadioListTable(frame: frame, style: .plain)
        radioListTable.backgroundColor = UIColor.white
        self.layoutTableView()
        self.layoutMoreButton()
    }
    
    func layoutTableView() {
        self.addSubview(self.radioListTable)
        self.radioListTable.translatesAutoresizingMaskIntoConstraints = false
        radioListTable.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: radioListTable.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: radioListTable.topAnchor, constant: 0).isActive = true
        self.tableHeightAnchor = self.radioListTable.heightAnchor.constraint(equalToConstant: 0)
        self.tableHeightAnchor.isActive = true
        
        radioListTable.selectedObserver.subscribe(onNext: { (arg0) in
            let (index, model) = arg0
            self.tableItemSelected(model: model, index: index)
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: radioListTable.disposeBag)
        
        radioListTable.deselectedObserver.subscribe(onNext: { index in
            self.tableItemDeselected(indexPath: index)
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
            }.disposed(by: radioListTable.disposeBag)
        
        radioListTable.modelListChangeObserver.subscribe(onNext: { (items) in
//            if items.count > 0 {
                self.updateHeightOfView(height: CGFloat(items.count) * self.tableRowHieght)
//            }
            
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }) {
            
        }.disposed(by: radioListTable.disposeBag)
        
    }
    
    func layoutMoreButton() {
        //self.addSubview(self.moreViewButton)
        //self.moreViewButton.translatesAutoresizingMaskIntoConstraints = false
        //moreViewButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
       // self.trailingAnchor.constraint(equalTo: moreViewButton.trailingAnchor).isActive = true
        //moreViewButton.topAnchor.constraint(equalTo: radioListTable.bottomAnchor, constant: 0).isActive = true
        //self.buttonHeightAnchor = moreViewButton.heightAnchor.constraint(equalToConstant: self.tableRowHieght)
        self.buttonHeightAnchor.isActive = true
        
        //self.bottomAnchor.constraint(equalTo: moreViewButton.bottomAnchor, constant: 0).isActive = true
        
//        self.moreViewButton.rx.tap.bind {
//
//            if let delegate = self.moreItemsDelegate {
//                var disposeable: Disposable? = nil
//                disposeable = delegate.requestMoreItems(listView: self)
//                    .subscribe(onNext: { (selectedItem) in
//                        if selectedItem != nil {
//                            self.selectItemFromMoreCallback(model: selectedItem!)
//                        }
//                        disposeable?.dispose()
//                    }, onError: { (error) in
//
//                    }, onCompleted: {
//
//                    }, onDisposed: {
//
//                    })
//            }
//
//        }.disposed(by: self.radioListTable.disposeBag)
    }
    
    func selectItemFromMoreCallback(model: [RadioListDataItem]) {
        self.tableItemSelected(models: model)
    }
    
    func tableItemSelected(model: RadioListDataItem, index: IndexPath?) {
        if tableViewMode == .summary {
            // now collapse the table view
            if self.collapsible {
                tableViewMode = .collapsed
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.radioListTable.showOnlyItem(item: model)
                }
                self.updateHeightOfView(height: self.tableRowHieght)
                if radioListTable.hasMoreItems {
                    self.hideMoreButton()
                }
                else {
                    self.hideMoreButton(animate: false)
                }
            }
        }
    }
    
    func tableItemSelected(models: [RadioListDataItem]) {
        if tableViewMode == .summary {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.radioListTable.showOnlyItem(items: models, selectFirst: true, fromExternal: true)
                self.updateHeightOfView(height: self.tableRowHieght * CGFloat(models.count))
            }
        }
    }
    
    func tableItemDeselected(indexPath: IndexPath?) {
        if tableViewMode == .collapsed {
            tableViewMode = .summary
            if radioListTable.hasMoreItems {
                showMoreButton()
            }
            radioListTable.restoreSummary()
        }
    }
    
    func showMoreButton() {
        //moreViewButton.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.buttonHeightAnchor.constant = self.tableRowHieght
            //self.moreViewButton.alpha = 1
            self.layoutIfNeeded()
        }
    }
    
    func hideMoreButton(animate: Bool = true) {
        if animate {
            //moreViewButton.alpha = 1
            UIView.animate(withDuration: 0.5) {
                self.buttonHeightAnchor.constant = 0
                //self.moreViewButton.alpha = 0
                self.layoutIfNeeded()
            }
        }
        else {
            self.buttonHeightAnchor.constant = 0
           // self.moreViewButton.alpha = 0
        }
    }
    
    fileprivate func broadcastNewHeight(height: CGFloat) {
        heightChangeSubject.onNext(height)
    }

    fileprivate func updateHeightOfView(height: CGFloat) {
        var newHeight = height
        if tableViewMode == .summary {
            if radioListTable.hasMoreItems {
                newHeight += self.tableRowHieght
            }
            else {
                self.hideMoreButton(animate: false)
            }
        }
        if newHeight < 60 {
            newHeight = 60
        }
        self.broadcastNewHeight(height: newHeight)
        
        UIView.animate(withDuration: 0.6) {
            self.tableHeightAnchor.constant = height
            self.layoutIfNeeded()
        }
    }
}

class RadioListTable: UITableView {

    var disposeBag = DisposeBag()
    fileprivate var models: [RadioListDataItem]?
    var boundObserver: Disposable?
    var lastProvider: RadioListDataProvider?
    
    var cellRenderer: RadioListItemRenderer?
    var moreViewButton: UIButton!
    var lastSelectedIndex: IndexPath?
    var shouldHaveMoreItem = false
    fileprivate var hasExpandedList = true;
    var hasMoreItems: Bool  {
        get {
            if !hasExpandedList {
                return shouldHaveMoreItem
            }
            else {
                return hasExpandedList
            }
        }
    }
    
    var viewMode: RadioListViewMode = .summary
    
    var overlayDelegate: CloseableOverlayDelegate?
    var overlayCloseDisposable: Disposable?
    var allowAccountSelectionCallback: ((_ model: RadioListDataItem)-> Bool)?
    
    
    fileprivate var deselectedPublisher = PublishSubject<IndexPath?>()
    fileprivate var modelListChangePublisher = PublishSubject<[RadioListDataItem]>()
    fileprivate var selectedPublisher = PublishSubject<(IndexPath?, RadioListDataItem)>()
    fileprivate var valuePublisher = PublishSubject<Any?>()
    fileprivate var valueTextPublisher = PublishSubject<String?>()
    
    var selectedObserver: Observable<(IndexPath?, RadioListDataItem)> {
        return selectedPublisher.asObservable()
    }
    
    var deselectedObserver: Observable<IndexPath?> {
        return deselectedPublisher.asObservable()
    }
    
    var modelListChangeObserver: Observable<[RadioListDataItem]> {
        return modelListChangePublisher.asObservable()
    }
    
    var valueObservable: Observable<Any?> {
        return valuePublisher.asObservable()
    }
    var valueTextObservable: Observable<String?> {
        return valueTextPublisher.asObservable()
    }
    
    func cleanupObservation() {
        self.boundObserver?.dispose()
        self.overlayCloseDisposable?.dispose()
        self.disposeBag = DisposeBag()
        valuePublisher.onCompleted()
        valueTextPublisher.onCompleted()
        selectedPublisher.onCompleted()
        modelListChangePublisher.onCompleted()
        deselectedPublisher.onCompleted()
    }
    
    
    deinit {
        print("Destroy RadioListTable")
    }
    
    public override init(frame: CGRect, style: UITableView.Style){
        super.init(frame: frame, style: style)
        self.prepareTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepareTable()
    }
    
    func prepareTable() {
        self.register(SubTitleTableCellWithRadioButton.self, forCellReuseIdentifier: "base")
        self.register(UITableViewCell.self, forCellReuseIdentifier: "more")
        
        self.rx.modelSelected(RadioListDataItem.self).subscribe(onNext: { (selectedModel) in
            if self.shouldAllowSelection(model: selectedModel) {
                self.modelHasBeenSelected(model: selectedModel)
            }
            else{
                self.indexPathsForSelectedRows?.forEach({ (index) in
                    self.deselectRow(at: index, animated: true)
                })
            }
        }).disposed(by: self.disposeBag)
        
    }
    
    fileprivate func shouldAllowSelection(model: RadioListDataItem)-> Bool {
        return self.allowAccountSelectionCallback?(model) ?? true
    }
    
    func modelHasBeenSelected(model selectedModel: RadioListDataItem) {
        var broadcastSelection = true
        if let selectedRow = self.indexPathForSelectedRow {
            if let lastSelected = self.lastSelectedIndex {
                if lastSelected.row == selectedRow.row {
                    
                    self.lastSelectedIndex = nil
                    self.deselectedPublisher.onNext(selectedRow)
                    
                    broadcastSelection = false
                }
            }
        }
        if broadcastSelection {
            self.selectedPublisher.onNext((self.indexPathForSelectedRow, selectedModel))
            self.valuePublisher.onNext(selectedModel)
            self.valueTextPublisher.onNext(selectedModel.getItemLabel())
            self.lastSelectedIndex = self.indexPathForSelectedRow
            // closeOverlay only takes effect if this view was rendered by a bottomsheet
            self.closeOverlay()
        }
    }
    
    func bindToProvider(provider: RadioListDataProvider) {
        self.lastProvider = provider
        boundObserver?.dispose()
        self.hasExpandedList = provider.hasExpandedList()
        if let currentProvider = self.lastProvider {
            self.viewMode = .summary
            self.boundObserver = currentProvider
                .getSummaryItems()
                .map({ (items) -> [RadioListDataItem] in
                    self.models = items
                    self.modelListChangePublisher.onNext(items)
                    return items
                })
                .bind(to: self.rx.items(cellIdentifier: "base", cellType: SubTitleTableCellWithRadioButton.self)){
                    index, model, cell in
                    
                    if let renderer = self.cellRenderer {
                        renderer.renderForItem(table: self, item: model, cell: cell, index: index)
                    } else {
                        cell.textLabel?.text = model.getItemLabel()
                    }
                    
//                    self.sele
                    if self.shouldAllowSelection(model: model) {
                        cell.backgroundColor = UIColor.clear
                        cell.layer.backgroundColor = UIColor.clear.cgColor
                        cell.backgroundView?.backgroundColor = UIColor.clear
                        cell.lockCell = false
                    }
                    else {
                        cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
                        cell.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
                        cell.backgroundView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
                        cell.lockCell = true
                    }
            }
            boundObserver?.disposed(by: self.disposeBag)
        }
    }
    
    fileprivate func showOnlyItem(item: RadioListDataItem) {
        showOnlyItem(items: [item])
    }
    
    fileprivate func showOnlyItem(items: [RadioListDataItem], selectFirst: Bool = true, fromExternal: Bool = false) {
        boundObserver?.dispose()
        self.viewMode = .collapsed
        self.boundObserver = Observable.of(items)
            .bind(to: self.rx.items(cellIdentifier: "base", cellType: SubTitleTableCellWithRadioButton.self)){
                index, model, cell in
                cell.backgroundColor = UIColor.clear
                cell.layer.backgroundColor = UIColor.clear.cgColor
                cell.backgroundView?.backgroundColor = UIColor.clear
                if let renderer = self.cellRenderer {
                    renderer.renderForItem(table: self, item: model, cell: cell, index: index)
                } else {
                    cell.textLabel?.text = model.getItemLabel()
                }
                if selectFirst {
                    self.lastSelectedIndex = IndexPath(row: 0, section: 0)
                    self.selectRow(at: self.lastSelectedIndex!, animated: true, scrollPosition: .top)
                    if fromExternal{
                        self.lastSelectedIndex = IndexPath(row: -1, section: 0)
                        self.modelHasBeenSelected(model: model)
                    }
                }
        }
        boundObserver?.disposed(by: self.disposeBag)
        
    }
    
    fileprivate func restoreSummary() {
        if let provider = self.lastProvider{
            self.bindToProvider(provider: provider)
        }
    }

}

extension RadioListTable: CloseableOverlayView {
    func setOverlayCloseDelegate(delegate: CloseableOverlayDelegate) {
        self.overlayDelegate = delegate
        self.overlayCloseDisposable?.dispose()
        self.overlayCloseDisposable = delegate.overlayStateObservable.subscribe(onNext: { (state) in
            if state == .willClose {
                self.overlayDelegate = nil
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            self.overlayDelegate = nil
        }, onDisposed: {
            
        })
        self.overlayCloseDisposable?.disposed(by: disposeBag)
    }
    
    func closeOverlay() {
        if let delegate = self.overlayDelegate {
            self.overlayDelegate = nil
            self.overlayCloseDisposable?.dispose()
            delegate.closeButtonSheet()
        }
    }
}

protocol CloseableOverlayDelegate{
    var overlayStateObservable: Observable<CloseableOverlayState> {get}
    func closeButtonSheet()
}

protocol CloseableOverlayView {
    func setOverlayCloseDelegate(delegate: CloseableOverlayDelegate)
}

enum CloseableOverlayState {
    case willClose
    case didClose
}
