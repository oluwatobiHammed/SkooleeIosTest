//
//  Networking.swift
//  CustomLoginDemo
//
//  Created by Oladipupo Oluwatobi Hammed on 19/05/2020.
//  Copyright © 2020 Christopher Ching. All rights reserved.
//


import Foundation
import Alamofire
//import AlamofireObjectMapper
import ObjectMapper
//import RxAlamofire
import RxSwift
protocol ParameterProvider {
    func provideParameter()-> Parameters
}
