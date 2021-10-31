//
//  FullScreenImageViewController.swift
//  CollectionPhoto
//
//  Created by Art on 31.10.2021.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    
//MARK: - Properties
    var image = [Images]()
    var indexPathFromFavorites: IndexPath?
    
//MARK: - UI element
    private var collectionView: UICollectionView!
    
//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
    }
    
//MARK: - Methods
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.8)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setViews() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(FullScreenCell.self, forCellWithReuseIdentifier: FullScreenCell.reuseId)
        view.addSubview(collectionView)
       
        collectionView.delegate = self
        collectionView.dataSource = self
        
        guard let index = indexPathFromFavorites else { return }
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
    }
}

//MARK: - ext ColletctionView
extension FullScreenImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullScreenCell.reuseId, for: indexPath) as? FullScreenCell else { return UICollectionViewCell() }
        cell.configure(with: image[indexPath.item])
        return cell
    }
}

//MARK: - ext setConstraint
extension FullScreenImageViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
}
