//
//  DetailVC.swift
//  MidtermProject_NewsApp
//
//  Created by Nahid Askerli on 29.08.25.
//

import UIKit
import Kingfisher

final class DetailVC: BaseVC {
    
    let newsDetail: NewsItem
    
    init(newsDetail: NewsItem) {
        self.newsDetail = newsDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.kf.setImage(with: URL(string: newsDetail.urlToImage ?? ""))
        
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var shareButton: UIButton = {
        let sb = UIButton()
        sb.backgroundColor = .gray
        sb.layer.cornerRadius = 17.5
        sb.setImage(UIImage(named: "blueShare"), for: .normal)
        sb.tintColor = .black
        sb.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        sb.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        return sb
    }()
    
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        return sv
    }()
    
    private let contentView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .systemBackground
        cv.layer.cornerRadius = 20
        return cv
    }()
    
    private let mainStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 15
        return sv
    }()
    
    private let topStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 24
        return sv
    }()
    
    private lazy var topicLabel: UILabel = {
        let tl = UILabel()
        tl.text = newsDetail.source?.name ?? ""
        tl.numberOfLines = 0
        tl.font = .systemFont(ofSize: 11)
        return tl
    }()
    
    private lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.numberOfLines = 0
        tl.text = newsDetail.title ?? ""
        tl.font = .boldSystemFont(ofSize: 26)
        return tl
    }()
    
    private let excerptStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 11
        sv.alignment = .trailing
        return sv
    }()
    
    private lazy var authorNameLabel: UILabel = {
        let anl = UILabel()
        anl.numberOfLines = 0
        anl.text = newsDetail.author ?? ""
        anl.textColor = .blue
        anl.font = .boldSystemFont(ofSize: 12)
        return anl
    }()
    
    private lazy var excerptLabel: UILabel = {
        let el = UILabel()
        el.numberOfLines = 0
        el.text = newsDetail.content ?? ""
        el.font = .boldSystemFont(ofSize: 15)
        return el
    }()
    
    private lazy var summaryLabel: UILabel = {
        let sl = UILabel()
        sl.numberOfLines = 0
        sl.textColor = .lightGray
        sl.font = .systemFont(ofSize: 12)
        sl.text = newsDetail.description ?? ""
        return sl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @objc func didTapShare() {
        let text = "Check out \(newsDetail.title ?? "") news!"
        guard let url = URL(string: newsDetail.url ?? "") else { return }
        
        let items: [Any] = [text, url]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX,
                                        y: self.view.bounds.midY,
                                        width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        present(activityVC, animated: true)
    }
    
    override func setupUI() {
        [newsImageView, scrollView, shareButton].forEach { view.addSubview($0) }
        
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStackView)
        
        [topStackView, excerptStackView, summaryLabel].forEach { mainStackView.addArrangedSubview($0) }
        [topicLabel, titleLabel].forEach { topStackView.addArrangedSubview($0) }
        [authorNameLabel, excerptLabel].forEach { excerptStackView.addArrangedSubview($0) }
    }
    
    override func setupConstraints() {
        newsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(245)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).offset(-70)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        shareButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(35)
        }
    }
}

