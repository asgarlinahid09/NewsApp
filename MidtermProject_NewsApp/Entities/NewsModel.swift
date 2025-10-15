//
//  NewsModel.swift
//  MidtermProject_NewsApp
//
//  Created by Nahid Askerli on 29.08.25.
//

import Foundation


struct NewsData: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [NewsItem]?
    let message: String?
}


struct NewsItem: Decodable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Decodable {
    let id: String?
    let name: String?
}
