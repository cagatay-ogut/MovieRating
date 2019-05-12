//
//  MovieRatingTests.swift
//  MovieRatingTests
//
//  Created by cagatay_personal on 11.05.19.
//  Copyright © 2019 cagatay. All rights reserved.
//

import XCTest
@testable import MovieRating

class MovieRatingTests: XCTestCase {

    var mockedMoviesVC: MockedMoviesVC!
    var moviesPresenter: MoviesPresenter<MockedMoviesVC>!

    override func setUp() {
        super.setUp()
        mockedMoviesVC = MockedMoviesVC()
        moviesPresenter = MoviesPresenter(view: mockedMoviesVC)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLoadedMoviesCount() {
        moviesPresenter.onViewLoaded()
        
        XCTAssert(moviesPresenter.movies.count == 10, "Loaded movies count is not equal to 10")
    }
    
    func testRateMovie() {
        moviesPresenter.onViewLoaded()
        let movieIdToBeRated = moviesPresenter.movies[3].id
        moviesPresenter.rateMovie(rating: .HIGH, row: 3)
        
        let newIndex = moviesPresenter.movies.firstIndex(where: { $0.id == movieIdToBeRated })
        
        XCTAssert(moviesPresenter.movies[newIndex!].rating == .HIGH, "Rating of a movie is not set properly")
        
        moviesPresenter.movies[newIndex!].rating = .NONE
    }
    
    func testRandomRateMovie() {
        moviesPresenter.onViewLoaded()
        moviesPresenter.onRateRandom()
        
        let expectation = self.expectation(description: "Waiting for at least one item to be rated")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + moviesPresenter.RANDOM_TIME_UPPER_LIMIT) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: moviesPresenter.RANDOM_TIME_UPPER_LIMIT + 1)
        
        XCTAssert(moviesPresenter.movies.contains(where: { movie -> Bool in
            movie.rating != .NONE
        }), "None of the movies are rated")
    }
}

class MockedMoviesVC: MoviesView {
    
    func reloadTable() {}
    func showRatingOptions(actionSheet: UIAlertController) {}
    func changeRandomRateButtonTitle(title: String) {}
}
