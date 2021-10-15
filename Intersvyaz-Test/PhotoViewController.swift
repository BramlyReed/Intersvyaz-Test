//
//  PhotoViewController.swift
//  Intersvyaz-Test
//
//  Created by Stanislav on 12.10.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var img: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        img.isUserInteractionEnabled = true
        return img
    }()
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = false
        return label
    }()
    var imageURL: URL?{
        didSet{
            img.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "maralin"))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(img)
        view.addSubview(descriptionLabel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад",
            style: .done, target: self, action: #selector(closePhotoViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Поделиться",
            style: .done, target: self, action: #selector(shareImage))
        setUpImageViewAndDescriptionLabel()
    }
    
    func setUpImageViewAndDescriptionLabel(){
        img.frame = view.bounds
        descriptionLabel.frame = CGRect(x: 20, y: view.frame.height - 50, width: view.frame.width - 40, height: 21)
    }
    
    @objc func shareImage() {
        let array: [Any] = [descriptionLabel.text, img.image]
        let shareController = UIActivityViewController(activityItems: array, applicationActivities: nil)
        var title = "Ошибка"
        var message = "Операция не выполнена"
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool{
                print("Image was send successful")
                title = "Успешно"
                message = "Операция выполнена"
            }
            else{
                print("Something went wrong")
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        present(shareController, animated: true)
    }
    
    @objc func closePhotoViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
