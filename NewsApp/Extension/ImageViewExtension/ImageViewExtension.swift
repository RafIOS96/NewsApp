//
//  ImageViewExtension.swift
//  NewsApp
//
//  Created by Raf Aghayan on 20.01.21.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func cacheImage(urlString: String){
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
            
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
              if let response = data {
                  DispatchQueue.main.async {
                      let imageToCache = UIImage(data: data!)
                      imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                      self.image = imageToCache
                  }
              }
         }.resume()
      }
}
