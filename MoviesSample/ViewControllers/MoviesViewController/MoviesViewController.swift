//
//  ViewController.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import UIKit
import RxSwift

class MoviesViewController: BaseViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var movieCollectionView: UICollectionView!
    @IBOutlet private weak var moviesNotFoundLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        bindViewModelToView()
        bindAction()
    }

    override func setupUI() {
        super.setupUI()
        movieCollectionView.register(MovieItemCollectionViewCell.self)
        movieCollectionView.registerFooterNib(LoadmoreReusableView.self)
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
    }
    
    private func setupSearchBar() {
        searchBar.setTextField(color: .white)
        searchBar.layer.borderColor = searchBar.barTintColor?.cgColor
        searchBar.backgroundColor = searchBar.barTintColor
        searchBar.addShadow(offset: CGSize(width: 0, height: 3), color: AppColor.blackShadow, opacity: 0.2, radius: 3)
    }
    
    private func updateUI() {
        guard let moviesViewModel = viewModel as? MoviesViewModel else { return }
        moviesNotFoundLabel.isHidden = !moviesViewModel.moviesList.isEmpty
        movieCollectionView.isHidden = moviesViewModel.moviesList.isEmpty
    }
    
    private func bindAction() {
        guard let moviesViewModel = viewModel as? MoviesViewModel else { return }
        searchBar.rx.text
            .orEmpty
            .debounce(DispatchTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(to: moviesViewModel.textChangeEvent)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModelToView() {
        guard let moviesViewModel = viewModel as? MoviesViewModel else { return }
        moviesViewModel.isLoading.drive(
            self.rx.isAnimating
        ).disposed(by: disposeBag)
        
        moviesViewModel.onFailure.drive(onNext: { [weak self] (errorString) in
            moviesViewModel.moviesList.removeAll()
            self?.updateUI()
            self?.movieCollectionView.reloadData()
        })
        .disposed(by: disposeBag)
        moviesViewModel.getMoviesOnSuccess.drive(onNext: { [weak self] _ in
            self?.updateUI()
            self?.movieCollectionView.reloadData()
        })
        .disposed(by: disposeBag)
    }
    
    private func configureCell(cell: MovieItemCollectionViewCell, indexPath: IndexPath) {
        guard let moviesViewModel = viewModel as? MoviesViewModel else { return }
        cell.movie = moviesViewModel.moviesList[indexPath.row]
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let moviesViewModel = viewModel as? MoviesViewModel else { return 0 }
        return moviesViewModel.moviesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MovieItemCollectionViewCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel as? MoviesViewModel else { return }
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1, viewModel.canLoadmore(), !viewModel.isLoadingData {
            viewModel.loadMoreEvent.onNext(())
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let reusableview = collectionView.dequeueReusableFooterView(forIndexPath: indexPath) as LoadmoreReusableView
            return reusableview
        default:  fatalError("Unexpected element kind")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (movieCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: Configs.itemHeight)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let viewModel = viewModel as? MoviesViewModel else {
            return .zero
        }
        let viewWidth = self.view.frame.width
        var viewHeight = Configs.footerHeight
        if !viewModel.canLoadmore() {
            viewHeight = 0
        }
        return CGSize(width: viewWidth, height: viewHeight)
    }
}

extension MoviesViewController {
    struct Configs {
        static let footerHeight: CGFloat = 67.0
        static let itemHeight: CGFloat = 250.0
    }
}
