//
//  MoviesViewController.swift
//  MovieRating
//
//  Created by cagatay_personal on 11.05.19.
//  Copyright © 2019 cagatay. All rights reserved.
//

import UIKit

protocol MoviesView: class {
    func reloadTable()
    func showRatingOptions(actionSheet: UIAlertController)
}

class MoviesViewController: UIViewController {

    var presenter: MoviesPresenter<MoviesViewController>!

    @IBOutlet var tableMovies: UITableView!
    @IBOutlet var buttonRateRandom: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MoviesPresenter(view: self)
        presenter.onViewLoaded()
        
        tableMovies.delegate = self
        tableMovies.dataSource = self
        
        title = "Top 10 IMDB movies"
    }
    
    @IBAction func onTapRateRandom(_ sender: UIBarButtonItem) {
        presenter.onRateRandom()
    }
}

extension MoviesViewController: MoviesView {
    
    func reloadTable() {
        tableMovies.reloadData()
    }
    
    func showRatingOptions(actionSheet: UIAlertController) {
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.permittedArrowDirections = .down
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY, width: 0, height: 0)
        }
        present(actionSheet, animated: true, completion: nil)
    }
}

extension MoviesViewController: MovieCellDelegate {
    
    func onRateMovie(cell: MovieCell) {
        if let index = tableMovies.indexPath(for: cell) {
            presenter.onRateMovie(index: index)
        }
    }
}

extension MoviesViewController: UITableViewDelegate {}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getMoviesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            print("Error while getting table cell for movies table")
            return UITableViewCell()
        }
        
        let movieViewModel = presenter.getMovieViewModel(index: indexPath)
        cell.populateCell(with: movieViewModel)
        cell.movieCellDelegate = self
        return cell
    }
}
