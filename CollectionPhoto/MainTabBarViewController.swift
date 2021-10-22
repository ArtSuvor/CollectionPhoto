//
//  MainTabBarViewController.swift
//  CollectionPhoto
//
//  Created by Art on 22.10.2021.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
//MARK: - Properties
    
    private let titlePhotoVC = "Photo"
    private let titleFavouritesVC = "Favourites"
    private let nameImagePhotoVC = "photo.fill.on.rectangle.fill"
    private let nameImageFacVC = "heart.square"
    
//MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
//MARK: - Functions
    
    private func generateNavifationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
    private func setupViewControllers() {
        guard let imagePhoto = UIImage(systemName: nameImagePhotoVC),
              let imageFavourites = UIImage(systemName: nameImageFacVC) else { return }
        let photoVC = PhotoCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        
        viewControllers = [
        generateNavifationController(rootViewController: photoVC, title: titlePhotoVC, image: imagePhoto),
        generateNavifationController(rootViewController: ViewController(), title: titleFavouritesVC, image: imageFavourites)]
    }
}
