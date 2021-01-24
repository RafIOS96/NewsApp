//
//  VideoGalleryListViewController.swift
//  NewsApp
//
//  Created by Raf Aghayan on 23.01.21.
//

import UIKit

class VideoGalleryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var videoGalleryList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.videoGalleryList.delegate = self
        self.videoGalleryList.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedVdeoTitleMutavleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoGalleryListCell
        cell.videoGalleryListTitle.text = selectedVdeoTitleMutavleArray[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVideo = selectedYouTubeIDMutableArray[indexPath.row] as? String ?? ""
        let toVideoPage = self.storyboard?.instantiateViewController(withIdentifier: "VideoGalleryViewControllerID") as! VideoGalleryViewController
        self.navigationController?.pushViewController(toVideoPage, animated: false)
    }
}
