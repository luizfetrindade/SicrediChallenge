//
//  ColorSytem.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 20/10/20.
//

import Foundation
import UIKit

class ColorSystem {
    static var buttonColor: UIColor{
        return UIColor.init(named: "buttonColor") ?? .gray
    }
    
    static var backgroundColor: UIColor{
        return UIColor.init(named: "defaultBackgroundColor") ?? .gray
    }
    
    static var navButtonColor: UIColor{
        return UIColor.init(named: "navButtonColor") ?? .gray
    }
    
    
    func getColor(name: String) -> UIColor{
        return UIColor.init(named: name) ?? .gray
    }
    
}
