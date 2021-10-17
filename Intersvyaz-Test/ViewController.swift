//
//  ViewController.swift
//  Intersvyaz-Test
//
//  Created by Stanislav on 12.10.2021.
//

import UIKit

class ViewController: UIViewController {

    var images: [Image] = []
    var fetchingMore = true
    let footerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        collectionView.register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 50)
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
        var tmpImages: [Image] = []
        URLSession.shared.dataTask(with: imageUrl) { data, responce, error in
            if let data = data,
               let photos = try? JSONDecoder().decode([Image].self, from: data){
                tmpImages = photos.prefix(30).map{ Image(url: $0.url, title: $0.title) }
                self.images.append(contentsOf: tmpImages)
                self.fetchingMore.toggle()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            else{
                print("Error: \(String(describing: error?.localizedDescription))")
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
        let width: CGFloat = collectionView.frame.width/3 - 1
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = PhotoViewController()
        viewController.imageURL = URL(string: images[indexPath.item].url)
        viewController.descriptionLabel.text = images[indexPath.item].title
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen        
        self.present(navigationController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footer.addSubview(footerView)
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
            return footer
        }
        return UICollectionReusableView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height{
            if !fetchingMore{
                fetchingMore.toggle()
                footerView.backgroundColor = .gray
                footerView.startAnimating()
                self.downloadImages()
            }
        }
    }
}
