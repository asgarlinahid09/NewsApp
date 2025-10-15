//
//  LanguageTVCell.swift
//  MidtermProject_NewsApp
//
//  Created by Nahid Askerli on 29.08.25.
//


import UIKit
final class LanguageTVCell: UITableViewCell{
    private let languageLabel: UILabel = {
        let ll = UILabel()
        ll.text = "EN"
        ll.font = .boldSystemFont(ofSize: 24)
        return ll
    }()
    
    private let separatorView: UIView = {
        let sv = UIView()
        sv.backgroundColor = .black
        return sv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(
            style:style ,
            reuseIdentifier: reuseIdentifier
        )
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        contentView.addSubview(languageLabel)
        contentView.addSubview(separatorView)
    }
    private func setupConstraints(){
        languageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

extension LanguageTVCell{
    struct Item {
        let language: String
    }
    func configure(item: Item){
        self.languageLabel.text = item.language
    }
}

