//
//  UIImageView + extension.swift
//  RecipesAppp
//
//  Created by David on 19/08/23.
//

import UIKit

extension UIImageView {
    private static let imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        if let cachedImage = UIImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }
        
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                    return
                }
                
                UIImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }.resume()
    }
}
