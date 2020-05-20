//
//  StatusMessagesPresenter.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//

import Foundation
import RxSwift

typealias StatusMessagePresenterConfigure = (_ config: BottomSheetConfig, _ header: SimpleMessageWithHeader)->Void

class StatusMessagesPresenter {
    fileprivate var messageHeader: SimpleMessageWithHeader!
    fileprivate var config = BottomSheetConfig(icon: nil, cancelButtonText: "Ok")
    var dispose: Disposable?
    var disposeBag = DisposeBag()
    var callback: EmptyCallback?
    
    fileprivate init() {
        
    }
    
    deinit {
        print("Destroying \(self)")
    }
    
    class func instance(title: String, message: String, estimatedHeight: CGFloat? = 100)-> StatusMessagesPresenter {
        let presenter = StatusMessagesPresenter()
        presenter.messageHeader = SimpleMessageWithHeader.createWith(message: message, header: title, estimatedHeight: estimatedHeight ?? 100)
        return presenter
    }
    
    class func instance(title: String, message: NSAttributedString, estimatedHeight: CGFloat? = 100)-> StatusMessagesPresenter {
        let presenter = StatusMessagesPresenter()
        presenter.messageHeader = SimpleMessageWithHeader.createWith(message: "", header: title, estimatedHeight: estimatedHeight ?? 100)
        presenter.messageHeader.textLabel?.attributedText = message
        return presenter
    }
    
    class func successMessage(title: String, message: String, estimatedHeight: CGFloat? = 100, configure: StatusMessagePresenterConfigure? = nil)->StatusMessagesPresenter {
        let presenter = instance(title: title, message: message, estimatedHeight: estimatedHeight)
        return presenter.configure(callback: { (config, headerView) in
            configure?(config, headerView)
            config.icon = FontIcon.checked
            config.iconSize = 20
            config.topIconColor = UIColor.white
            config.topOvalColor = ColorSet.Success.asColor
        })
    }
    
    class func successMessage(title: String, message: NSAttributedString, estimatedHeight: CGFloat? = 100, configure: StatusMessagePresenterConfigure? = nil)->StatusMessagesPresenter {
        let presenter = instance(title: title, message: message, estimatedHeight: estimatedHeight)
        return presenter.configure(callback: { (config, headerView) in
            config.icon = FontIcon.checked
            config.iconSize = 20
            config.topIconColor = UIColor.white
            config.topOvalColor = ColorSet.Success.asColor
            configure?(config, headerView)
        })
    }
    
    class func warningMessage(title: String, message: String, estimatedHeight: CGFloat? = 100, configure: StatusMessagePresenterConfigure? = nil)->StatusMessagesPresenter {
        let presenter = instance(title: title, message: message, estimatedHeight: estimatedHeight)
        return presenter.configure(callback: { (config, headerView) in
            configure?(config, headerView)
            config.icon = FontIcon.info
            config.iconSize = 20
            config.topIconColor = UIColor.white
            config.topOvalColor = ThemeManager.currentTheme().accentColor
        })
    }
    
    class func warningMessage(title: String, message: NSAttributedString, estimatedHeight: CGFloat? = 100, configure: StatusMessagePresenterConfigure? = nil)->StatusMessagesPresenter {
        let presenter = instance(title: title, message: message, estimatedHeight: estimatedHeight)
        return presenter.configure(callback: { (config, headerView) in
            config.icon = FontIcon.info
            config.iconSize = 20
            config.topIconColor = UIColor.white
            config.topOvalColor = ThemeManager.currentTheme().accentColor
            configure?(config, headerView)
        })
    }
    
    class func errorMessage(title: String, message: String, estimatedHeight: CGFloat? = 100, configure: StatusMessagePresenterConfigure? = nil)->StatusMessagesPresenter {
        let presenter = instance(title: title, message: message, estimatedHeight: estimatedHeight)
        return presenter.configure(callback: { (config, headerView) in
            config.icon = FontIcon.close
            config.iconSize = 20
            config.topIconColor = UIColor.white
            config.topOvalColor = ColorSet.Danger.asColor
            configure?(config, headerView)
        })
    }
    
    class func errorMessage(title: String, message: NSAttributedString, estimatedHeight: CGFloat? = 100, configure: StatusMessagePresenterConfigure? = nil)->StatusMessagesPresenter {
        let presenter = instance(title: title, message: message, estimatedHeight: estimatedHeight)
        return presenter.configure(callback: { (config, headerView) in
            config.icon = FontIcon.close
            config.iconSize = 20
            config.topIconColor = UIColor.white
            config.topOvalColor = ColorSet.Danger.asColor
            configure?(config, headerView)
        })
    }
    
    func configure(callback: StatusMessagePresenterConfigure)-> StatusMessagesPresenter {
        callback(self.config, self.messageHeader)
        return self
    }
    
    func present(buttonText: String? = "Ok", completion: EmptyCallback?) {
        self.config.cancelButtonText = buttonText
        self.callback = completion
        let request = BottomSheetViewController.display(content: self.messageHeader, config: self.config, completion: nil)
        self.dispose = request?.didRemove.subscribe(onNext: { (val) in
            if let call = self.callback {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    call()
                    self.callback = nil
                }
            }
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }, onDisposed: {
            
        })
        self.dispose?.disposed(by: disposeBag)
    }
}
