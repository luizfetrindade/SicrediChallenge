//
//  DefaultButton.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 20/10/20.
//

import Foundation
import UIKit

@IBDesignable
class DefaultButton: UIButton {

    private var backGroundColor = ColorSystem.buttonColor
    

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        setRadiusWithShadow(4, shadow: 1, shadowOp: 0.5)
    }

    func setup() {
        layer.backgroundColor = backgroundColor?.cgColor
        backgroundColor = backGroundColor
        setTitleColor(.white, for: .normal)
    }
}

extension UIView {
    func setRadiusWithShadow(_ radius: CGFloat? = nil, shadow: CGFloat? = nil, shadowOp: Float? = nil) {
        layer.cornerRadius = radius ?? 4
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        layer.shadowRadius = shadow ?? 1.0
        layer.shadowOpacity = shadowOp ?? 0.7
        layer.masksToBounds = false
    }
}
