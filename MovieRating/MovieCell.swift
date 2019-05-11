//
//  MovieCell.swift
//  MovieRating
//
//  Created by cagatay_personal on 11.05.19.
//  Copyright © 2019 cagatay. All rights reserved.
//

import UIKit

protocol MovieCellDelegate: class {
    func onRateMovie(cell: MovieCell)
}

struct MovieViewModel {
    var name: String?
    var rating: String?
}

class MovieCell: UITableViewCell {

    weak var movieCellDelegate: MovieCellDelegate?

    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelRating: UILabel!
    
    @IBAction func onTapRate(_ sender: UIButton) {
        movieCellDelegate?.onRateMovie(cell: self)
    }
    
    func populateCell(with movie: MovieViewModel) {
        labelName.text = movie.name
        labelRating.text = movie.rating
    }
}
