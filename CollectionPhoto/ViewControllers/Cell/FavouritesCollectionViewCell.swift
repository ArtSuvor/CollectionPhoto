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
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
//MARK: - UI element
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    private let checkmark: UIImageView = {
        let image = UIImage(systemName: "checkmark.circle.fill")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
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
        layer.masksToBounds = true
        layer.cornerRadius = 10
        addSubview(imageView)
        imageView.addSubview(checkmark)
    }
    
    func configure(with photo: Images){
        guard let encodedImage = photo.imageString,
              let imageData = Data(base64Encoded: encodedImage) else { return }
        
        imageView.image = UIImage(data: imageData)
    }
    
    private func updateSelectedState() {
        imageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
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
        
        NSLayoutConstraint.activate([
            checkmark.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            checkmark.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10)])
    }
}
