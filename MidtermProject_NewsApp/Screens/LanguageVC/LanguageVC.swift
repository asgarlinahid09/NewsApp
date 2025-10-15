//
//  LanguageVC.swift
//  MidtermProject_NewsApp
//
//  Created by Nahid Askerli on 29.08.25.
//


import UIKit
final class LanguageVC: BaseVC {
    
    var selectedLang: ((String) -> Void)?
    private let langList: [LanguageTVCell.Item] = [
        .init(language: "EN"),
        .init(language: "RU")
    ]
    
    private lazy var languageTV: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv
            .register(
                LanguageTVCell.self,
                forCellReuseIdentifier: LanguageTVCell.identifier
            )
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUI() {
        view.addSubview(languageTV)
    }
    override func setupConstraints() {
        languageTV.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension LanguageVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: LanguageTVCell.identifier,
            for: indexPath
        )as? LanguageTVCell{
            let item = langList[indexPath.row]
            cell.configure(item: item)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let selectedItem = langList[indexPath.row]
        selectedLang?(selectedItem.language.lowercased())
        navigationController?.popViewController(animated: true)
    }
}
