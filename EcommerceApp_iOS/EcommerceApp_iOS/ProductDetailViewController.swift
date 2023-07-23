//
//  ProductDetailViewController.swift
//  EcommerceApp_iOS
//
//  Created by Vaibhav Sharma on 19/06/23.
//


import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var imageCarouselView: ImageCarouselView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var btnBookNow: UIButton!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    var product : Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the collection view using the custom view
        imageCarouselView.setupCollectionView()
        if let images = product?.images{
            imageCarouselView.imagesNames = images
        }
        productDescription.numberOfLines = 0
        productDescription.text = product?.description ?? "NA"
        brandName.text = product?.brand ?? ""
        price.text = "$" + "\(product?.price ?? 0)"
        discountPrice.text = "$" + "\(product?.discountPercentage ?? 0)"
        let rate = String(format: "%.1f", product?.rating ?? 0)
        rating.text = [rate, "10"].joined(separator: "/")
        setUpView()
    }
    
    func setUpView() {
        btnBookNow.setTitle("Buy Now", for: .normal)
        btnBookNow.setTitleColor(.white, for: .normal)
        btnBookNow.backgroundColor = .blue
        btnBookNow.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btnBookNow.addTarget(self, action: #selector(bookNow), for: .touchUpInside)
        
    }
    
    @objc func bookNow() {
        showBuySuccessPopup()
        
    }
    
    func showBuySuccessPopup() {
        let alertController = UIAlertController(title: "Order Successful", message: "Your order has been placed successfully.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        // Get the currently visible view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }

}
