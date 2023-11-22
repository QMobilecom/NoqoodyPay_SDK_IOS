//
//  HTTPTask.swift
//  Optio
//
//  Created by HE on 9/13/18.
//  Copyright © 2018 HE. All rights reserved.
//

import Foundation
import UIKit

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
        
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
}
