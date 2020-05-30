//
//  Extensions.swift
//  DataZoomDemo
//
//  Created by Momcilo Stankovic on 14/05/2020.
//  Copyright © 2020 Momcilo Stankovic. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: Float, green: Float, blue: Float) -> UIColor {
        return UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
    }
}

extension UIView {
    func addConstraintWithFormat(format: String, view: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in view.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
