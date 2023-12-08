//
//  MovieDetailViewModel.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 23/04/22.
//

import Foundation

protocol MovieDetailViewModel : MovieDetailViewModelOutput {}

protocol MovieDetailViewModelOutput {
    
    var title: String {get}
    var description: String {get}
    var releaseYear: String {get}
    var rating: String {get}
    var runTime: String {get}
    func getGenreListCount() -> Int
    func getGenre(for index: Int) -> String
    func getImageData() async -> Data?
}

final class MovieDetailViewModelImpl: MovieDetailViewModel {
    
    var didShowError: ((String, String) -> Void)?
    var title: String {
        return movieDetail.title
    }
    var description: String {
        return movieDetail.overview ?? "No overview available"
    }
    var releaseYear: String {
        if let date = movieDetail.releaseDate.getDate() {
            let year = Calendar.current.component(.year, from: date)
            return String(year)
        }
        return ""
    }
    
    var runTime: String {
        if let runtime = movieDetail.runtime {
            let (hour, min) = (runtime/60, runtime%60)
            return "- \(hour)h \(min)m"
        }
        return ""
    }
    var rating: String {
        return String(movieDetail.voteAverage)
    }
    private let movieDetail: MovieDetail
    internal let imageService: ImageService
    
    init(movieDetail: MovieDetail, imageService: ImageService) {
        self.movieDetail = movieDetail
        self.imageService = imageService
    }
}

extension MovieDetailViewModelImpl {
    func getGenreListCount() -> Int {
        return movieDetail.genres.count
    }
    func getGenre(for index: Int) -> String {
        return movieDetail.genres[index].name
    }
    
    func getImageData() async -> Data? {
        guard let urlPath = movieDetail.posterPath else {
            return nil
        }
        do {
            return try await imageService.load(urlPath: urlPath)
        } catch {
            return nil
        }
    }
}
