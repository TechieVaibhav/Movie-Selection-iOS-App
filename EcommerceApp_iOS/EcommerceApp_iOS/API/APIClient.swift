//
//  APIClient.swift
//  EcommerceApp_iOS
//
//  Created by Vaibhav Sharma on 19/06/23.
//

import Foundation
import UIKit
import Combine

struct ProductCategoryList: Codable {
    var products : [Product]?
}


struct Product: Codable {
    var id : Int?
    var title : String?
    var description: String?
    var price: Double?
    var discountPercentage: Double?
    var rating : Double?
    var stock: Double?
    var brand: String?
    var category : String?
    var thumbnail : String?
    var images : [String]?
    
}

class APIClient {
    func fetchProducts() -> AnyPublisher<ProductCategoryList, Error> {
        guard let url = URL(string: "https://dummyjson.com/products") else {
            return Fail(error: NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw NSError(domain: "API Error", code: 0, userInfo: nil)
                }
                return data
            }
            .decode(type: ProductCategoryList.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


