//
//  CarouselView.swift
//  EcommerceApp_iOS
//
//  Created by Vaibhav Sharma on 19/06/23.
//

import Foundation
import UIKit

class ImageCarouselView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    // Add your properties and methods here
    static let kPadding : CGFloat = 0
    var timer: Timer?
    private var pageControl: UIPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Example properties
    var carousel: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = kPadding/2
        layout.minimumInteritemSpacing = kPadding/2
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    var imagesNames: [String]?{
        didSet{
            self.carousel.reloadData()
            self.startTimer()
            self.updatePageControl()
        }
    }
    // This function gets called everytime a layout occurs either to this view or a subview of this view.
    override func layoutSubviews() {
        super.layoutSubviews()
        // Invalidate the carousel to make it lay itself out again.
        self.carousel.collectionViewLayout.invalidateLayout()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(rotateImages), userInfo: nil, repeats: true)
    }
    @objc func rotateImages() {
        guard let images = imagesNames, !images.isEmpty else { return }
        
        let visibleIndexPaths = carousel.indexPathsForVisibleItems
        guard let currentIndexPath = visibleIndexPaths.first else { return }
        
        var nextIndexPath: IndexPath
        
        if currentIndexPath.item == images.count - 1 {
            nextIndexPath = IndexPath(item: 0, section: currentIndexPath.section)
        } else {
            nextIndexPath = IndexPath(item: currentIndexPath.item + 1, section: currentIndexPath.section)
        }
        
        carousel.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    // Example method to set up the collection view
    func setupCollectionView() {
        addSubview(carousel)
        carousel.dataSource = self
        carousel.delegate = self
        carousel.isPagingEnabled = true
        // Register your custom collection view cell
        // Register cell classes
        carousel.register(UINib(nibName: "ImageCell", bundle: .main), forCellWithReuseIdentifier: "ImageCell")
        carousel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carousel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            carousel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            carousel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            carousel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant:0)
        ])
        // Set up the page control
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        updatePageControl()
    }
    
    // Example method to update the page control
    func updatePageControl() {
        pageControl.numberOfPages = self.imagesNames?.count ?? 0
    }
    
    // Implement the necessary collection view data source methods
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesNames?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        guard let imageURL = imagesNames?[indexPath.row] else {
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
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.bounds.width != 0 else {
            return
        }
        
        let contentOffsetX = scrollView.contentOffset.x
        let boundsWidth = scrollView.bounds.width
        
        guard contentOffsetX.isFinite && boundsWidth.isFinite else {
            return
        }
        
        let pageIndex = Int(contentOffsetX / boundsWidth)
        pageControl.currentPage = pageIndex
    }
    
    deinit {
        timer?.invalidate()
    }
}
extension ImageCarouselView : UICollectionViewDelegateFlowLayout{
    
    // MARK: Visual Parameters
    /*
     This function determines the size of the cell for each given indexPath (i.e. section and row).
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    /*
     This function determines the insets (also known as padding) for the collectionview.
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: 0,
            left: ImageCarouselView.kPadding,
            bottom: 0,
            right: ImageCarouselView.kPadding
        )
    }
    
    /*
     This function determines the spacing between items within a section.
     */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ImageCarouselView.kPadding/2
    }
    
    /*
     This function determines the spacing between sections.
     */
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return ImageCarouselView.kPadding
    }
}
