//
//  AlertHelper.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 20/10/20.
//

import Foundation
import UIKit

struct AlertHelper {
    func checkinAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Checkin realizado.", message: "Seu checkin foi realizado com sucesso", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        return alert
    }
    
    func checkinAlertFailed() -> UIAlertController {
        let alert = UIAlertController(title: "Ops.", message: "Seu checkin não pode ser realizado, favor tentar novamente,", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        return alert
    }
    
    func emptyTextField() -> UIAlertController {
        let alert = UIAlertController(title: "Ops.", message: "Favor preenhcer todos os campos", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}
