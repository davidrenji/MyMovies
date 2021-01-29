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
    private let apiService:ApiService = ApiService()
    private var loadingAnimation: Animation!
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        moviesTableView.dataSource = self
        moviesTableView.register(UINib(nibName: Config.cellNibName, bundle: nil), forCellReuseIdentifier: Config.movieCellName)
        
        loadingAnimation = Animation(parent: mainView, name: Config.loadingAnimationName, width: 100, height: 100, loop: true, color: UIColor(named: "Color1")!)
        getPopularMovies()
        
    }
    
    func getPopularMovies() {
        //loadingAnimation.show()
        /*
        movies = [
            Movie(title: "test", releaseDate: nil, description: nil, poster: nil),
            Movie(title: "test 2", releaseDate: nil, description: nil, poster: nil),
            Movie(title: "test 3", releaseDate: nil, description: nil, poster: nil)
        ]
        DispatchQueue.main.async {
            print("movies: \(self.movies.count)")
            self.moviesTableView.reloadData()
        }
        return;
         */
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
        let url = URL(string: movie.poster ?? "")
        cell.posterImage.kf.setImage(with: url)
        if let rating = movie.rating {
            cell.ratingLabel.text = String(rating)
        }
        
        
//        if let data = try? Data(contentsOf: (URL(string: movie.poster ?? "") ?? URL(string: ""))!) {
//                        if let poster = UIImage(data: data) {
//                            cell.posterImage.image = poster
//                        }
//                    }
        
        
        
        return cell
    }
    
    
}
