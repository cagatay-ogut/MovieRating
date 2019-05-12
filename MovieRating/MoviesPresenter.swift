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

    let RANDOM_TIME_UPPER_LIMIT: Double = 4

    let movieLoader = MovieLoader()
    var movies: [Movie] = []
    
    var timerRandomRate: Timer?
    var isRatingRandomly = false

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
        if !isRatingRandomly {
            startRatingMoviesRandomly()
            view?.changeRandomRateButtonTitle(title: "Stop Random Rating")
        } else {
            stopRatingMoviesRandomly()
            view?.changeRandomRateButtonTitle(title: "Rate Random")
        }
        isRatingRandomly.toggle()
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
    
    func rateMovie(rating: Rating, row: Int) {
        movies[row].rating = rating
        movies.sort { (lhs, rhs) -> Bool in
            lhs.rating.rawValue > rhs.rating.rawValue
        }
        view?.reloadTable()
    }
    
    private func startRatingMoviesRandomly() {
        timerRandomRate = Timer.scheduledTimer(withTimeInterval: getRandomTime(upTo: RANDOM_TIME_UPPER_LIMIT), repeats: true) { _ in
            self.rateAMovieRandomly()
            self.view?.reloadTable()
        }
    }
    
    private func stopRatingMoviesRandomly() {
        timerRandomRate?.invalidate()
    }
    
    private func rateAMovieRandomly() {
        rateMovie(rating: getRandomRating(), row: getRandomMovieIndex())
    }
    
    private func getRandomTime(upTo seconds: Double) -> Double {
        return Double.random(in: 0...seconds)
    }
    
    private func getRandomMovieIndex() -> Int {
        return Int.random(in: 1..<movies.count)
    }
    
    private func getRandomRating() -> Rating {
        let ratingInt = Int.random(in: Rating.VERY_LOW.rawValue...Rating.VERY_HIGH.rawValue)
        return Rating(rawValue: ratingInt)!
    }
}
