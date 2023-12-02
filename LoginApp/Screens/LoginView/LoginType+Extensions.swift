//
//  LoginType+Extensions.swift
//  LoginApp
//
//  Created by tungaptive on 30/11/2023.
//

import Foundation
import UIKit
import SnapKit

extension LoginType {
    func created() -> UIView {
        switch self {
        case .button(let label):
            let button = UIButton()
            button.setTitle(label, for: .normal)
            button.roundCorners(12)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.snp.makeConstraints { make in
                make.height.equalTo(56)
            }
            return button
        case .email:
            return createTextField(padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        case .password:
            return createTextField(padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 90))
        }
    }
    
    private func createTextField(padding: UIEdgeInsets) -> TextField {
        let textField = TextField(padding: padding)
        textField.isSecureTextEntry = isSecure
        textField.placeholder = placeHolder
        textField.backgroundColor = .gray
        textField.textColor = .white
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.font = .boldSystemFont(ofSize: 17)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        textField.roundCorners(12)
        textField.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        return textField
    }
}
