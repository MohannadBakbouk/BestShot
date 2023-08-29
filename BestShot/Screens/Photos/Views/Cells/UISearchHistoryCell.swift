//
//  UISearchHistoryCell.swift
//  BestShot
//
//  Created by Mohannad on 29/08/2023.
//

import UIKit
import SnapKit

final class UISearchHistoryCell: UITableViewCell {

    private let iconView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: Images.clock))
        image.contentMode = .scaleAspectFit
        image.tintColor = .gray
        return image
    }()
     
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
     }()
    
    private lazy var contentStack : UIStackView =  {
         let stack = UIStackView(arrangedSubviews: [iconView, titleLabel])
         stack.axis = .horizontal
         stack.spacing = 10
         stack.distribution = .fill
         return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews(){
        selectionStyle = .none
        backgroundColor = .systemGray5
        contentView.addSubview(contentStack)
        setupConstraints()
    }
    
    private func setupConstraints(){
        contentStack.snp.makeConstraints{ make in
            make.bottom.trailing.equalToSuperview().offset(-10)
            make.top.leading.equalToSuperview().offset(10)
        }
        iconView.snp.makeConstraints{$0.size.equalTo(20)}
    }
    
    func configure(with model: String){
        titleLabel.text = model
    }
}
