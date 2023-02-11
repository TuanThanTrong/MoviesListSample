//
//  MovieItemCollectionViewCell.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import UIKit
import SDWebImage

class MovieItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var movie: Movie? {
        didSet {
            setupData()
        }
    }
    
    func setupData() {
        titleLabel.text = movie?.title
        yearLabel.text = movie?.year
        posterImageView.sd_setImage(with: URL(string: movie?.poster ?? ""), placeholderImage: nil)
    }
}
