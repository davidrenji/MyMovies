//
//  Config.swift
//  MyMovies
//
//  Created by David on 1/28/21.
//

import Foundation


struct Config {
    static let apiKey: String = "c9c9a655d97d8c7d9eaa561c91555a6d"
    static let loginApiUrl: String = "https://reqres.in/api/login"
    static let moviesApiUrl: String = "https://api.themoviedb.org/3/"
    static let movieImageUrl: String = "https://image.tmdb.org/t/p/w500"
    
    static let loginToHome: String = "loginToHome"
    static let homeToSearch: String = "homeToSearch"
    
    static let cellNibName = "MovieCardViewCell"
    static let movieCellName: String = "movieCell"
    
    static let loadingAnimationName: String = "loading-spinner"
}
