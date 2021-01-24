//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Raf Aghayan on 19.01.21.
//

import UIKit
import Alamofire
import CoreData
import Reachability

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
                
    fileprivate var reachability = Reachability()
        
    @IBOutlet weak var newsTable: UITableView!
    
    var arrayCheckedNews: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.array(forKey: "arrayCheckedNews") != nil) {
            self.arrayCheckedNews = UserDefaults.standard.array(forKey: "arrayCheckedNews") as? [Int] ?? []
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
        self.newsTable.delegate = self
        self.newsTable.dataSource = self
        
        getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.newsTable.reloadData()
    }
    
    fileprivate func getNews() {
        if reachability?.connection == .wifi || reachability?.connection == .cellular {
            self.view.showGrayActivityIndicator()
            newsAPICall()
            
        } else {
            let toast = TEToastViewV2(image: UIImage(named: "noInternet"),
                                      title: "No internet connection",
                                      comment: "Loading from cache",
                                      position: .centered)
            toast.present(inSuperview: UIApplication.shared.keyWindow!.rootViewController!.view)
            self.getFromLocalStorage()
            self.newsTable.reloadData()
        }
    }
    
    func getFromLocalStorage() {
        getLocalData()
    
        if titleStringAsData != "" && titleStringAsData != nil {
            let stringAsData = titleStringAsData?.data(using: String.Encoding.utf16)
            let arrayBack: [String] = try! JSONDecoder().decode([String].self, from: stringAsData!)
            titleArray = arrayBack
        }

        if categoryStringAsData != "" && categoryStringAsData != nil {
            let stringAsData = categoryStringAsData?.data(using: String.Encoding.utf16)
            let arrayBack: [String] = try! JSONDecoder().decode([String].self, from: stringAsData!)
            categoryArray = arrayBack
        }

        if dateStringAsData != "" && dateStringAsData != nil {
            let stringAsData = dateStringAsData?.data(using: String.Encoding.utf16)
            let arrayBack: [String] = try! JSONDecoder().decode([String].self, from: stringAsData!)
            dateArray = arrayBack
        }

        if coverPhotoUrlStringAsData != "" && coverPhotoUrlStringAsData != nil{
            let stringAsData = coverPhotoUrlStringAsData?.data(using: String.Encoding.utf16)
            let arrayBack: [String] = try! JSONDecoder().decode([String].self, from: stringAsData!)
            coverPhotoUrlArray = arrayBack
        }

        if galleryLocalArrayString != "" && galleryLocalArrayString != nil{
            let stringAsData = galleryLocalArrayString?.data(using: String.Encoding.utf16)
            let arrayBack: [String] = try! JSONDecoder().decode([String].self, from: stringAsData!)
            galleryLocalArray = arrayBack
            
            for i in 0..<galleryLocalArray.count {
                let test = galleryLocalArray[i] as? String
                let testSecond = test?.data(using: String.Encoding.utf16)
                let arrayBackSecond: [String] = try! JSONDecoder().decode([String].self, from: testSecond!)
                
                testSecondArray = arrayBackSecond
                galleryMutableArray.add(testSecondArray)
            }
        }
        
        testSecondArray.removeAll()
        
        if youTubeIDLocaleArrayString != "" && youTubeIDLocaleArrayString != nil{
            let stringAsData = youTubeIDLocaleArrayString?.data(using: String.Encoding.utf16)
            let arrayBack: [String] = try! JSONDecoder().decode([String].self, from: stringAsData!)
            youTubeIDLocaleArray = arrayBack
            
            for i in 0..<youTubeIDLocaleArray.count {
                let test = youTubeIDLocaleArray[i] as? String
                let testSecond = test?.data(using: String.Encoding.utf16)
                let arrayBackSecond: [String] = try! JSONDecoder().decode([String].self, from: testSecond!)
                
                testSecondArray = arrayBackSecond
                youTubeIDMutableArray.add(testSecondArray)
            }
        }
        
        testSecondArray.removeAll()
        
        if videoGalleryLocalArrayString != "" && videoGalleryLocalArrayString != nil{
            let stringAsData = videoGalleryLocalArrayString?.data(using: String.Encoding.utf16)
            let arrayBack: [String] = try! JSONDecoder().decode([String].self, from: stringAsData!)
            videoGalleryLocalArray = arrayBack
            
            for i in 0..<videoGalleryLocalArray.count {
                let test = videoGalleryLocalArray[i] as? String
                let testSecond = test?.data(using: String.Encoding.utf16)
                let arrayBackSecond: [String] = try! JSONDecoder().decode([String].self, from: testSecond!)
                
                testSecondArray = arrayBackSecond
                videoGalleryMutableArray.add(testSecondArray)
            }
        }
    }
    
    func newsAPICall() {
        AF.request(newsUrl).responseJSON { (response) in
            if let responseValue = response.value as! [String: Any]? {
                if responseValue["success"] as? Bool == true {

                    newsArray = responseValue["metadata"] as! [Any]
                    
                    galleryMutableArray.removeAllObjects()
                    youTubeIDMutableArray.removeAllObjects()

                    for j in 0..<newsArray.count {
                        newsDictionary = newsArray[j] as? NSDictionary
                        newsCategory = newsDictionary.object(forKey: "category") as? String ?? ""
                        newsTitle = newsDictionary.object(forKey: "title") as? String ?? ""
                        newsDate = newsDictionary.object(forKey: "date") as? Int
                        newsCoverPhotoUrl = newsDictionary.object(forKey: "coverPhotoUrl") as? String ?? ""
                                                
                        photoGalleryArray = newsDictionary.object(forKey: "gallery") as? [Any] ?? []
                        
                        contentUrlArray.removeAll()
                        
                        for i in 0..<photoGalleryArray.count {
                            contentUrlDictionary = photoGalleryArray[i] as? NSDictionary
                            contentUrl = contentUrlDictionary.object(forKey: "contentUrl") as? String ?? ""
                            contentUrlArray.append(contentUrl)
                        }
                        
                        let date = NSDate(timeIntervalSince1970: TimeInterval(newsDate ?? 0))
                        let dayTimePeriodFormatter = DateFormatter()
                        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY"
                        let dateString = dayTimePeriodFormatter.string(from: date as Date)
                                                
                        videoGalleryArray = newsDictionary.object(forKey: "video") as? [Any] ?? []
                        
                        youTubeIDArray.removeAll()
                        videoGalleryTitleArray.removeAll()
                        
                        for i in 0..<videoGalleryArray.count {
                            videoUrlDictionary = videoGalleryArray[i] as? NSDictionary
                            youTubeId = videoUrlDictionary.object(forKey: "youtubeId") as? String ?? ""
                            videoGalleryTitle = videoUrlDictionary.object(forKey: "title") as? String ?? ""
                            youTubeIDArray.append(youTubeId)
                            videoGalleryTitleArray.append(videoGalleryTitle)
                        }
                        
                        categoryArray.append(newsCategory)
                        titleArray.append(newsTitle)
                        dateArray.append(dateString)
                        coverPhotoUrlArray.append(newsCoverPhotoUrl)
                        
                        
                        galleryLocalArray.append(contentUrlArray.description)
                        youTubeIDLocaleArray.append(youTubeIDArray.description)
                        videoGalleryLocalArray.append(videoGalleryTitleArray.description)
                        
                        galleryMutableArray.add(contentUrlArray)
                        youTubeIDMutableArray.add(youTubeIDArray)
                        videoGalleryMutableArray.add(videoGalleryTitleArray)
                    }
                    
                    
                    self.saveInLocalStorage()
                    self.view.removeGrayActivityIndicator()
                    self.newsTable.reloadData()
                }
            }
        }
    }
    
    func saveInLocalStorage() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)
        let newEntity = NSManagedObject(entity: entity!, insertInto: context)
                
        newEntity.setValue(titleArray.description, forKey: "titleArrayAsString")
        newEntity.setValue(dateArray.description, forKey: "dateArrayAsString")
        newEntity.setValue(categoryArray.description, forKey: "categoryArrayAsString")
        newEntity.setValue(coverPhotoUrlArray.description, forKey: "coverPhotoArrayAsString")
        
        newEntity.setValue(galleryLocalArray.description, forKey: "galleryMutableArrayAsString")
        newEntity.setValue(youTubeIDLocaleArray.description, forKey: "youTubeIDMutableArrayAsString")
        newEntity.setValue(videoGalleryLocalArray.description, forKey: "videoGalleryMutableArrayAsString")
        
        do {
            try context.save()
            print("saved")
        } catch  {
            print("error")
        }
    }
    
    func getLocalData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                titleStringAsData = data.value(forKey: "titleArrayAsString") as? String ?? ""
                dateStringAsData = data.value(forKey: "dateArrayAsString") as? String ?? ""
                categoryStringAsData = data.value(forKey: "categoryArrayAsString") as? String ?? ""
                coverPhotoUrlStringAsData = data.value(forKey: "coverPhotoArrayAsString") as? String ?? ""
                galleryLocalArrayString = data.value(forKey: "galleryMutableArrayAsString") as? String ?? ""
                youTubeIDLocaleArrayString = data.value(forKey: "youTubeIDMutableArrayAsString") as? String ?? ""
                videoGalleryLocalArrayString = data.value(forKey: "videoGalleryMutableArrayAsString") as? String ?? ""
                break
            }
        } catch  {
            print(" error load")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsTableViewCell
        cell.newsCategory.text = categoryArray[indexPath.row] as? String
        cell.newsTitle.text = titleArray[indexPath.row] as? String
        cell.newsDate.text = dateArray[indexPath.row] as? String
        cell.newsImage.cacheImage(urlString: "\(coverPhotoUrlArray[indexPath.row])")
        
        if arrayCheckedNews.count != 0 {
            if arrayCheckedNews.contains(indexPath.row) {
                cell.checkButton.isSelected = true
            } else {
                cell.checkButton.isSelected = false
            }
        }
        
        return cell
    }
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsCategory = categoryArray[indexPath.row] as? String ?? ""
        newsTitle = titleArray[indexPath.row] as? String ?? ""
        newsDateString = dateArray[indexPath.row] as? String ?? ""
        newsCoverPhotoUrl = coverPhotoUrlArray[indexPath.row] as? String ?? ""
        selecedGalleryMutableArray = galleryMutableArray[indexPath.row] as? [Any] ?? [""]
        selectedYouTubeIDMutableArray = youTubeIDMutableArray[indexPath.row] as? [Any] ?? [""]
        selectedVdeoTitleMutavleArray = videoGalleryMutableArray[indexPath.row] as? [Any] ?? [""]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsTableViewCell
        
        if arrayCheckedNews.contains(indexPath.row) == false {
            arrayCheckedNews.append(indexPath.row)
            UserDefaults.standard.set(arrayCheckedNews, forKey: "arrayCheckedNews")
        }

        let toSelectedItemPage = self.storyboard?.instantiateViewController(withIdentifier: "SelectedItemViewControllerID") as!
            SelectedItemViewController
        self.navigationController?.pushViewController(toSelectedItemPage, animated: false)
    }
    
    @objc func appDidBecomeActive() {
        self.newsTable.backgroundColor = UIColor(netHex: 0xf2f2f2)
    }
}

