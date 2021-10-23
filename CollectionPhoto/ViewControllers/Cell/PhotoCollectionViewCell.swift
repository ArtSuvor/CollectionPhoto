//
//  Photo.swift
//  CollectionPhoto
//
//  Created by Art on 23.10.2021.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
//MARK: - Properties
    static let reuseId = "PhotoCollectionViewCell"
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    var photo: Photo! {
        didSet {
            let photoUrl = photo.urls["regular"]
            guard let imageUrl = photoUrl,
                  let url = URL(string: imageUrl) else { return }
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
//MARK: - UI elements
    private let checkmark: UIImageView = {
        let image = UIImage(systemName: "checkmark.circle.fill")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray3
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
//MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        updateSelectedState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Override func
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
//MARK: - Functions
    private func updateSelectedState() {
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    private func setupSubviews() {
        addSubview(photoImageView)
        photoImageView.addSubview(checkmark)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
        
        NSLayoutConstraint.activate([
            checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -10),
            checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -10)])
    }
}
