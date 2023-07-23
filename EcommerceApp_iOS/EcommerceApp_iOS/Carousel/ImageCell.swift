//
//  ImageCell.swift
//  EcommerceApp_iOS
//
//  Created by Vaibhav Sharma on 20/06/23.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    let imageCache = NSCache<NSString, UIImage>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    /*
     This function gets called when a cell gets removed from the collectionview
     and should remove all callbacks or data that could get held in memory.
     
     For example: Set all callbacks & images to nil and set all text to "".
     */
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setImage(fromURL url: URL) {
        // Check if the image is available in the cache
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            image.image = cachedImage
            return
        }
        
        // Image is not in cache, so download it asynchronously
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let self = self, let data = data, error == nil else {
                return
            }
            
            // Create UIImage from downloaded data
            if let image = UIImage(data: data) {
                // Store the image in the cache
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    // Set the image in the image view
                    self.image.image = image
                }
            }
        }.resume()
    }
}
