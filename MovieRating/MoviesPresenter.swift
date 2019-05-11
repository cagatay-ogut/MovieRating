//
//  MoviesPresenter.swift
//  MovieRating
//
//  Created by cagatay_personal on 11.05.19.
//  Copyright © 2019 cagatay. All rights reserved.
//

import UIKit

class MoviesPresenter<T: MoviesView> {
    
    weak var view: T?

    let movieLoader = MovieLoader()
    var movies: [Movie] = []

    init(view: T) {
        self.view = view
    }
    
    func onViewLoaded() {
        loadMovies()
        view?.reloadTable()
    }
    
    func getMoviesCount() -> Int {
        return movies.count
    }
    
    func getMovieViewModel(index: IndexPath) -> MovieViewModel {
        let movie = movies[index.row]
        var movieViewModel = MovieViewModel()
        movieViewModel.name = movie.name
        movieViewModel.rating = "Rated: \(movie.rating.getStringValue())"
        return movieViewModel
    }
    
    func onRateMovie(index: IndexPath) {
        let actionSheetRate = createActionSheetForRating(index: index)
        view?.showRatingOptions(actionSheet: actionSheetRate)
    }

    func onRateRandom() {
        
    }
    
    private func loadMovies() {
        movies = movieLoader.loadMoviesFromFile() ?? []
    }
    
    private func createActionSheetForRating(index: IndexPath) -> UIAlertController {
        let actionSheetRate = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        Rating.allCases.forEach { rating in
            actionSheetRate.addAction(UIAlertAction(title: rating.getStringValue(), style: .default,
                                                    handler: { _ in self.rateMovie(rating: rating, row: index.row) }))
        }
        actionSheetRate.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        return actionSheetRate
    }
    
    private func rateMovie(rating: Rating, row: Int) {
        movies[row].rating = rating
        movies.sort { (lhs, rhs) -> Bool in
            lhs.rating.rawValue > rhs.rating.rawValue
        }
        view?.reloadTable()
    }
}
