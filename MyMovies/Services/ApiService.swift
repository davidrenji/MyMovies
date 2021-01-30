//
//  ApiService.swift
//  MyMovies
//
//  Created by David on 1/29/21.
//

import Foundation
import Alamofire

struct ApiService {
    func login(email: String, password: String, onComplete: @escaping (ApiResult)->Void) -> Void {
        var apiResult = ApiResult()
        let _email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let _password  = password.trimmingCharacters(in: .whitespacesAndNewlines)
        var error = ""
        if _email == "" {
            error = "Please enter your email"
        }
        if _password == "" {
            error += "\nPlease enter your password"
        }
        
        if error != "" {
            apiResult.result = false
            apiResult.data = error
            return onComplete(apiResult)
        }
        
        //Preparing request to api
        let params: [String: String] = ["email" : _email, "password": _password]
        
        AF.request(Config.loginApiUrl, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .response { response in
                //debugPrint(response)
                
                do {
                    let data: [String: String] = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String : String]
                    
                    switch response.result {
                        case .success:
                            print("Validation Successful")
                            apiResult.result = true
                            apiResult.data = data["token"]
                        case .failure(_):
                            apiResult.result = false
                            apiResult.data = data["error"]
                    }
                    
                    onComplete(apiResult)
                    
                } catch let error {
                    print("Error", error)
                    apiResult.result = false
                    apiResult.data = error
                    onComplete(apiResult)
               }
        }
    }
    
    func getPopularMovies(onComplete: @escaping (ApiResult)->Void) -> Void {
        let url: String = "movie/popular"
        gethMovies(url: url, params: nil, onComplete: onComplete)
    }
    
    func searchMovies(query: String, onComplete: @escaping (ApiResult)->Void) -> Void {
        let url: String = "search/movie"
        let params: [String: String] = ["query" : query]
        gethMovies(url: url, params: params, onComplete: onComplete)
    }
    
    private func gethMovies(url: String, params: [String: String]?, onComplete: @escaping (ApiResult)->Void) -> Void {
        let url: String = Config.moviesApiUrl + url
        var _params: [String: String] = [:]
        if params != nil {
            _params = params!
        }
        _params.updateValue(Config.apiKey, forKey: "api_key")
        
        AF.request(url, method: .get, parameters: _params)
            .validate(statusCode: 200..<300)
            .response { response in
            debugPrint(response)
                var apiResult = ApiResult()
                do {
                    let data: [String: Any?] = try JSONSerialization.jsonObject(with: response.data!, options: []) as! [String : Any?]
                    
                    switch response.result {
                        case .success:
                            print("Validation Successful")
                            apiResult.result = true
                            
                            let moviewsRaw = data["results"] as! [[String: Any]]
                            
                            var movies: [Movie] = [Movie]()
                            for moviewRaw: [String: Any] in moviewsRaw {
                                var movie: Movie = Movie()
                                movie.title = moviewRaw["title"] as? String
                                movie.description = moviewRaw["overview"] as? String
                                movie.releaseDate = moviewRaw["release_date"] as? Date
                                movie.poster = Config.movieImageUrl + (moviewRaw["poster_path"] as? String ?? "")
                                movie.backdrop = Config.movieImageUrl + (moviewRaw["backdrop_path"] as? String ?? "")
                                movie.rating = moviewRaw["vote_average"] as? Double
                                movies.append(movie)
                            }
                            
                            apiResult.data = movies
                        case .failure(_):
                            apiResult.result = false
                            apiResult.data = data["error"] ?? "Error"
                    }
                    
                    onComplete(apiResult)
                    
                } catch let error {
                    print("Error", error)
                    apiResult.result = false
                    apiResult.data = error
                    onComplete(apiResult)
               }
        }
    }
}

