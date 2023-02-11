//
//  BaseViewController.swift
//  ThanTrongTuan_iOS_Test
//
//  Created by Tuan Than on 5/14/20.
//  Copyright © 2020 Tuan Than. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    let navi = NaviView()
    var disposeBag = DisposeBag()
    var viewModel: BaseViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        bindViewModel()
        setupNavi()
        setupUI()
        setupDataInViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDataInViewWillAppear()
    }
    
    func setupDataInViewDidLoad() {
        guard let viewModel = self.viewModel else { return }
        viewModel.viewDidLoad()
    }

    func setupDataInViewWillAppear() {
        guard let viewModel = self.viewModel else { return }
        viewModel.viewWillAppear()
    }
    
    func setupNavi() {
        navi.embedInViewController(viewController: self)
    }
    
    func setupUI() {
    }
    
    func bindViewModel() {
    }
}

extension BaseViewController {
    func showProgress(_ isShow: Bool) {
        SVProgressHUD.setDefaultMaskType(.clear)
        if isShow {
            //show
            DispatchQueue.main.async {
                SVProgressHUD.show()
            }
        } else {
            //hide
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
        }
    }
}
