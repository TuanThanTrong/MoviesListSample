//
//  DynamicHeightTableView.swift
//  MoviesSample
//
//  Created by TuanThan on 09/07/2023.
//

import Foundation
import UIKit

// MARK: - DynamicHeightTableView
final class DynamicHeightTableView: UITableView {
    var onUpdateContentHeight: ((CGFloat) -> Void)?

    override var contentSize: CGSize {
        didSet {
            onUpdateContentHeight?(contentSize.height)
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
