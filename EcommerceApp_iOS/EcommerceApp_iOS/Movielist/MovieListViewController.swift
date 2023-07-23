//
//  MovieListViewController.swift
//  EcommerceApp_iOS
//
//  Created by Vaibhav Sharma on 21/06/23.
//

import UIKit

class MovieListViewController: UIViewController {
    
    var movieList: [MovieList]?
    
    let movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "MovieListTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieListTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        loadData()
        // Ensure that the navigation bar is always shown
        navigationController?.isNavigationBarHidden = false
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    private func setupUI() {
        view.addSubview(movieTableView)
        
        NSLayoutConstraint.activate([
            movieTableView.topAnchor.constraint(equalTo: view.topAnchor),
            movieTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        movieTableView.dataSource = self
        movieTableView.delegate = self
    }
    private func loadData() {
        // Simulated movie data
        movieList = [MovieList(movie: "Adipurush", rating: 4.6, image: "adhipursh",showtimes: ["10:00 AM", "2:00 PM", "6:00 PM","9:00 PM","11:00 PM"]),
                     MovieList(movie: "Bholaa", rating: 4.6, image: "bhola",showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "The Shawshank Redemption", rating: 9.2, image: "1",showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "The Dark Knight", rating: 5.0, image: "8",showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "Pulp Fiction", rating: 5.0, image: "4",showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "Fight Club", rating: 4.5, image: "9",showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "The Lord of the Rings: The Return of the King", rating: 9.2, image: "5",showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "The Lord of the Rings: The Fellowship of the Ring", rating: 9.2, image: "4", showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "Inception", rating: 9.2, image: "inception", showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "The Godfather Part II", rating: 9.2, image: "GD", showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "12 Angry Men", rating: 9.2, image: "2", showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "Forrest Gump", rating: 3.2, image: "FF", showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "The Godfather", rating: 1.5, image: "GD", showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "Schindler's List", rating: 9.2, image: "Schindler's List", showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
                     MovieList(movie: "The Lord of the Rings: The Return of the King", rating: 9.2, image: "4", showtimes: ["10:00 AM", "2:00 PM", "6:00 PM"]),
        ]
        movieTableView.reloadData()
    }
    
}

extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListTableViewCell", for: indexPath) as! MovieListTableViewCell
        guard let movie = movieList?[indexPath.row] else {
            return cell
        }
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "MovieSelectionViewController") as? MovieSelectionViewController else {
            return
        }
        vc.selectedMovie = movieList?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
}
