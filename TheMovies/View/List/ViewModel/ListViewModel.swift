//
//  ListViewModel.swift
//  TheMovies
//
//  Created by Tannu Kaushik on 20/04/22.
//

import Foundation

struct MoviesViewModelActions {
    let showMovieDetail: (MovieDetail) -> Void
}
protocol ListViewModelInput {
    func loadData(_ page: Int)
    func didSelectItem(at index: Int)
    func handlePagination(at index: Int)
}
protocol ListViewModelOutput {
    var didShowError: ((String, String) -> Void)? {get set}
    var didReload: (() -> Void)? {get set}
    var didStartLoading: (() -> Void)? {get set}
    var didStopLoading: (() -> Void)? {get set}
    var imageService: ImageService {get}
    func getListCount() -> Int
    func getMovieData(index: Int) -> Result
}

protocol ListViewModel : ListViewModelInput, ListViewModelOutput {}

final class ListViewModelImpl: ListViewModel {
    
    var didStartLoading: (() -> Void)?
    var didStopLoading: (() -> Void)?
    var didShowError: ((String, String) -> Void)?
    var didReload: (() -> Void)?

    private let actions: MoviesViewModelActions?
    private var service: MoviesService
    var imageService: ImageService
    private enum State {
        case loading, loaded, paginating, error
    }
    private var state = State.loading
    
    init(service: MoviesService, actions: MoviesViewModelActions? = nil, imageService: ImageService) {
        self.service = service
        self.actions = actions
        self.imageService = imageService
    }
    
    private var data: MovieData?
    private var list: [Result] = [] {
        didSet {
            didReload?()
        }
    }
    
    private func fetchData(_ page: Int) async {
        do {
            async let movieData: MovieData = try await service.getMovieList(for: page)
            let fetchedData = try await movieData
            self.data = fetchedData
            self.didStopLoading?()
            self.list.append(contentsOf: fetchedData.results)
            self.state = .loaded
        } catch let error as HTTPError {
            //Handle error here
            self.state = .error
            self.didStopLoading?()
            self.didShowError?(error.errorTitle, error.errorDescription)
        } catch {
            self.state = .error
            self.didStopLoading?()
            self.didShowError?("Error", error.localizedDescription)
        }
    }
    
    private func fetchDetailData(movieId: Int) async {
        do {
            async let movieDetail: MovieDetail = try await service.getMovieDetail(for: movieId)
            let fetchedMovieDetail = try await movieDetail
            self.didStopLoading?()
            DispatchQueue.main.async {
                self.actions?.showMovieDetail(fetchedMovieDetail)
            }
        } catch let error as HTTPError {
            //Handle error here
            self.didStopLoading?()
            self.didShowError?(error.errorTitle, error.errorDescription)
        } catch {
            self.didStopLoading?()
            self.didShowError?("Error", error.localizedDescription)
        }
    }
}
///ListViewModelInput methods
extension ListViewModelInput {
    func loadData(_ page: Int = 1) {
        return loadData(page)
    }
}
extension ListViewModelImpl {
    func loadData(_ page: Int) {
        self.didStartLoading?()
        Task {
            await self.fetchData(page)
        }
    }
    
    func didSelectItem(at index: Int) {
        self.didStartLoading?()
        Task {
            await self.fetchDetailData(movieId: list[index].id)
        }
    }
    
    func handlePagination(at index: Int) {
        if let movieData = self.data, state != .paginating, index == list.count - 1, movieData.totalPages > list.count {
            loadData(movieData.page+1)
        }
    }
}
///ListViewModelOutput methods
extension ListViewModelImpl {
    
    func getListCount() -> Int {
        return list.count
    }
    
    func getMovieData(index: Int) -> Result {
        return list[index]
    }
}
