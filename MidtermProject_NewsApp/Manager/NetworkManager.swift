//
//  NetworkManager.swift
//  MidtermProject_NewsApp
//
//  Created by Nahid Askerli on 29.08.25.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    fileprivate let apiKey = "dcc6e65ed5824ea58599c3b61bf13ca6"
    
    func getAllNews(
        lang: String = "ru",
        completion: @escaping (Result<NewsData, any Error>) -> Void
    ) {
        guard let newsUrl = URL(string: "https://newsapi.org/v2/everything?q=apple&sortBy=popularity&language=\(lang)&apiKey=\(apiKey)") else {return}
        let urlRequset = URLRequest(url: newsUrl)
        let task = URLSession.shared.dataTask(with: urlRequset) { data, response, error in
            if let error {
                print("Xeta bas verdi error: \(error)")
            }
            
            if let data {
                do {
                    let model = try JSONDecoder().decode(
                        NewsData.self,
                        from: data
                    )
                    
                    completion(.success(model))
                }
                catch {
                    
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func getTodaysNews(
        lang: String = "ru",
        completion: @escaping (Result<NewsData, any Error>) -> Void
    ) {
        let todaysDate = Date()
        let yesterdaysDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let todayString = formatter.string(from: todaysDate)
        let yesterdayString = formatter.string(from: yesterdaysDate)
        
        guard let newsUrl = URL(string: "https://newsapi.org/v2/everything?q=apple&sortBy=popularity&from=\(todayString)&to=\(yesterdayString)&language=\(lang)&apiKey=\(apiKey)") else {return}
        let urlRequset = URLRequest(url: newsUrl)
        let task = URLSession.shared.dataTask(with: urlRequset) { data, response, error in
            if let error {
                print("Xeta bas verdi error: \(error)")
            }
            if let data {
                do {
                    let model = try JSONDecoder().decode(
                        NewsData.self,
                        from: data
                    )
                    completion(.success(model))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}


