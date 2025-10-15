//
//  NewsEmptyTVCell.swift
//  MidtermProject_NewsApp
//
//  Created by Nahid Askerli on 29.08.25.
//

import UIKit
final class NewsEmptyTVCell: UITableViewCell {
    private let containerSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()
    
    private let topImageView: UIImageView = UIImageView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Axtardiginiz netice tapilmadi..."
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func  setupUI(){
        contentView.addSubview(containerSV)
        containerSV.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        topImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
        }
        [topImageView,titleLabel].forEach(containerSV.addArrangedSubview)
    }
}


extension NewsEmptyTVCell{
    struct Item {
        let title: String
    }
    func configure(_ item: Item){
        self.topImageView.image = .notFound
        self.titleLabel.text = item.title
    }
}
