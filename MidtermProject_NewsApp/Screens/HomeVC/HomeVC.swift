//
//  HomeVC.swift
//  MidtermProject_NewsApp
//
//  Created by Nahid Askerli on 29.08.25.
//

import UIKit
import SnapKit

final class HomeVC: BaseVC {
    var formattedDate = ""
    private var mediaList: [MediaCVCell.Item] = []
    private var cellList:[HomeTVCell.Item] = []
    
    private var allNewsResponse: [NewsItem]?
    private var todaysNewsResponse: [NewsItem]?
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    private let contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.spacing = 20
        sv.distribution = .fill
        return sv
    }()
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
        tl.font = .boldSystemFont(ofSize: 20)
        return tl
    }()
    private let dateLabel: UILabel = {
        let tl = UILabel()
        tl.text = "March 26th, 2022"
        tl.font = .systemFont(ofSize: 13)
        tl.textColor = .lightGray
        return tl
    }()
    private let collectionStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.spacing = 30
        sv.distribution = .fill
        return sv
    }()
    
    private lazy var mediaCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.itemSize = .init(width: UIScreen.main.bounds.width - 40, height: 180)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(MediaCVCell.self,forCellWithReuseIdentifier:MediaCVCell.identifier)
        return cv
    }()
    
    private let searchSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 15
        return sv
    }()
    private let baseView: UIView = {
        let bv = UIView()
        return bv
    }()
    private lazy var languageButton: UIButton = {
        let lb = UIButton()
        lb.layer.cornerRadius = 8
        lb.setTitle("En", for: .normal)
        lb.setTitleColor(.black, for: .normal)
        lb.backgroundColor = .gray.withAlphaComponent(0.4)
        lb.addTarget(self, action: #selector(didTapLangButton), for: .touchUpInside)
        return lb
    }()
    
    private lazy var homeTV: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.showsVerticalScrollIndicator = false
        tv.showsHorizontalScrollIndicator = false
        tv.separatorStyle = .none
        tv.register(HomeTVCell.self,forCellReuseIdentifier: HomeTVCell.identifier)
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        [headerStackView,collectionStackView,searchSV,homeTV].forEach{
            contentStackView.addArrangedSubview($0)
        }
        [nameLabel,dateLabel].forEach{headerStackView.addArrangedSubview($0)}
        collectionStackView.addArrangedSubview(mediaCV)
        searchSV.addArrangedSubview(baseView)
        [languageButton].forEach{baseView.addSubview($0)}
    }
    override func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        mediaCV.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
        languageButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(55)
        }
        baseView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        homeTV.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(300)
        }
    }
    
    @objc
    func didTapLangButton() {
        let vc = LanguageVC()
        vc.selectedLang = { [weak self] lang in guard let self else { return }
            fetchTodayNews(lang: lang)
            fetchAllNewsData(lang: lang)
            languageButton.setTitle(lang.uppercased(), for: .normal)
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func fetchData() {
        fetchTodayNews()
        fetchAllNewsData()
    }
    
    private func fetchAllNewsData(lang: String = "en") {
        NetworkManager.shared.getAllNews(lang: lang) { [weak self] result in guard let self else {
            return
        }
            switch result {
            case .success(let success):
                if let data = success.articles {
                    allNewsResponse = data
                    cellList = data.map { item in
                        HomeTVCell.Item(
                            image: item.urlToImage ?? "",
                            finance: item.source?.name ?? "",
                            title: item.title ?? "",
                            name: item.author ?? "",
                            date: item.publishedAt ?? ""
                        )
                    }
                    
                    cellList.removeSubrange(3...(cellList.count - 1))
                    
                    
                    if let firstItem = data.first {
                        let isoDate = firstItem.publishedAt ?? ""
                        let formattedDate = self.formatDate(isoDate)
                        //self.dateLabel.text = self.formatDate(isoDate)
                        
                        
                        
                        DispatchQueue.main.async {
                            self.dateLabel.text = formattedDate
                            self.homeTV.reloadData()
                            
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
    
    private func fetchTodayNews(lang: String = "en") {
        NetworkManager.shared
            .getTodaysNews(lang: lang) {  [weak self] result in guard let self
                else { return }
                switch result {
                case .success(let response):
                    if let data = response.articles {
                        todaysNewsResponse = data
                        mediaList = data.map(
                            { item in
                                MediaCVCell
                                    .Item(
                                        media: item.urlToImage ?? "",
                                        topic: item.source?.name ?? "",
                                        title: item.title ?? ""
                                    )
                            })
                        
                        DispatchQueue.main.async {
                            self.mediaCV.reloadData()
                        }
                    } else {
                        print("Something went wrong...")
                    }
                case .failure(_):
                    print("Nese error bas verdi")
                }
            }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCVCell.identifier, for: indexPath) as? MediaCVCell else {
            return UICollectionViewCell()
        }
        let item = mediaList[indexPath.row]
        cell.configure(item: item)
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let item = todaysNewsResponse?[indexPath.row]
        if let item {
            let vc = DetailVC(newsDetail: item)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: HomeTVCell.identifier,
            for: indexPath
        )as? HomeTVCell {
            let model = cellList[indexPath.row]
            cell.configure(item: model)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let item = allNewsResponse?[indexPath.row]
        if let item {
            let vc = DetailVC(newsDetail: item)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HomeVC {
    func filterNews(with text: String) {
        guard let allNews = allNewsResponse else { return }
        
        if text.isEmpty {
            
            cellList = allNews.map { item in
                HomeTVCell.Item(
                    image: item.urlToImage ?? "",
                    finance: item.source?.name ?? "",
                    title: item.title ?? "",
                    name: item.author ?? "",
                    date: item.publishedAt ?? ""
                )
            }
        } else {
            
            cellList = allNews.filter { item in
                (item.title?.lowercased().contains(text.lowercased()) ?? false) ||
                (item.description?.lowercased().contains(text.lowercased()) ?? false)
            }.map { item in
                HomeTVCell.Item(
                    image: item.urlToImage ?? "",
                    finance: item.source?.name ?? "",
                    title: item.title ?? "",
                    name: item.author ?? "",
                    date: item.publishedAt ?? ""
                )
            }
        }
        
        DispatchQueue.main.async {
            self.homeTV.reloadData()
            self.mediaCV.reloadData()
        }
    }
}

extension HomeVC {
    private func formatDate(_ isoDate: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: isoDate) else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
