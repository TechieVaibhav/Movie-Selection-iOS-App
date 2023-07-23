//
//  NetworkManager.swift
//  EcommerceApp_iOS
//
//  Created by Vaibhav Sharma on 13/06/23.
//

import Foundation
import UIKit



class NetworkManager{
    private static let categories = [
        "smart-phones",
        "laptops",
        "fragrances",
        "skincare",
        "groceries",
        "home-decoration",
        "furniture",
        "tops",
        "womens-dresses",
        "womens-shoes",
        "mens-shirts",
        "mens-shoes",
        "mens-watches",
        "womens-watches",
        "womens-bags",
        "womens-jewellery",
        "sunglasses",
        "automotive",
        "motorcycle",
        "lighting"
      ]
    
    
    static func fetchProductCategories(onComplition : @escaping (Result<[ProductCategory], Error>) -> Void){
        var products = [ProductCategory]()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            
            for category in categories{
                let image = "https://dummyimage.com/100x100/7851A9/ffffff&text=%20%20\(category.uppercased())%20%20"
            products.append(ProductCategory(name : category,  image: URL(string: image)))
            onComplition(.success(products))
            
            } })
    }
    
    static func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }
}
