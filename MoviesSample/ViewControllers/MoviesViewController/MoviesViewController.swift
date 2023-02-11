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
    
    var moviesList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        bindViewModelToView()
        bindAction()
    }

    override func setupUI() {
        super.setupUI()
        movieCollectionView.register(MovieItemCollectionViewCell.self)
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
        moviesNotFoundLabel.isHidden = !moviesList.isEmpty
        movieCollectionView.isHidden = moviesList.isEmpty
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
            self?.moviesList = []
            self?.updateUI()
            self?.movieCollectionView.reloadData()
        })
        .disposed(by: disposeBag)
        moviesViewModel.getMoviesOnSuccess.drive(onNext: { [weak self](movies) in
            self?.moviesList = movies
            self?.updateUI()
            self?.movieCollectionView.reloadData()
        })
        .disposed(by: disposeBag)
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as MovieItemCollectionViewCell
        cell.movie = moviesList[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (movieCollectionView.frame.size.width - space) / 2.0
            return CGSize(width: size, height: 250)
        }
}
