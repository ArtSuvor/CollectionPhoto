//
//  PhotoCollectionViewController.swift
//  CollectionPhoto
//
//  Created by Art on 22.10.2021.
//

import UIKit

class PhotoCollectionViewController: UICollectionViewController {
    
//MARK: - Properties
    private let cellId = "PhotoCollectionViewCell"
    private let titleCollectionView = "Photo"
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
    }
    
//MARK: - Functions
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .green
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
    
//MARK: - Navigation action
    
    @objc private func addBarButtonTapped() {
        
    }
    
    @objc private func actionBarButtonTapped() {
        
    }
    
//MARK: - Collection Methods
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        5
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
//        cell.backgroundColor = .red
//        return cell
//    }
}

//MARK: - Extension SearchBar
extension PhotoCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
