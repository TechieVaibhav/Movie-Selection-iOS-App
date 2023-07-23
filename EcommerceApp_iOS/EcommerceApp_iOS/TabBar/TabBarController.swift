//
//  TabBarController.swift
//  EcommerceApp_iOS
//
//  Created by Vaibhav Sharma on 14/06/23.
//

import UIKit

class GradientTabBar: UITabBar {
    private var gradientLayer: CAGradientLayer?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Create the gradient layer if it doesn't exist
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            gradientLayer?.frame = self.bounds
            gradientLayer?.colors = [UIColor.blue.cgColor, UIColor.systemBlue.cgColor]
            
            // Set the gradient direction to bottom to top
            gradientLayer?.startPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer?.endPoint = CGPoint(x: 0.5, y: 0)
            
            // Insert the gradient layer at the bottom of the layer hierarchy
            if let gradientLayer = gradientLayer {
                self.layer.insertSublayer(gradientLayer, at: 0)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update the frame of the gradient layer when the tab bar layout changes
        gradientLayer?.frame = self.bounds
    }
}


class TabBarController: UITabBarController {
    override func loadView() {
        super.loadView()
        
        // Create a custom tab bar
        let gradientTabBar = GradientTabBar()
        setValue(gradientTabBar, forKey: "tabBar")
        setShadowForTabBar()
    }
    
  func setShadowForTabBar() {
        // Set the shadow color
        tabBar.layer.shadowColor = UIColor.black.cgColor
        
        // Set the shadow offset and opacity
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowOpacity = 0.2
        
        // Set the shadow radius
        tabBar.layer.shadowRadius = 10.0
        
        // Set the shadow path
        tabBar.layer.shadowPath = UIBezierPath(rect: tabBar.bounds).cgPath
        
        // Allow the shadow to stretch up to the top
        tabBar.layer.shouldRasterize = true
        tabBar.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        // Iterate through each child view controller
        for viewController in self.viewControllers ?? [] {
            // Check if the view controller is a navigation controller
            if let navigationController = viewController as? UINavigationController {
                // Ensure that the navigation bar is always shown
                navigationController.navigationBar.isHidden = false
            }
        }
        // Ensure that the navigation bar is always shown
            navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    
    }

    
    func setupViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Create view controllers for the tab items
        let firstViewController = storyboard.instantiateViewController(withIdentifier: "CategoryCollectionViewController")
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "MovieListViewController")
        
        // Create navigation controllers and assign the root view controllers
        let firstNavigationController = UINavigationController(rootViewController: firstViewController)
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        firstNavigationController.navigationBar.prefersLargeTitles = false
        firstViewController.title = "Products"
        secondNavigationController.title = "Movies"
        secondNavigationController.navigationBar.prefersLargeTitles = false
        
        
        // Customize the navigation bar appearance
        firstNavigationController.navigationBar.barTintColor = .blue
        firstNavigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ]
        secondNavigationController.navigationBar.barTintColor = .blue
        secondNavigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)
        ]
        
        
        
        // Set the view controllers for the tab bar
        self.viewControllers = [firstNavigationController, secondNavigationController]
        
        // Set titles and images for the tab items
        //UIImage(named: "first_tab_icon")
        firstNavigationController.tabBarItem = UITabBarItem(title: "Products", image: UIImage(systemName: "star.fill"), tag: 0)
        secondNavigationController.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "star.fill"), tag: 1)
    }
    
}
