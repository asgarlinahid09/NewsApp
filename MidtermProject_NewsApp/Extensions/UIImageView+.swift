//
//  UIImageView+.swift
//  MidtermProject_NewsApp
//
//  Created by Nahid Askerli on 29.08.25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func downloadImage(from url: String){
        guard let url = URL(string: url) else {return}
//        URLSession.shared.dataTask(with: url) { data, _, _ in
//            if let data = data {
//                let image = UIImage(data: data)
//                DispatchQueue.main.async {
//                    self.image = image
//                }
//            }
//        }.resume()
        self.kf.setImage(with: url,placeholder: UIImage(named: "placeholder"))
    }
    
}

