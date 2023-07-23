//
//  MovieSelectionViewController.swift
//  EcommerceApp_iOS
//
//  Created by Vaibhav Sharma on 21/06/23.
//

import UIKit

// Ticket struct to represent a movie ticket
struct Ticket {
    let movie: MovieList
    let showtime: String
    let quantity: Int
}

class MovieSelectionViewController: UIViewController {
    
    let movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.register(SeatSelectionTableViewCell.self, forCellReuseIdentifier: "SeatSelectionTableViewCell")
        return tableView
    }()
    
    let bookButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Book", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    
    var selectedMovie: MovieList?{
        didSet{
            if let selectedMovie = selectedMovie{
                self.title = selectedMovie.movie
                self.movieTableView.reloadData()
            }
        }
    }
    
    var selectedShowTime: String?
    var selectedQuantity: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    private func setupUI() {
        self.view.addSubview(movieTableView)
        self.view.addSubview(bookButton)
        
        NSLayoutConstraint.activate([
            movieTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            movieTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            bookButton.topAnchor.constraint(equalTo: movieTableView.bottomAnchor, constant: 8),
            bookButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            bookButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            bookButton.heightAnchor.constraint(equalToConstant: 40),
            bookButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16)
            
        ])
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        bookButton.addTarget(self, action: #selector(bookButtonTapped), for: .touchUpInside)
    }
    
    @objc func bookButtonTapped(){
        guard let showtime = selectedShowTime, !showtime.isEmpty else {
            showPopupSelectedShowTimeFirst()
            return
        }
        showBookingSuccessPopup()
    }
    
    func showBookingSuccessPopup() {
        let alertController = UIAlertController(title: "Booking Successful", message: "Your ticket has been booked successfully.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Get the currently visible view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showPopupSelectedShowTimeFirst() {
        let alertController = UIAlertController(title: "Select Showtime", message: "Please select a showtime to continue.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Get the currently visible view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    func showPopupSelectedseatFirst() {
        let alertController = UIAlertController(title: "Select Seat", message: "Please select a seat to continue.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Get the currently visible view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }

}


extension MovieSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
            guard let movie = selectedMovie else { return cell }
            cell.configure(with: movie, selectedQuantity: selectedQuantity, selectedShowtime: selectedShowTime)
            cell.delegate = self
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeatSelectionTableViewCell", for: indexPath) as! SeatSelectionTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return UITableView.automaticDimension
        } else {
            return 280
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MovieSelectionViewController: MovieTableViewCellDelegate {
    func didSelectShowtime(_ showtime: String) {
        selectedShowTime = showtime
        self.movieTableView.reloadData()
    }
    
    func didSelectQuantity(_ quantity: Int) {
        selectedQuantity = quantity
        self.movieTableView.reloadData()
    }
}

protocol MovieTableViewCellDelegate: AnyObject {
    func didSelectShowtime(_ showtime: String)
    func didSelectQuantity(_ quantity: Int)
}

class MovieTableViewCell: UITableViewCell {
    
    var selectedShowtime: String?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let showtimeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ShowtimeCollectionViewCell.self, forCellWithReuseIdentifier: "ShowtimeCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let quantityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 1
        stepper.maximumValue = 10
        stepper.stepValue = 1
        stepper.value = 1
        return stepper
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var movie: MovieList?
    weak var delegate: MovieTableViewCellDelegate?
    var selectedQuantity: Int = 0 {
        didSet {
            quantityLabel.text = "How many seats?: \(selectedQuantity)"
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        contentView.addSubview(showtimeCollectionView)
        contentView.addSubview(quantityStepper)
        // Add quantity label to the cell's contentView
        contentView.addSubview(quantityLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            showtimeCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            showtimeCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            showtimeCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            showtimeCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            quantityStepper.topAnchor.constraint(equalTo: showtimeCollectionView.bottomAnchor, constant: 8),
            quantityStepper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            quantityStepper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        selectedQuantity = 0 // Set initial selected quantity to 0
        // Add constraints to the quantity label
        NSLayoutConstraint.activate([
            quantityLabel.topAnchor.constraint(equalTo: showtimeCollectionView.bottomAnchor, constant: 8),
            quantityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            quantityLabel.trailingAnchor.constraint(equalTo: quantityStepper.leadingAnchor, constant: -8),
            quantityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        showtimeCollectionView.delegate = self
        showtimeCollectionView.dataSource = self
    }
    
    func configure(with movie: MovieList, selectedQuantity: Int, selectedShowtime: String? = nil) {
        self.movie = movie
        titleLabel.text = movie.movie + "\n" + "PVR : Noida" + "\n" + "Showtime"
        self.selectedQuantity = selectedQuantity
        // Add target action to the quantity stepper
        quantityStepper.addTarget(self, action: #selector(quantityStepperValueChanged(_:)), for: .valueChanged)
        self.selectedShowtime = selectedShowtime
        showtimeCollectionView.reloadData()
    }
    
    @objc func quantityStepperValueChanged(_ stepper: UIStepper) {
        let quantity = Int(stepper.value)
        delegate?.didSelectQuantity(quantity)
    }
}

extension MovieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie?.showtimes.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowtimeCell", for: indexPath) as! ShowtimeCollectionViewCell
        guard let showtime = movie?.showtimes[indexPath.item] else {
            return cell
        }
        cell.showtimeLabel.text = showtime
        cell.handleSelection(isItemSelected: showtime == selectedShowtime)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let showtime = movie?.showtimes[indexPath.item] else {
            return .zero
        }
        let width = showtime.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]).width + 20
        let height: CGFloat = 30
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = movie else {
            return
        }
        let showtime = movie.showtimes[indexPath.item]
        delegate?.didSelectShowtime(showtime)
    }
}



class ShowtimeCollectionViewCell: UICollectionViewCell {
    
    var isItemSelected: Bool = false
    
    let showtimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.clear
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 1.0
        label.layer.cornerRadius = 1.0
        label.clipsToBounds = true
        return label
    }()
    
    func handleSelection(isItemSelected : Bool) {
        self.isItemSelected = isItemSelected
        print("isSelected: \(isItemSelected)")
        contentView.backgroundColor = isItemSelected ? UIColor(red: 0/255, green: 100/255, blue: 0/255, alpha: 1.0)
        : UIColor(red: 144/255, green: 255/255, blue: 144/255, alpha: 1.0)
        showtimeLabel.textColor = isItemSelected ? UIColor.white : UIColor.darkGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(showtimeLabel)
        
        NSLayoutConstraint.activate([
            showtimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            showtimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            showtimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            showtimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

public enum SeatAvailability {
    case empty
    case full
}

class SeatSelectionTableViewCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    var sectionName : [String] = ["Silver","Golden", "Platinum","Premium"]
    
    var selectedIndexPath: [IndexPath: SeatAvailability] = [:]
    
    let seatCollectionView: UICollectionView = {
        // Set up the collection view layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8.0
        layout.minimumLineSpacing = 8.0
        layout.itemSize = CGSize(width: 32.0, height: 32.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SeatCollectionViewCell.self, forCellWithReuseIdentifier: "SeatCell")
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderView")

        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(seatCollectionView)
        
        NSLayoutConstraint.activate([
            seatCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            seatCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            seatCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            seatCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        seatCollectionView.dataSource = self
        seatCollectionView.delegate = self
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4 // Number of rows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16// Number of seats per row
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCell", for: indexPath) as! SeatCollectionViewCell
        // Configure the cell
        let seatAvailability = selectedIndexPath[indexPath] ?? .empty
        cell.configure(with: seatAvailability)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SeatCollectionViewCell else {
            return
        }
        
        let currentAvailability = selectedIndexPath[indexPath] ?? .empty
        let updatedAvailability: SeatAvailability = (currentAvailability == .empty) ? .full : .empty
        selectedIndexPath[indexPath] = updatedAvailability
        cell.configure(with: updatedAvailability)
    }

    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 32.0, height: 32.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           return CGSize(width: collectionView.frame.width, height: 50) // Adjust the height as needed
       }

       func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           if kind == UICollectionView.elementKindSectionHeader {
               let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as! SectionHeaderView
               headerView.titleLabel.text = "PVR \(sectionName[indexPath.section])"
               return headerView
               
           }
           return UICollectionReusableView()
       }
    
    private func getAlphabetForRow(_ row: Int) -> String {
        let alphabetArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P"] // Add more alphabets as needed
        return alphabetArray[row % alphabetArray.count]
    }
   
}

class SeatCollectionViewCell: UICollectionViewCell {
    
    let seatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        
        // Add seat image view
        seatImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(seatImageView)
        NSLayoutConstraint.activate([
            seatImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            seatImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            seatImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            seatImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with availability: SeatAvailability) {
        switch availability {
        case .empty:
            seatImageView.image = UIImage(named: "empty_seat")
        case .full:
            seatImageView.image = UIImage(named: "full_seat")
        }
    }
}

class SectionHeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    private func setupViews() {
        addSubview(titleLabel)

        // Set constraints for the titleLabel
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
