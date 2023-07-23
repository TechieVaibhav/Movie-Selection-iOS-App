//
//  GradientCollectionView.swift
//  EcommerceApp_iOS
//
//  Created by Vaibhav Sharma on 22/06/23.
//

import Foundation
import UIKit

class GradientCollectionView: UIView {
    private var gradientLayer: CAGradientLayer?

    override func layoutSubviews() {
        super.layoutSubviews()

        // Create the gradient layer if it doesn't exist
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            gradientLayer?.frame = bounds
            gradientLayer?.colors = [UIColor.blue.cgColor, UIColor.systemBlue.cgColor]

            // Set the gradient direction to top to bottom
            gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1)

            // Insert the gradient layer at the bottom of the layer hierarchy
            if let gradientLayer = gradientLayer {
                layer.insertSublayer(gradientLayer, at: 0)
            }
        }
        
        // Update the frame of the gradient layer when the collection view layout changes
        gradientLayer?.frame = bounds
    }
}
