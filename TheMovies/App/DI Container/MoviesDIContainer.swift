//
//  MoviesDIContainer.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 20/04/22.
//

import UIKit

final class MoviesDIContainer {
   
    struct Dependencies {
        let apiDataService: NetworkService
        let imageDataService: ImageService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - List
    func makeMoviesListController(actions: MoviesViewModelActions) -> ListViewController {
        return ListViewController(viewModel: makeListViewModel(actions: actions))
    }
    func makeListViewModel(actions: MoviesViewModelActions) -> ListViewModel {
        return ListViewModelImpl(service: MoviesServiceImpl(networkService: dependencies.apiDataService), actions: actions, imageService: dependencies.imageDataService)
    }
    // MARK: - Detail
    func makeMoviesDetailController(movieDetail: MovieDetail) -> MovieDetailViewController {
        return MovieDetailViewController(viewModel: makeDetailViewModel(movieDetail: movieDetail))
    }
    func makeDetailViewModel(movieDetail: MovieDetail) -> MovieDetailViewModel {
        return MovieDetailViewModelImpl(movieDetail: movieDetail, imageService: dependencies.imageDataService)
    }
    // MARK: - Flow Coordinators
    func makeMoviesFlowCoordinator(navigationController: UINavigationController) -> MoviesFlowCoordinator {
        return MoviesFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }
}
extension MoviesDIContainer: MoviesFlowCoordinatorDependencies {}
