//
//  ViewController.swift
//  Giphy
//
//  Created by Rageeni Jadam on 29/09/19.
//  Copyright © 2019 Rageeni Jadam. All rights reserved.
//

import UIKit
import GiphyCoreSDK

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collection: UICollectionView!
    let API_KEY = "G875ogRR7vhixUFFL24kVuKrz2UHoB69"
    var gifImages: [String: UIImage] = [:]
    var gifUrls: [String] = []

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
            guard error == nil else {
                return
            }
            if let response = response, let data = response.data {
                for result in data {
                    if let urlStr = result.images?.downsized?.gifUrl {
                        self.gifUrls.append(urlStr)
                    }
                }
                if !self.gifUrls.isEmpty {
                    DispatchQueue.main.async {
                        self.collection.reloadData()
                    }
                }
            } else {
                print("No Results Found")
            }
        }
    }
    
    //MARK:- Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifCell", for: indexPath)
        let uniqueId = Int.random(in: Int.min...Int.max)
        cell.tag = uniqueId
        
        let gifImage = cell.viewWithTag(100) as! UIImageView
        let activityIndicator = cell.viewWithTag(101) as! UIActivityIndicatorView
        
        if let image = gifImages[gifUrls[indexPath.item]] {
            gifImage.image = image
            activityIndicator.isHidden = true
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            DispatchQueue.global(qos: .default).async {
                let gifImageP = UIImage.gifImageWithURL(self.gifUrls[indexPath.row])
                DispatchQueue.main.async {
                    if cell.tag == uniqueId {
                        activityIndicator.stopAnimating()
                        activityIndicator.isHidden = true
                        gifImage.image = gifImageP
                        self.gifImages[self.gifUrls[indexPath.item]] = gifImageP
                    }
                }
            }
        }
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
