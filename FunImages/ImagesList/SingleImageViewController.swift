//
//  SingleImageViewController.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 13.05.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
