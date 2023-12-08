//
//  AppDIContainer.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 20/04/22.
//

import Foundation
/**
 Dependency Injection Container
 **/
final class AppDIContainer {

    lazy var apiDataTransferService: NetworkService = NetworkServiceImpl()
    lazy var imageDataTransferService: ImageService = ImageServiceImpl()
    
    // MARK: - DIContainers
    func makeMoviesDIContainer() -> MoviesDIContainer {
        let dependencies = MoviesDIContainer.Dependencies(apiDataService: apiDataTransferService,
                                                               imageDataService: imageDataTransferService)
        return MoviesDIContainer(dependencies: dependencies)
    }
}
