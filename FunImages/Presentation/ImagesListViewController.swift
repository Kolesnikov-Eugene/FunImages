//
//  ViewController.swift
//  FunImages
//
//  Created by Eugene Kolesnikov on 01.05.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    private let imagesName: [String] = Array(0..<20).map{ "\($0)" }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

// MARK: - TableView Data Source
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)

        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let imageName = imagesName[indexPath.row]
        guard let image = UIImage(named: imageName) else { return }
        
        cell.imageForCell?.image = image
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let likeIsOn = indexPath.row % 2 == 0
        let cellLikeButttonImage = likeIsOn ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(cellLikeButttonImage, for: .normal)
        addGradient(for: cell)
    }
    
    func addGradient(for cell: ImagesListCell) {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: cell.contentView.bounds.width, height: 30)
        view.backgroundColor = .clear

        let gradientlayer = CAGradientLayer()
        gradientlayer.colors = [
          UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor,
          UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.2).cgColor
        ]
        gradientlayer.locations = [0, 1]
        gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientlayer.frame = view.bounds
        gradientlayer.position = view.center
        view.layer.addSublayer(gradientlayer)

        let parent = cell.contentView
        parent.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: 0).isActive = true
    }
}
// MARK: - TableView Delegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: imagesName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

