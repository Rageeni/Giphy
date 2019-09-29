//
//  ViewController.swift
//  Giphy
//
//  Created by Rageeni Jadam on 29/09/19.
//  Copyright © 2019 Rageeni Jadam. All rights reserved.
//

import UIKit
import GiphyCoreSDK
import PINCache

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collection: UICollectionView!
    var firstGif = [GPHMedia]()
    let API_KEY = "G875ogRR7vhixUFFL24kVuKrz2UHoB69"

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        GiphyCore.configure(apiKey: API_KEY)
        getGifImages()
    }
    
    //MARK:- Gif helper method
    func getGifImages() {
        _ = GiphyCore.shared.trending() { (response, error) in
            self.firstGif = (response?.data)!
            print(self.firstGif)
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
            self.saveGifImagesInCache()
        }
    }
    
    func saveGifImagesInCache() {
        for gif in self.firstGif {
            if !PINCache.shared().containsObject(forKey: gif.id) {
                let img = UIImage.gifImageWithURL("https://media.giphy.com/media/\(gif.id)/giphy.gif") ?? UIImage()
                PINCache.shared().setObject(img, forKey: gif.id)
//                DispatchQueue.main.async {
//                    let visibleIndexPaths = self.collection.indexPathsForVisibleItems
//                    self.collection.reloadItems(at: visibleIndexPaths)
//                }
            }
        }
    }
    
    //MARK:- Coolection View Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return firstGif.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath)
        let gifImage = cell.viewWithTag(100) as! UIImageView
        gifImage.image = (PINCache.shared().object(forKey: firstGif[indexPath.row].id) as? UIImage) ?? UIImage(named: "imgPlaceholder")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 150)
    }
    
    func layout() -> KRLCollectionViewGridLayout {
        return collection!.collectionViewLayout as! KRLCollectionViewGridLayout
    }

    func setLayout() {
        layout().numberOfItemsPerLine = 2
        layout().aspectRatio = 1.2
        layout().sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout().interitemSpacing = 3
        layout().lineSpacing = 3
    }


}

