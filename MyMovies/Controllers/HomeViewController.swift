//
//  HomeViewController.swift
//  MyMovies
//
//  Created by David on 1/29/21.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let apiService:ApiService = ApiService()
    private var loadingAnimation: Animation!
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        searchBar.delegate = self

        moviesTableView.dataSource = self
        moviesTableView.register(UINib(nibName: Config.cellNibName, bundle: nil), forCellReuseIdentifier: Config.movieCellName)
        moviesTableView.rowHeight = moviesTableView.bounds.height
        
        loadingAnimation = Animation(parent: mainView, name: Config.loadingAnimationName, width: 100, height: 100, loop: true, color: .white)
        getPopularMovies()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func getPopularMovies() {
        loadingAnimation.show()
        apiService.getPopularMovies(){ result in
            print("result: \(result)")
            self.loadingAnimation.hide()
            if result.result {
                print("got movies")
                self.movies = result.data as! [Movie]
                
                DispatchQueue.main.async {
                    self.moviesTableView.reloadData()
                }
            } else {
                //self.errorLabel.text = result.data as? String
                //self.errorLabel.isHidden = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Config.homeToSearch {
            if let destinationVC = segue.destination as? SearchViewController {
                destinationVC.searchQuery = searchBar.text!
                searchBar.text = ""
                self.view.endEditing(true)
            }
        }
    }
        

}

//MARK: - UITableViewDataSource extension -
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(movies.count)
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: Config.movieCellName, for: indexPath) as! MovieCardViewCell
        let movie = movies[indexPath.row]
        cell.titleLabel.text = movie.title
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "YY/MM/dd"
        if let release = movie.releaseDate {
            cell.releaseLabel.text = dateFormatter.string(from: release)
        }
        cell.overviewLabel.text = movie.description
        var url = URL(string: movie.backdrop ?? "")
        cell.posterImage.kf.setImage(with: url)
        url = URL(string: movie.poster ?? "")
        cell.backgroundImage.kf.setImage(with: url)
        if let rating = movie.rating {
            cell.ratingLabel.text = String(rating)
        }
        
        return cell
    }    
}
//MARK: - UISearchBarDelegate extension -
extension HomeViewController: UISearchBarDelegate {
    //When the search button is pressed, we go to the search view controller
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: Config.homeToSearch, sender: self)
    }
}

