//
//  UIPhotoCell.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import UIKit
import SnapKit
import RxSwift

final class UIPhotoCell: UICollectionViewCell {

    private let photoView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.backgroundColor = .lightGray
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews(){
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.backgroundColor = .gray
        contentView.addSubview(photoView)
        setupConstraints()
    }
    
    private func setupConstraints(){
        photoView.snp.makeConstraints{$0.edges.equalToSuperview()}
    }
    
    func configure(with model: PhotoViewData){
        photoView.image = model.image
    }
}
