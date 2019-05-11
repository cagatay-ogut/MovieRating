//
//  MovieLoader.swift
//  MovieRating
//
//  Created by cagatay_personal on 11.05.19.
//  Copyright © 2019 cagatay. All rights reserved.
//

import Foundation

class MovieLoader {
    
    let MOVIE_FILE_NAME = "top10imdb"
    let MOVIE_FILE_EXT = "json"
    
    func loadMoviesFromFile() -> [Movie]? {
        guard let url = Bundle.main.url(forResource: MOVIE_FILE_NAME, withExtension: MOVIE_FILE_EXT) else { return nil }
        do {
            let fileData = try Data(contentsOf: url)
            
            return try JSONDecoder().decode([Movie].self, from: fileData)
        } catch {
            print("Error while reading file")
            return nil
        }
    }
}
