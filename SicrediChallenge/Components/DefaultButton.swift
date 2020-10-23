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

    private func setup() {
        layer.backgroundColor = backgroundColor?.cgColor
        backgroundColor = backGroundColor
        setTitleColor(.white, for: .normal)
    }
}

