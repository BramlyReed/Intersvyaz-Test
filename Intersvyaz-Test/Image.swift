//
//  Image.swift
//  Intersvyaz-Test
//
//  Created by Stanislav on 15.10.2021.
//

import Foundation
import UIKit

struct Image: Decodable{
    var url: String
    var title: String
    
    init(url: String, title: String){
        self.url = url
        self.title = title
    }
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case title = "title"
    }
}
