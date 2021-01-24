//
//  GalleryViewController.swift
//  NewsApp
//
//  Created by Raf Aghayan on 21.01.21.
//

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var galleryCollectionView:
        UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.galleryCollectionView.delegate = self
        self.galleryCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selecedGalleryMutableArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GalleryViewCell
        cell.galleryImage.cacheImage(urlString: "\(selecedGalleryMutableArray[indexPath.row])")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = selecedGalleryMutableArray[indexPath.row] as? String ?? ""
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedPhoto = storyBoard.instantiateViewController(withIdentifier: "SelectedPhotoViewControllerID") as! SelectedPhotoViewController
        self.present(selectedPhoto, animated: true, completion: nil)
        return
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
