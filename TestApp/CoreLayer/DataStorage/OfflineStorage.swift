//
//  DataStorage.swift
//  TestApp
//
//  Created by Roman Ivaniv on 3/24/19.
//  Copyright © 2019 Roman Ivaniv. All rights reserved.
//

import Foundation

private let movieListKey = "MovieList"
private let baseDocsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

struct OfflineStorage {
    
    static func save(data: [String: Any]) {
        UserDefaults.standard.setValue(data, forKey: movieListKey)
    }
    
    static func loadMovies() -> [MovieItem]? {
        guard let data = UserDefaults.standard.value(forKey: movieListKey) as? [String: Any] else {
            return nil
        }
        let movies = MovieItem.createMovies(from: data)
        return movies
    }
    
    static func saveTrailer(for movieID: Int, with url: URL, complation:@escaping (Bool) -> ()) {
        DispatchQueue.global(qos: .background).async {
            let urlData = NSData(contentsOf: url)!
            let filePath="\(baseDocsPath)/\(movieID).mp4"
            let success = urlData.write(toFile: filePath, atomically: true)
            DispatchQueue.main.async {
                complation(success)
            }
        }
    }
    
    static func loadTrailerURL(for movieID: Int) -> URL? {
        let filePath = "\(baseDocsPath)/\(movieID).mp4"
        return URL(fileURLWithPath: filePath)
    }
    
    static func hasTrailer(for movieID: Int) -> Bool {
        let filePath = "\(baseDocsPath)/\(movieID).mp4"
        return FileManager.default.fileExists(atPath: filePath)
    }
    
}
