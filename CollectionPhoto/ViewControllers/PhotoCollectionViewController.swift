//
//  PhotoCollectionViewController.swift
//  CollectionPhoto
//
//  Created by Art on 22.10.2021.
//

import UIKit

class PhotoCollectionViewController: UICollectionViewController {
    
//MARK: - Service
    private let network = NetworkDataFetcher()
    
//MARK: - Properties
    private let titleCollectionView = "Photo"
    private var timer = Timer()
    private var photos = [Photo]()
    private var selectedImages = [UIImage]()
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private var numberOfSelectedPhotos: Int {
        collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
//MARK: - UI elements
    private lazy var addBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigationBar()
        setupSearchBar()
        updateNavigationButtonState()
    }
    
//MARK: - Functions
    private func setupCollectionView() {
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseId)
        collectionView.backgroundColor = .green
        
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = titleCollectionView
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .systemGray3
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func refresh() {
        selectedImages.removeAll()
        collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavigationButtonState()
    }
    
    private func updateNavigationButtonState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
//MARK: - Navigation action
    @objc private func addBarButtonTapped() {
        
    }
    
    @objc private func actionBarButtonTapped(sender: UIBarButtonItem) {
        let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        shareController.completionWithItemsHandler = {[weak self] _, bool, _, _ in
            guard let self = self else { return }
            if bool {
                self.refresh()
            }
        }
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    
//MARK: - Collection Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseId, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.photo = photos[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavigationButtonState()
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell,
        let image = cell.photoImageView.image else { return }
            selectedImages.append(image)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavigationButtonState()
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell,
        let image = cell.photoImageView.image else { return }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
}

//MARK: - Extension SearchBar
extension PhotoCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.network.fetchImage(searchTerm: searchText) {[weak self] searchResults in
                guard let fetchPhotos = searchResults,
                      let self = self else { return }
                self.photos = fetchPhotos.results
                self.collectionView.reloadData()
            }
        })
    }
}

//MARK: - Extension FlowLayout
extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let avaliableWidth = view.frame.width - paddingSpace
        let widthPerItem = avaliableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }
}
