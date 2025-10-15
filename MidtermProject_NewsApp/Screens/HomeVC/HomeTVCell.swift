//
//  HomeTVCell.swift
//  MidtermProject_NewsApp
//
//  Created by Nahid Askerli on 29.08.25.
//

import UIKit
import Kingfisher

final class HomeTVCell: UITableViewCell {
    private let containerSV: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 16
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        return sv
    }()
    private let imageViev: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 18
        return iv
    }()
    private let mainSV:UIStackView = {
        let sv = UIStackView()
        sv.spacing = 6
        sv.axis = .vertical
        return sv
    }()
    private let financeLabel: UILabel = {
        let fl = UILabel()
        return fl
    }()
    private let titleLabel: UILabel = {
        let tl = UILabel()
        tl.font = .boldSystemFont(ofSize: 16)
        tl.numberOfLines = 0
        return tl
    }()
    private let titleSV:UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        return sv
    }()
    private let nameLabel: UILabel = {
        let nl = UILabel()
        nl.font = .boldSystemFont(ofSize: 12)
        nl.numberOfLines = 2
        return nl
    }()
    private let dateLabel: UILabel = {
        let dl = UILabel()
        dl.textAlignment = .right
        dl.font = .systemFont(ofSize: 10)
        dl.textColor = .lightGray
        return dl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        contentView.addSubview(containerSV)
        [mainSV,imageViev].forEach{containerSV.addArrangedSubview($0)}
        [financeLabel,titleLabel,titleSV].forEach{mainSV.addArrangedSubview($0)}
        [dateLabel,nameLabel].forEach{titleSV.addArrangedSubview($0)}
    }
    private func setupConstraints(){
        containerSV.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        }
        imageViev.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(105)
        }
    }
}

extension HomeTVCell {
    struct Item {
        let image: String
        let finance: String
        let title: String
        let name: String
        let date: String
    }
    func configure(item: Item){
        self .imageViev.kf
            .setImage(with: URL(string: item.image))
        self.financeLabel.text = item.finance
        self.titleLabel.text = item.title
        self.nameLabel.text = item.name
        self.dateLabel.text = item.date
    }
}

