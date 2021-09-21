//
//  EndPointType.swift
//  Optio
//
//  Created by HE on 9/13/18.
//  Copyright © 2018 HE. All rights reserved.
//

import Foundation
import UIKit


protocol EndPointType {
//    var baseURL: String { get }
    var path: ServerPaths { get }
	var pathArgs: [String]? { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

extension EndPointType {
    
    var baseURL: URL {
        guard let url = URL(string: BaseURLConfig.shared.getBaseURL()) else { fatalError("BASEURL could not be configured.")}
        return url
    }
	
	var pathArgs: [String]?  {
		return nil
	}
	
    var requestURL: URL {
        return baseURL.appendingPathComponent(path.rawValue.formatted(with: self.pathArgs))
    }
}


