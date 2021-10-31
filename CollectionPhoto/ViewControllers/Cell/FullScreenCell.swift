//
//  FullScreenCell.swift
//  CollectionPhoto
//
//  Created by Art on 31.10.2021.
//

import UIKit

class FullScreenCell: UICollectionViewCell {
    
//MARK: - Properties
    static let reuseId = "FullScreenCell"
    
//MARK: - UI element
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
//MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Methods
    func configure(with image: Images) {
        guard let encodedImage = image.imageString,
              let imageData = Data(base64Encoded: encodedImage) else { return }
        
        imageView.image = UIImage(data: imageData)
    }
    
    private func setViews() {
        self.addSubview(imageView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
}
