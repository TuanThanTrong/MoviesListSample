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
    let getMoviesOnSuccess : Driver<[Movie]>
    let onFailure : Driver<String>
    let textChangeEvent = BehaviorRelay<String>(value: "")
    private let getMoviesOnSuccessSubject = PublishSubject<[Movie]>()
    private let onFailureSubject = PublishSubject<String>()
    
    //MARK: - Life cycle
    override init() {
        getMoviesOnSuccess = getMoviesOnSuccessSubject.asDriver(onErrorJustReturn: [])
        onFailure = onFailureSubject.asDriver(onErrorJustReturn: "")
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    private func bindData() {
        textChangeEvent.filter { $0.count >= Configs.minCharacterForSearch }
             .subscribe(onNext: { [weak self] textSearch in
                 guard let strongSelf = self, !textSearch.isEmpty else { return }
                 strongSelf.getMoviesList(text: textSearch.trim())
             }).disposed(by: disposeBag)
    }
    
    func getMoviesList(text: String) {
        let moviesRequest = MoviesRequest(searchText: text)
        guard let query = query(object: moviesRequest) else { return }
        isLoadingSubject.onNext(true)
        MoviesService.getMovieList(query: query) { [weak self] movies, error in
            self?.isLoadingSubject.onNext(false)
            if let movies = movies {
                self?.getMoviesOnSuccessSubject.onNext(movies)
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
