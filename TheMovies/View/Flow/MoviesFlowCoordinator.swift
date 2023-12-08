//
//  MoviesFlowCoordinator.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 20/04/22.
//

import UIKit

protocol MoviesFlowCoordinatorDependencies  {
    func makeMoviesListController(actions: MoviesViewModelActions) -> ListViewController
    func makeMoviesDetailController(movieDetail: MovieDetail) -> MovieDetailViewController
}
final class MoviesFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MoviesFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController,
         dependencies: MoviesFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = MoviesViewModelActions(showMovieDetail: showMovieDetails)
        let vc = dependencies.makeMoviesListController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
    }
    private func showMovieDetails(movieDetail: MovieDetail) {
        let vc = dependencies.makeMoviesDetailController(movieDetail: movieDetail)
        navigationController?.pushViewController(vc, animated: true)
    }
}
