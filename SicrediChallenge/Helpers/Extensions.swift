//
//  Extensions.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 22/10/20.
//

import UIKit

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

extension UIView {
    func addBorder(withColor color: UIColor? = nil, andEdge edge: UIRectEdge = .top, andSize size: CGFloat = 1) -> UIView {
        let border = UIView()
        
        var titleConstraints: [NSLayoutConstraint] = []
        
        switch edge {
        case .top, .bottom:
            titleConstraints = [
                NSLayoutConstraint(item: border,
                                   attribute: .leading,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .leading,
                                   multiplier: 1,
                                   constant: 0),
                NSLayoutConstraint(item: border,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .trailing,
                                   multiplier: 1,
                                   constant: 0),
                NSLayoutConstraint(item: border,
                                   attribute: .height,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1,
                                   constant: size),
            ]
            
            if edge == .top {
                titleConstraints.append(NSLayoutConstraint(item: border,
                                                           attribute: .top,
                                                           relatedBy: .equal,
                                                           toItem: self,
                                                           attribute: .top,
                                                           multiplier: 1,
                                                           constant: 0))
            } else {
                titleConstraints.append(NSLayoutConstraint(item: border,
                                                           attribute: .bottom,
                                                           relatedBy: .equal,
                                                           toItem: self,
                                                           attribute: .bottom,
                                                           multiplier: 1,
                                                           constant: 0))
            }
        case .left, .right:
            titleConstraints = [
                NSLayoutConstraint(item: border,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .top,
                                   multiplier: 1,
                                   constant: 0),
                NSLayoutConstraint(item: border,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .bottom,
                                   multiplier: 1,
                                   constant: 0),
                NSLayoutConstraint(item: border,
                                   attribute: .width,
                                   relatedBy: .equal,
                                   toItem: nil,
                                   attribute: .notAnAttribute,
                                   multiplier: 1,
                                   constant: size),
            ]
            
            if edge == .right {
                titleConstraints.append(NSLayoutConstraint(item: border,
                                                           attribute: .trailing,
                                                           relatedBy: .equal,
                                                           toItem: self,
                                                           attribute: .trailing,
                                                           multiplier: 1,
                                                           constant: 0))
                
            } else {
                titleConstraints.append(NSLayoutConstraint(item: border,
                                                           attribute: .leading,
                                                           relatedBy: .equal,
                                                           toItem: self,
                                                           attribute: .leading,
                                                           multiplier: 1,
                                                           constant: 0))
            }
        default: break
        }
        
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        addConstraints(titleConstraints)
        border.backgroundColor = color ?? .white
        
        return border
    }
}


extension String {
    func keepOnlyDigits(isHexadecimal: Bool) -> String {
        let ucString = uppercased()
        let validCharacters = isHexadecimal ? "0123456789ABCDEFGHIJKLMNOPQRSTUVXYWZ" : "0123456789"
        let characterSet: CharacterSet = CharacterSet(charactersIn: validCharacters)
        let stringArray = ucString.components(separatedBy: characterSet.inverted)
        let allNumbers = stringArray.joined(separator: "")
        return allNumbers
    }
}


// MARK: - NSObject

extension NSObject {
    static var name: String {
        return String(describing: self)
    }
}

