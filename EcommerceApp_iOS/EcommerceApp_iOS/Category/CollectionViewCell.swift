//
//  CollectionViewCell.swift
//  EcommerceApp_iOS
//
//  Created by Vaibhav Sharma on 17/06/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    

    let imageCache = NSCache<NSString, UIImage>()
    private var gradientLayer: CAGradientLayer?
      
      override func layoutSubviews() {
          super.layoutSubviews()
          
          // Create the gradient layer if it doesn't exist
          if gradientLayer == nil {
              gradientLayer = CAGradientLayer()
              gradientLayer?.frame = self.contentView.bounds
              gradientLayer?.colors = [UIColor.blue.cgColor, UIColor.systemBlue.cgColor]
              
              // Set the gradient direction to left to right
              gradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
              gradientLayer?.endPoint = CGPoint(x: 1, y: 0.5)
              
              // Insert the gradient layer at the bottom of the layer hierarchy
              if let gradientLayer = gradientLayer {
                  self.contentView.layer.insertSublayer(gradientLayer, at: 0)
              }
          }
          
          // Update the frame of the gradient layer when the cell layout changes
          gradientLayer?.frame = self.contentView.bounds
      }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryLabel.numberOfLines = 0
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        categoryLabel.textColor = .black
    }
    
    func setImage(fromURL url: URL) {
           // Check if the image is available in the cache
           if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
               categoryImage.image = cachedImage
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
                       self.categoryImage.image = image
                   }
               }
           }.resume()
       }
}
