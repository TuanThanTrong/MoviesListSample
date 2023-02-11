//
//  NaviView.swift
//  MoviesSample
//
//  Created by TuanTT13 on 10/02/2023.
//

import UIKit

class NaviView: UIView {
    @IBOutlet weak var naviIconImageView: UIImageView!
    @IBOutlet var contentView:UIView!
    @IBOutlet weak var parentContentView: UIView!
    @IBOutlet weak var naviContentView: UIView!
    @IBOutlet weak var topConstraintNaviContentView: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.xibSetup()
        
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        if self.subviews.count == 0{
            self.xibSetup()
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }
    
    private func setupUI() {
        
    }
    
    private func xibSetup() {
        Bundle.main.loadNibNamed(NaviView.typeName, owner: self, options: nil)
        guard let content = contentView else { return }
        self.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false;
        content.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        //addShadow()
    }
    
    func embedInViewController(viewController: UIViewController) {
        viewController.view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
        NSLayoutConstraint.deactivate([self.topConstraintNaviContentView])
        self.naviContentView.topAnchor.constraint(equalTo: viewController.view.safeTopAnchor, constant: 0).isActive = true
    }
    
    func addShadow() {
        naviContentView.addShadow(offset: CGSize(width: 0, height: -3), color: AppColor.naviShadowColor, opacity: 0.3, radius: 3)
    }
}

extension UIView: NameDescribable {}
