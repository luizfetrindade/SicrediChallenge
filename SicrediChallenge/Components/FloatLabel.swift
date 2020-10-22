
//  FloatLabel.swift
//  GarupaMotorista
//
//  Created by Luiz Felipe Trindade on 12/06/20.
//  Copyright © 2020 Luiz Felipe Trindade. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol FloatLabelDelegate {
    @objc optional func textFieldShouldReturn(_ textField: UITextField) -> Bool
    @objc optional func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    @objc optional func textFieldDidEndEditing(_ textField: UITextField)
    @objc optional func textDidChange(_ textField: UITextField)
}

public class FloatLabel: UITextField, UITextFieldDelegate {
    @IBOutlet open weak var floatLabelDelegate: FloatLabelDelegate?

    @IBInspectable public var placeholderColor: UIColor = .gray {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }

    @IBInspectable public var topSpacingFromPlaceholder: CGFloat = 6
    @IBInspectable public var leftSpacing: CGFloat = 8
    @IBInspectable public var rightSpacing: CGFloat = 8

    @IBInspectable public var placeholderCustomFontName: String!
    @IBInspectable public var placeholderEditingFontSize: CGFloat = 0

    @IBInspectable public var addBorder: Bool = false
    @IBInspectable public var borderHeight: CGFloat = 1
    @IBInspectable public var borderColor: UIColor = #colorLiteral(red: 0.1469763815, green: 0.6874579787, blue: 0.6109827757, alpha: 1) {
        didSet {
            bottomBorder.backgroundColor = borderColor
            topBorder.backgroundColor = borderColor
            leftBorder.backgroundColor = borderColor
            rightBorder.backgroundColor = borderColor
        }
    }

    @IBInspectable public var icon: UIImage? {
        didSet {
            imageViewIcon.image = icon
        }
    }

    @IBInspectable public var iconAtTrailing: Bool = true
    @IBInspectable public var iconSpacing: CGFloat = 8
    @IBInspectable public var iconWidth: CGFloat = 12
    @IBInspectable public var iconHeight: CGFloat = 12

    @IBInspectable public var onlyNumbers: Bool = false

    override public var text: String? {
        set {
            super.text = newValue
            textDidChange()
            if text != "" {
                _ = textFieldShouldBeginEditing(self)
            }
        }
        get {
            if case .noFormatting = formatting {
                return super.text
            } else {
                textDidChange()
                return finalStringWithoutFormatting
            }
        }
    }

    private var placeholderNew: String? {
        didSet {
            placeholderLabel.text = placeholderNew
            placeholder = nil
        }
    }

    private var bottomBorder: UIView = UIView()
    private var topBorder: UIView = UIView()
    private var leftBorder: UIView = UIView()
    private var rightBorder: UIView = UIView()
    private var imageViewIcon = UIImageView()
    private var yConstraint: NSLayoutConstraint?
    private var customSize: CGFloat? { return placeholderEditingFontSize == 0 ? nil : placeholderEditingFontSize }
    var placeholderLabel = PaddingLabel()
    // MASK
    private enum TextFieldFormatting {
        case custom
        case noFormatting
    }

    private var formattingPattern: String = "" {
        didSet {
            self.maxLength = formattingPattern.count
        }
    }

    private var replacementChar: Character = "*"
    private var secureTextReplacementChar: Character = "\u{25cf}"
    private var maxLength = 0
    private var formatting: TextFieldFormatting = .noFormatting {
        didSet {
            switch formatting {
            default:
                maxLength = 0
            }
        }
    }

    private var finalStringWithoutFormatting: String {
        return _textWithoutSecureBullets.keepOnlyDigits(isHexadecimal: !onlyNumbers)
    }

    public var formatedSecureTextEntry: Bool {
        set {
            _formatedSecureTextEntry = newValue
            super.isSecureTextEntry = false
        }
        get {
            return _formatedSecureTextEntry
        }
    }

    // MARK: - INTERNAL

    private var _formatedSecureTextEntry = false
    private var _textWithoutSecureBullets = ""
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: NSNotification.Name(rawValue: "UITextFieldTextDidChangeNotification"),
                                               object: self)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        delegate = self
        registerForNotifications()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        delegate = self
        registerForNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override public func awakeFromNib() {
        commonInit()
    }

    override public func draw(_: CGRect) {}

    private func commonInit() {
        if addBorder {
            bottomBorder = addBorder(withColor: borderColor, andEdge: .bottom, andSize: borderHeight)
            topBorder = addBorder(withColor: borderColor, andEdge: .top, andSize: borderHeight)
            leftBorder = addBorder(withColor: borderColor, andEdge: .left, andSize: borderHeight)
            rightBorder = addBorder(withColor: borderColor, andEdge: .right, andSize: borderHeight)
        }

        if placeholder != nil {
            placeholderNew = placeholder
        }

        setupPlaceholderLabel()
        setupIcon()
    }

    private func setupPlaceholderLabel() {
        yConstraint = NSLayoutConstraint(item: placeholderLabel,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)

        let titleConstraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: placeholderLabel,
                               attribute: .leading,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .leading,
                               multiplier: 1,
                               constant: leftSpacing),
            yConstraint!,
        ]

        placeholderLabel.backgroundColor = UIColor(named: "defaultBackgroundColor")
        placeholderLabel.numberOfLines = 0
        placeholderLabel.textAlignment = .left
        placeholderLabel.text = placeholderNew
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.sizeToFit()

        let fontSize = font?.pointSize ?? UIFont.systemFontSize
        let fontName = placeholderCustomFontName ?? font?.familyName ?? UIFont.systemFont(ofSize: 12).familyName
        placeholderLabel.font = UIFont(name: fontName, size: fontSize)
        placeholderLabel.textColor = placeholderColor

        if text != "" {
            _ = textFieldShouldBeginEditing(self)
        }

        placeholder = ""
        addSubview(placeholderLabel)
        addConstraints(titleConstraints)
        sendSubviewToBack(placeholderLabel)
        sendSubviewToBack(topBorder)
    }

    private func setupIcon() {
        guard let icon = icon else { return }
        let alignConstraint: NSLayoutConstraint

        if iconAtTrailing {
            alignConstraint = NSLayoutConstraint(item: imageViewIcon,
                                                 attribute: .trailing,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .trailing,
                                                 multiplier: 1,
                                                 constant: -iconSpacing)
        } else {
            alignConstraint = NSLayoutConstraint(item: imageViewIcon,
                                                 attribute: .leading,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .leading,
                                                 multiplier: 1,
                                                 constant: iconSpacing)
        }

        let titleConstraints: [NSLayoutConstraint] = [
            NSLayoutConstraint(item: imageViewIcon,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: imageViewIcon,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: iconWidth),
            NSLayoutConstraint(item: imageViewIcon,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: nil,
                               attribute: .notAnAttribute,
                               multiplier: 1,
                               constant: iconHeight),
            alignConstraint,
        ]

        imageViewIcon.contentMode = .scaleAspectFit
        imageViewIcon.translatesAutoresizingMaskIntoConstraints = false
        imageViewIcon.sizeToFit()
        imageViewIcon.image = icon

        addSubview(imageViewIcon)
        addConstraints(titleConstraints)
        sendSubviewToBack(imageViewIcon)
    }

    public func setFormatting(_ formattingPattern: String, replacementChar: Character) {
        self.formattingPattern = formattingPattern
        self.replacementChar = replacementChar
        formatting = .custom
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        layoutIfNeeded()
        borderColor = #colorLiteral(red: 0.1469763815, green: 0.6874579787, blue: 0.6109827757, alpha: 1)
        placeholderColor = #colorLiteral(red: 0.1254901961, green: 0.6078431373, blue: 0.5254901961, alpha: 1)
        

        UIView.animate(withDuration: 0.2) {
            let fontSize = self.customSize ?? self.font?.pointSize ?? UIFont.systemFontSize
            let fontName = self.placeholderCustomFontName ?? self.font?.familyName ?? UIFont.systemFont(ofSize: 12).familyName
            self.placeholderLabel.font = UIFont(name: fontName, size: fontSize)

            self.yConstraint?.constant = -self.topSpacingFromPlaceholder - 6
            self.layoutIfNeeded()
        }

        return floatLabelDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        if text!.count <= 0 {
            layoutIfNeeded()

            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                let fontSize = self.font?.pointSize ?? UIFont.systemFontSize
                let fontName = self.placeholderCustomFontName ?? self.font?.familyName ?? UIFont.systemFont(ofSize: 12).familyName
                self.placeholderLabel.font = UIFont(name: fontName, size: fontSize)

                self.yConstraint?.constant = 0
                self.layoutIfNeeded()
            })
        }

        floatLabelDelegate?.textFieldDidEndEditing?(textField)

        if text!.isEmpty {
            borderColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
            placeholderColor = #colorLiteral(red: 0.6588235294, green: 0.6588235294, blue: 0.6588235294, alpha: 1)
        }
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + leftSpacing,
                      y: bounds.origin.y + 0,
                      width: bounds.width - rightSpacing,
                      height: bounds.height)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + leftSpacing,
                      y: bounds.origin.y + 0,
                      width: bounds.width - rightSpacing,
                      height: bounds.height)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _ = floatLabelDelegate?.textFieldShouldReturn?(textField)
        return true
    }

    @objc public func textDidChange() {
        var superText: String { return super.text ?? "" }
        floatLabelDelegate?.textDidChange?(self)

        let currentTextForFormatting: String

        if superText.count > _textWithoutSecureBullets.count {
            currentTextForFormatting = _textWithoutSecureBullets + superText[superText.index(superText.startIndex, offsetBy: _textWithoutSecureBullets.count)...]
        } else if superText.count == 0 {
            _textWithoutSecureBullets = ""
            currentTextForFormatting = ""
        } else {
            currentTextForFormatting = String(_textWithoutSecureBullets[..<_textWithoutSecureBullets.index(_textWithoutSecureBullets.startIndex, offsetBy: superText.count)])
        }

        if formatting != .noFormatting, currentTextForFormatting.count > 0, formattingPattern.count > 0 {
            let tempString = currentTextForFormatting.keepOnlyDigits(isHexadecimal: !onlyNumbers)

            var finalText = ""
            var finalSecureText = ""

            var stop = false

            var formatterIndex = formattingPattern.startIndex
            var tempIndex = tempString.startIndex

            while !stop {
                let formattingPatternRange = formatterIndex ..< formattingPattern.index(formatterIndex, offsetBy: 1)
                if formattingPattern[formattingPatternRange] != String(replacementChar) {
                    finalText = finalText + formattingPattern[formattingPatternRange]
                    finalSecureText = finalSecureText + formattingPattern[formattingPatternRange]

                } else if tempString.count > 0 {
                    let pureStringRange = tempIndex ..< tempString.index(tempIndex, offsetBy: 1)

                    finalText = finalText + tempString[pureStringRange]

                    // we want the last number to be visible
                    if tempString.index(tempIndex, offsetBy: 1) == tempString.endIndex {
                        finalSecureText = finalSecureText + tempString[pureStringRange]
                    } else {
                        finalSecureText = finalSecureText + String(secureTextReplacementChar)
                    }

                    tempIndex = tempString.index(after: tempIndex)
                }

                formatterIndex = formattingPattern.index(after: formatterIndex)

                if formatterIndex >= formattingPattern.endIndex || tempIndex >= tempString.endIndex {
                    stop = true
                }
            }

            _textWithoutSecureBullets = finalText

            let newText = _formatedSecureTextEntry ? finalSecureText : finalText
            if newText != superText {
                super.text = _formatedSecureTextEntry ? finalSecureText : finalText
            }
        }

        // Let's check if we have additional max length restrictions
        if maxLength > 0 {
            if superText.count > maxLength {
                super.text = String(superText[..<superText.index(superText.startIndex, offsetBy: maxLength)])
                _textWithoutSecureBullets = String(_textWithoutSecureBullets[..<_textWithoutSecureBullets.index(_textWithoutSecureBullets.startIndex, offsetBy: maxLength)])
            }
        }
    }
}


// Helpers
private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

