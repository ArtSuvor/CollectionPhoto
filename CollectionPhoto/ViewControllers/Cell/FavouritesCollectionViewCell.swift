//
//  FavouritesCollectionViewCell.swift
//  CollectionPhoto
//
//  Created by Art on 23.10.2021.
//

import UIKit

class FavouritesCollectionViewCell: UICollectionViewCell {
    
//MARK: - Properties
    static let cellId = "FavouritesCollectionViewCell"
    
//MARK: - UI element
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
//MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - Functions
    private func setupSubviews() {
        self.addSubview(imageView)
    }
    
    func configure(with photo: UIImage){
        imageView.image = photo
    }
}

//MARK: - setConstraints
extension FavouritesCollectionViewCell {
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
}
