//
//  AppFlowCoordinator.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 20/04/22.
//

import UIKit
/**
 AppFlowCoordinator to handle flow logic
 */
final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let moviesSceneDIContainer = appDIContainer.makeMoviesDIContainer()
        let flow = moviesSceneDIContainer.makeMoviesFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
