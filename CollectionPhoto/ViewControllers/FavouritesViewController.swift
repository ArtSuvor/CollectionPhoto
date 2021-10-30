//
//  ViewController.swift
//  CollectionPhoto
//
//  Created by Art on 22.10.2021.
//

import UIKit

class FavouritesViewController: UIViewController {
//MARK: - Properties
    private var images = [Images]()
    private var selectedImages = [Images]()
    private var indexSelectedCells = [IndexPath]()
    private var selectedPhoto = [UIImage]()
    private var numberOfSelectedPhoto: Int {
        collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
//MARK: - Service
    private let database = CoredataService()
    
//MARK: - UI elements
    private var collectionView: UICollectionView!
    private lazy var actionBarButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    private lazy var trashBarButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashBarButtonTapped))
    }()
    
//MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        images = database.getCoreData()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setConstraints()
        setupNavigationItems()
        updateButtonState()
    }

//MARK: - Functions
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(FavouritesCollectionViewCell.self, forCellWithReuseIdentifier: FavouritesCollectionViewCell.cellId)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
        view.addSubview(collectionView)

        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemLeft = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        itemLeft.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let itemRight = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)))
        itemRight.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
        let groupRight = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)), subitem: itemRight, count: 2)
        let containerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.8)), subitems: [itemLeft, groupRight])
        let section = NSCollectionLayoutSection(group: containerGroup)
        section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehavior.continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
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
        indexSelectedCells.removeAll()
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
        indexSelectedCells.forEach { index in
            images.remove(at: index.item)
        }
        database.deleteCoreData(with: selectedImages)
        collectionView.deleteItems(at: indexSelectedCells)
        indexSelectedCells.removeAll()
        collectionView.reloadData()
    }
}

//MARK: - Extension Delegate, DataSource
extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouritesCollectionViewCell.cellId, for: indexPath) as? FavouritesCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: images[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateButtonState()
        guard let cell = collectionView.cellForItem(at: indexPath) as? FavouritesCollectionViewCell,
              let image = cell.imageView.image else { return }
        selectedPhoto.append(image)
        selectedImages.append(images[indexPath.item])
        indexSelectedCells.append(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateButtonState()
        guard let cell = collectionView.cellForItem(at: indexPath) as? FavouritesCollectionViewCell,
              let image = cell.imageView.image else { return }
        let imageString = images[indexPath.item]
        if let index = selectedPhoto.firstIndex(of: image),
           let indexString = selectedImages.firstIndex(of: imageString) {
            selectedPhoto.remove(at: index)
            selectedImages.remove(at: indexString)
        }
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
