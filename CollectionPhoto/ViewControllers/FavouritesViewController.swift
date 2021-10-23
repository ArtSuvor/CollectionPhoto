//
//  ViewController.swift
//  CollectionPhoto
//
//  Created by Art on 22.10.2021.
//

import UIKit

class FavouritesViewController: UIViewController {
//MARK: - Properties
    var photos = [UIImage]()
    private var selectedPhoto = [UIImage]()
    private var numberOfSelectedPhoto: Int {
        collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
//MARK: - UI elements
    let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .secondarySystemBackground
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    private let actionBarButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    private let trashBarButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashBarButtonTapped))
    }()
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setConstraints()
        setupNavigationItems()
    }

//MARK: - Functions
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(FavouritesCollectionViewCell.self, forCellWithReuseIdentifier: FavouritesCollectionViewCell.cellId)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupNavigationItems() {
        navigationItem.rightBarButtonItems = [trashBarButton, actionBarButton]
        navigationItem.title = "Favourites"
        
        actionBarButton.isEnabled = false
        trashBarButton.isEnabled = false
    }
    
    private func updateButtonState() {
        actionBarButton.isEnabled = numberOfSelectedPhoto > 0
        trashBarButton.isEnabled = numberOfSelectedPhoto > 0
    }
    
    private func refresh() {
        selectedPhoto.removeAll()
        collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateButtonState()
    }
    
    @objc private func actionBarButtonTapped(sender: UIBarButtonItem) {
        let shareController = UIActivityViewController(activityItems: selectedPhoto, applicationActivities: nil)
        shareController.completionWithItemsHandler = {[weak self]_, bool, _, _ in
            guard let self = self else { return }
            if bool {
                self.refresh()
            }
        }
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    
    @objc private func trashBarButtonTapped() {
    
    }
}

//MARK: - Extension Delegate, DataSource
extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouritesCollectionViewCell.cellId, for: indexPath) as? FavouritesCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: photos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateButtonState()
        let image = photos[indexPath.item]
        selectedPhoto.append(image)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateButtonState()
        let image = photos[indexPath.item]
        if let index = selectedPhoto.firstIndex(of: image) {
            selectedPhoto.remove(at: index)
        }
    }
}

//MARK: - Extension CollectionLayout
extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let avaliableWidth = view.frame.width - 10
        let widthPerItem = avaliableWidth / 2
        let height = CGFloat(photo.size.height) * widthPerItem / CGFloat(photo.size.width)
        return CGSize(width: widthPerItem, height: height)
    }
}

//MARK: - SetConstraints
extension FavouritesViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}
