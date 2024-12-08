//
//  UIViewController+Extension.swift
//  QatarPaySDK
//
//  Created by Hussam Elsadany on 15/09/2021.
//

import UIKit

public extension UIViewController {

    private static func genericInstance<T: UIViewController>() -> T {
        return T.init(nibName: String(describing: self), bundle: Bundle(for: self))
    }

    static func instance() -> Self {
        return genericInstance()
    }
}
