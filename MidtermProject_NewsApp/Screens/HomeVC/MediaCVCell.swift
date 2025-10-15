//
//  MediaCVCell.swift
//  MidtermProject_NewsApp
//
//  Created by Nahid Askerli on 29.08.25.
//

import UIKit
import SnapKit
import Kingfisher

final class MediaCVCell: UICollectionViewCell {
    private let mediaImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        return iv
    }()
    
    private let topicLabel: UILabel = {
        let tl = UILabel()
        tl.font = .boldSystemFont(ofSize: 14)
        tl.text = "News"
        tl.textColor = .white
        return tl
    }()
    
    private let titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = .systemFont(ofSize: 12)
        tl.text = "New Music Releases March 25: Ed Sheeran, J Balvin, Maren..."
        tl.numberOfLines = 0
        tl.textColor = .white
        return tl
    }()
    
    private let textContainer: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 86
        sv.alignment = .leading
        sv.distribution = .fillEqually
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(mediaImageView)
        mediaImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mediaImageView.addSubview(textContainer)
        textContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.lessThanOrEqualToSuperview().inset(8)
        }
        
        textContainer.addArrangedSubview(topicLabel)
        textContainer.addArrangedSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MediaCVCell{
    struct Item {
        let media: String
        let topic: String
        let title: String
    }
    func configure(item: Item){
        self.mediaImageView.kf
            .setImage(with: URL(string: item.media))
        self.topicLabel.text = item.topic
        self.titleLabel.text = item.title
    }
}
