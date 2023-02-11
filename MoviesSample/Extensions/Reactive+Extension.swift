//
//  Reactive+Extension.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: BaseViewController {
    internal var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.showProgress(true)
            } else {
                vc.showProgress(false)
            }
        })
    }
}
