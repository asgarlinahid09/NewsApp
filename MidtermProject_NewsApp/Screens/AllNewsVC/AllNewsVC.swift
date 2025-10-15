//
//  AllNewsVC.swift
//  MidtermProject_NewsApp
//
//  Created by Nahid Askerli on 29.08.25.
//

import UIKit
final class AllNewsVC: BaseVC {
    
    var formattedDate = ""
    
    enum Sections {
        case allNews(AllNewsTVCell.Item)
        case empty(String)
    }
    
    private var cellList:[AllNewsTVCell.Item] = []
    private var allNewsResponse: [NewsItem]?
    
    private var sections: [Sections] = []
    
    
    
    
    private let headerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.spacing = 30
        sv.distribution = .fill
        return sv
    }()
    private let nameLabel: UILabel = {
        let tl = UILabel()
        tl.text = "News Catcher"
        tl.font = .boldSystemFont(ofSize: 18)
        return tl
    }()
    private let dateLabel: UILabel = {
        let tl = UILabel()
        tl.text = "March 26th, 2022"
        tl.font = .systemFont(ofSize: 13)
        tl.textColor = .lightGray
        return tl
    }()
    private lazy var allnewsTV: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv
            .register(
                AllNewsTVCell.self,
                forCellReuseIdentifier: AllNewsTVCell.identifier
            )
        tv
            .register(
                NewsEmptyTVCell.self,
                forCellReuseIdentifier: NewsEmptyTVCell.identifier
            )
        
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search News"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = UISearchController(
            searchResultsController: nil
        )
        navigationItem.searchController?.searchBar.delegate = self
    }
    override func fetchData() {
        fetchAllNewsData()
    }
    override func setupUI() {
        [headerStackView,allnewsTV].forEach{view.addSubview($0)}
        [nameLabel,dateLabel].forEach { headerStackView.addArrangedSubview($0) }
        
    }
    override func setupConstraints() {
        headerStackView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        allnewsTV.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func fetchAllNewsData(lang: String = "en") {
        NetworkManager.shared.getAllNews(lang: lang) { [weak self] result in guard let self else {
            return
        }
            switch result {
            case .success(let success):
                if let data = success.articles {
                    self.allNewsResponse = data
                    
                    if data.isEmpty {
                        self.sections = [.empty("Xəbər tapılmadı")]
                    } else {
                        self.sections = data.map { item in
                                .allNews(
                                    AllNewsTVCell.Item(
                                        image: item.urlToImage ?? "",
                                        finance: item.source?.name ?? "",
                                        title: item.title ?? "",
                                        name: item.author ?? "",
                                        date: item.publishedAt ?? ""
                                    )
                                )
                        }
                    }
                    
                    //                    if let firstItem = data.first {
                    //                        let isoDate = firstItem.publishedAt ?? ""
                    //                        formattedDate = self.formatDate(isoDate)
                    //                    }
                    //                    DispatchQueue.main.async {
                    //                        self.allnewsTV.reloadData()
                    //                    }
                    
                    if let firstItem = data.first {
                        let isoDate = firstItem.publishedAt ?? ""
                        let formattedDate = self.formatDate(isoDate)
                        //self.dateLabel.text = self.formatDate(isoDate)
                        
                        
                        
                        DispatchQueue.main.async {
                            self.dateLabel.text = formattedDate
                            self.allnewsTV.reloadData()
                            
                        }
                    }
                } else {
                    print("Something wrong!")
                }
            case .failure(let failure):
                print(
                    "error fetch all news data \(failure.localizedDescription)"
                )
            }
        }
    }
}


extension AllNewsVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.row] {
        case .allNews(let item):
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: AllNewsTVCell.identifier,
                for: indexPath
            ) as? AllNewsTVCell{
                cell.configure(item: item)
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell ()
        case .empty(let title):
            if let cell = tableView.dequeueReusableCell(withIdentifier: NewsEmptyTVCell.identifier, for: indexPath) as? NewsEmptyTVCell {
                cell.configure(.init(title: title))
                cell.selectionStyle = .none
                return cell
            }
            return UITableViewCell()
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
        switch sections[indexPath.row] {
        case .allNews(let item):
            if let newsItem = allNewsResponse?.first(where: { $0.title == item.title }) {
                let vc = DetailVC(newsDetail: newsItem)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .empty:
            break
        }
    }
    
}



extension AllNewsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        sections.removeAll() // əvvəlki nəticələri sil
        
        guard let allNews = allNewsResponse else {
            sections.append(.empty("Xəbər tapılmadı"))
            allnewsTV.reloadData()
            return
        }
        
        let filteredNews: [AllNewsTVCell.Item]
        
        if searchText.isEmpty {
            filteredNews = allNews.map { item in
                AllNewsTVCell.Item(
                    image: item.urlToImage ?? "",
                    finance: item.source?.name ?? "",
                    title: item.title ?? "",
                    name: item.author ?? "",
                    date: item.publishedAt ?? ""
                )
            }
        } else {
            let matched = allNews.filter { item in
                (item.title?.lowercased().contains(searchText.lowercased()) ?? false)
            }
            
            filteredNews = matched.map { item in
                AllNewsTVCell.Item(
                    image: item.urlToImage ?? "",
                    finance: item.source?.name ?? "",
                    title: item.title ?? "",
                    name: item.author ?? "",
                    date: item.publishedAt ?? ""
                )
            }
        }
        
        if filteredNews.isEmpty {
            sections.append(.empty("Axtardiginiz netice tapilmadi..."))
        } else {
            filteredNews.forEach { item in
                sections.append(.allNews(item))
            }
        }
        
        allnewsTV.reloadData()
    }
}


extension AllNewsVC {
    private func formatDate(_ isoDate: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: isoDate) else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

