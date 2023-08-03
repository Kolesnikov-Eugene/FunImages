//
//  AlertPresenter.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 03.08.2023.
//

import UIKit

final class AlertPresenter {
    func show(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
            
        let okAction = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
//        let cancelAction = UIAlertAction(title: "Не надо", style: .default) { [weak self] _ in
//            guard let self = self else { return }
//
//        }
        
        alert.addAction(okAction)
//        alert.addAction(cancelAction)
        
        vc.present(alert, animated: true)
    }
}
