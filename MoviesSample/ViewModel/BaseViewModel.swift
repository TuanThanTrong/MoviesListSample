//
//  BaseViewModel.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    let isLoading : Driver<Bool>
    var disposeBag = DisposeBag()
    let isLoadingSubject = PublishSubject<Bool>()
    init() {
        isLoading = isLoadingSubject.asDriver(onErrorJustReturn: false)
    }
    
    func viewDidLoad() {
    }

    func viewWillAppear() {
    }
}
