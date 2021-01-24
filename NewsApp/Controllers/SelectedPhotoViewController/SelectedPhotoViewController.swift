//
//  SelectedPhotoViewController.swift
//  NewsApp
//
//  Created by Raf Aghayan on 21.01.21.
//

import UIKit

class SelectedPhotoViewController: UIViewController {

    @IBOutlet weak var selectedPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedPhoto.cacheImage(urlString: "\(selectedImage)")
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
