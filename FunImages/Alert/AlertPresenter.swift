//
//  AlertPresenter.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 03.08.2023.
//

import UIKit

final class AlertPresenter {
    func show(in vc: UIViewController, model: AlertModel, alertHasTwoButtons: Bool) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
            
        let okAction = UIAlertAction(title: model.okButtonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(okAction)
        
        if alertHasTwoButtons {
            guard let text = model.cancelButtonText else { return }
            let cancelAction = UIAlertAction(title: text, style: .default)
            
            alert.addAction(cancelAction)
        }
        
        vc.present(alert, animated: true)
    }
}
