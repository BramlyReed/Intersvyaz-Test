//
//  ViewController.swift
//  Intersvyaz-Test
//
//  Created by Stanislav on 12.10.2021.
//

import UIKit

class ViewController: UIViewController {

    var images: [Image] = []

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Gallery"
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupconstraint()
        downloadImages()
    }

    func setupconstraint(){
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func downloadImages(){
        guard let imageUrl = URL(string: "http://jsonplaceholder.typicode.com/photos") else{
            return
        }
        URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
            if let data = data,
               let photos = try? JSONDecoder().decode([Image].self, from: data){
                self.images = photos.prefix(42).map{ Image(url: $0.url, title: $0.title) }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }.resume()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageURL = URL(string: images[indexPath.item].url)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let Width: CGFloat = collectionView.frame.width/3 - 1
        return CGSize(width: Width, height: Width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
        let viewController = PhotoViewController()
        viewController.imageURL = URL(string: images[indexPath.item].url)
        viewController.descriptionLabel.text = images[indexPath.item].title
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve

        print(images[indexPath.item])
        self.present(navigationController, animated: true)

    }
}








