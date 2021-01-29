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
        
        let params: [String: String] = ["email" : email, "password": password]
        
        AF.request(Config.loginApiUrl, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .response { response in
            debugPrint(response)
                var apiResult = ApiResult()
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
        
        let url: String = Config.moviesApiUrl + "movie/popular"
        let params: [String: String] = ["api_key" : Config.apiKey]
        
        
        AF.request(url, method: .get, parameters: params)
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
                                movie.poster = Config.movieImageUrl + (moviewRaw["backdrop_path"] as? String ?? "")
                                movie.rating = moviewRaw["vote_average"] as? Double
                                movies.append(movie)
                            }
                            
                            apiResult.data = movies
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
}

