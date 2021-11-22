//
//  PhotoCollectionViewController.swift
//  CollectionPhoto
//
//  Created by Art on 22.10.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    
//MARK: - Service
    private let network = NetworkDataFetcher()
    private let database = CoredataService()
    
//MARK: - Properties
    private let titleCollectionView = "Photo"
    private var searchText = ""
    private var pageNumber = 1
    private var isLoading: Bool = false
    private var timer = Timer()
    private var photos = [Photo]()
    private var selectedImages = [UIImage]()
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    private var numberOfSelectedPhotos: Int {
        collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
//MARK: - UI elements
    private var collectionView: UICollectionView!
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
        setConstraints()
        setupNavigationBar()
        setupSearchBar()
        updateNavigationButtonState()
    }
    
//MARK: - Functions
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseId)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemLeft = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        itemLeft.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let itemRight = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        itemRight.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.7)), subitems: [itemLeft, itemRight])
        let section = NSCollectionLayoutSection(group: containerGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
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
    
    private func saveImageToCoredata(with images: [UIImage]) {
        images.forEach { image in
            let imageString = image.pngData()!.base64EncodedString()
            database.saveCoreData(image: imageString)
        }
    }
    
//MARK: - Navigation action
    @objc private func addBarButtonTapped() {
        saveImageToCoredata(with: selectedImages)
        refresh()
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
}
    
//MARK: - Collection Methods
extension PhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseId, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.photo = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavigationButtonState()
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell,
        let image = cell.photoImageView.image else { return }
            selectedImages.append(image)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavigationButtonState()
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell,
        let image = cell.photoImageView.image else { return }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
}

//MARK: - UICollectionViewDataSourcePrefetching
extension PhotoViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let section = indexPaths.map({$0.item}).max() else { return }
        
        if section > photos.count - 3, !isLoading {
            isLoading = true
            pageNumber += 1
            network.fetchImage(searchTerm: searchText, pageNumber: pageNumber) {[weak self] photo in
                guard let self = self,
                      let photo = photo?.results else { return }
                self.photos.append(contentsOf: photo)
                self.collectionView.insertItems(at: indexPaths)
                self.isLoading = false
            }
        }
    }
}

//MARK: - Extension SearchBar
extension PhotoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {[weak self] _ in
            guard let self = self else { return }
            self.pageNumber = 1
            self.network.fetchImage(searchTerm: searchText, pageNumber: self.pageNumber) {[weak self] searchResults in
                guard let fetchPhotos = searchResults,
                      let self = self else { return }
                self.photos = fetchPhotos.results
                self.searchText = searchText
                self.collectionView.reloadData()
            }
        })
    }
}

//MARK: - SetConstaints
extension PhotoViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}
