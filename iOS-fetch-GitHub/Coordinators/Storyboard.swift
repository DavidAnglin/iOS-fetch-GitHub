//
//  Storyboard.swift
//  iOS-fetch-GitHub
//
//  Created by David Anglin on 10/9/20.
//

import UIKit

protocol Storyboard {
    static func instantiate() -> Self
}

extension Storyboard where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
