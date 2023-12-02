//
//  UIView+Extensions.swift
//  SurveyApp
//
//  Created by tungaptive on 30/11/2023.
//

import Foundation
import UIKit

extension UIView {
    public func roundCorners(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
