//
//  CollectionViewCell.swift
//  Intersvyaz-Test
//
//  Created by Stanislav on 12.10.2021.
//

import UIKit
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    
    var img: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        return img
    }()
    
    var imageURL: URL?{
        didSet{
            img.sd_setImage(with: imageURL, placeholderImage: nil)
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(img)
        img.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        img.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        img.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        img.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
