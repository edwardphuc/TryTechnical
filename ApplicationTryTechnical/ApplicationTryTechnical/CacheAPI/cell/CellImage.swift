//
//  CellImage.swift
//  ApplicationTryTechnical
//
//  Created by Edward Lauv on 1/19/21.
//

import UIKit
import Foundation

var cache : NSCache<NSString , UIImage> = {
    let imagecache = NSCache<NSString, UIImage>()
    imagecache.countLimit = 10
    imagecache.totalCostLimit = 50 * 1024 * 1024
    return imagecache
}()

class CellImage: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    var imageInfor : Image? {
        didSet {
//            let memoryCapacity = 500 * 1024 * 1024
//            let disk = 500 * 1024 * 1024
//            let cacheurl = URLCache(memoryCapacity: memoryCapacity, diskCapacity: disk, diskPath: "myDisk")
//            let config = URLSessionConfiguration.default
//            config.urlCache = cacheurl
//            let session = URLSession(configuration: config)
            self.imageView.image = UIImage()
            self.authorLabel.text = ""
            if cache.countLimit > 10 {
                cache.removeAllObjects()
            } else {
                if let imageURL = imageInfor?.download_url {
                    if let imageStatus = cache.object(forKey: imageURL as NSString) {
                        self.imageView.image = imageStatus
                        self.authorLabel.text = self.imageInfor?.author
                    } else {
                        let task = URLSession.shared.dataTask(with: URL(string: imageURL)!) { (data, response, error) in
                            if error != nil {
                                return
                            }
                            //let data = try? Data(contentsOf: imageURL)
                            let image = UIImage(data: data!)
                            cache.setObject(image!, forKey: imageURL as NSString, cost: (image?.pngData()!.count)!)
                            DispatchQueue.main.async {
                                self.imageView.image = image
                                self.authorLabel.text = self.imageInfor?.author
                            }
                        }
                        task.resume()
                    }
            }
                
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    func setupUI() {
        imageView.layer.cornerRadius = 5
    }

}