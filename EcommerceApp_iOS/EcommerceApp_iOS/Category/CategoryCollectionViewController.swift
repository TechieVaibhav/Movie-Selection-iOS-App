//
//  CategoryCollectionViewController.swift
//  EcommerceApp_iOS
//
//  Created by Vaibhav Sharma on 13/06/23.
//

import UIKit
import Combine

private let reuseIdentifier = "CollectionViewCell"
private let sectionInsets = UIEdgeInsets(top: 10,
                                         left: 10,
                                         bottom: 10,
                                         right: 10)
private let itemsPerRow: CGFloat = 3


class CategoryCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var products : [Product]?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // Register cell classes
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CollectionViewCell")
        fetchProductList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    func fetchProductList() {
        // Usage example
        let apiClient = APIClient()
        apiClient.fetchProducts()
            .sink { completion in
                switch completion {
                case .finished:
                    print("API request completed.")
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print("API request failed with error: \(error)")
                }
            } receiveValue: { products in
                print("Received products: \(products)")
                self.products = products.products
            }
            .store(in: &cancellables)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        // Configure the cell
        cell.categoryLabel.text = products?[indexPath.row].category ?? ""
        // Get the image URL for the cell at the current index path
        guard let imageURL = products?[indexPath.row].thumbnail else {
            return cell
        }
        // Download the image from the URL
        if let imageUrl = URL(string: imageURL){
            cell.setImage(fromURL: imageUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if let productDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailViewController") as? ProductDetailViewController{
            productDetailVC.product = products?[indexPath.row]
            self.navigationController?.pushViewController(productDetailVC, animated: false)
        }
       
    }
}
extension CategoryCollectionViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            let heightPerItem = widthPerItem + 40
            return CGSize(width: widthPerItem, height: heightPerItem)
            
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
