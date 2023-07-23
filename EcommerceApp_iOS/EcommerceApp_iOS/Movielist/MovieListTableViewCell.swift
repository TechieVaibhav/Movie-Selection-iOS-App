//
//  MovieListTableViewCell.swift
//  EcommerceApp_iOS
//
//  Created by Vaibhav Sharma on 21/06/23.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with movie: MovieList) {
        title.text = movie.movie
        movieImage.image = UIImage(named: movie.image)
        rating.text = ["\(movie.rating)", "10"].joined(separator: "/")
    }
    
}
