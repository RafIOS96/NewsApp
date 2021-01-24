//
//  SelectedItemViewController.swift
//  NewsApp
//
//  Created by Raf Aghayan on 21.01.21.
//

import UIKit

class SelectedItemViewController: UIViewController {
    
    @IBOutlet weak var selectedItemImageView: UIImageView!
    @IBOutlet weak var selectedItemCategory: UILabel!
    @IBOutlet weak var selectedItemTitle: UILabel!
    @IBOutlet weak var selectedItemDate: UILabel!
    @IBOutlet weak var videoGalleryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedYouTubeIDMutableArray.isEmpty == true {
            self.videoGalleryButton.isHidden = true
        } else {
            self.videoGalleryButton.isHidden = false
        }
        self.selectedItemCategory.text = newsCategory
        self.selectedItemTitle.text = newsTitle
        self.selectedItemDate.text = newsDateString
        
        self.selectedItemImageView.cacheImage(urlString: "\(newsCoverPhotoUrl)")
            
    }
    
    @IBAction func showGallery(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let photoGallery = storyBoard.instantiateViewController(withIdentifier: "GalleryViewControllerID") as! GalleryViewController
        self.present(photoGallery, animated: true, completion: nil)
    }
    
    @IBAction func showVideoGallery(_ sender: Any) {
        let toVideoTitleList = self.storyboard?.instantiateViewController(withIdentifier: "VideoGalleryListViewControllerID") as! VideoGalleryListViewController
        self.navigationController?.pushViewController(toVideoTitleList, animated: false)
    }
}
