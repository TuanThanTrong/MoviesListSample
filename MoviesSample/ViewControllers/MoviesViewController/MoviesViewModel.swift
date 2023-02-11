//
//  MoviesViewModel.swift
//  MoviesSample
//
//  Created by TuanThan on 11/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

class MoviesViewModel: BaseViewModel {
    let getMoviesOnSuccess : Driver<Void>
    let onFailure : Driver<String>
    let textChangeEvent = BehaviorRelay<String>(value: "")
    private let getMoviesOnSuccessSubject = PublishSubject<Void>()
    private let onFailureSubject = PublishSubject<String>()
    let loadMoreEvent = PublishSubject<Void>()
    
    private var currentPage = 1
    var moviesList: [Movie] = []
    var isFirstLoad = true
    var totalResults = 0
    var textSearch: String?
    var isLoadingData = false
    
    //MARK: - Life cycle
    override init() {
        getMoviesOnSuccess = getMoviesOnSuccessSubject.asDriver(onErrorJustReturn: ())
        onFailure = onFailureSubject.asDriver(onErrorJustReturn: "")
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    private func resetPage() {
        currentPage = 1
        isFirstLoad = true
        isLoadingData = false
        moviesList.removeAll()
    }
    
    private func bindData() {
        textChangeEvent.filter { $0.count >= Configs.minCharacterForSearch }
             .subscribe(onNext: { [weak self] text in
                 guard let strongSelf = self, !text.isEmpty else { return }
                 strongSelf.resetPage()
                 strongSelf.textSearch = text.trim()
                 strongSelf.getMoviesList()
             }).disposed(by: disposeBag)
        
        loadMoreEvent.subscribe { [weak self] _ in
            guard let strongSelf = self else {return}
            strongSelf.currentPage += 1
            strongSelf.getMoviesList()
        }.disposed(by: disposeBag)

    }
    
    func canLoadmore() -> Bool {
        return moviesList.count < totalResults
    }
    
    func getMoviesList() {
        let moviesRequest = MoviesRequest(textSearch: textSearch, page: currentPage)
        guard let query = query(object: moviesRequest) else { return }
        if isFirstLoad {
            isLoadingSubject.onNext(true)
        }
        isLoadingData = true
        MoviesService.getMovieList(query: query) { [weak self] result, error in
            self?.isLoadingSubject.onNext(false)
            self?.isFirstLoad = false
            self?.isLoadingData = false
            if let movies = result?.movies, let totalResults = result?.totalResults {
                self?.totalResults = Int(totalResults) ?? 0
                self?.moviesList.append(contentsOf: movies)
                self?.getMoviesOnSuccessSubject.onNext(())
            } else if let error = error {
                self?.onFailureSubject.onNext(error.message)
            }
        }
    }
}

extension MoviesViewModel {
    struct Configs {
        static let minCharacterForSearch = 2
    }
}
