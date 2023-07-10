//
//  MapViewController.swift
//  MoviesSample
//
//  Created by TuanThan on 09/07/2023.
//

import UIKit
import UBottomSheet

class MapViewController: UIViewController {
    var sheetCoordinator: UBottomSheetCoordinator!
    @IBOutlet weak var deleteButonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButon: UIButton!
    var backView: PassThroughView?
    var dataSource: UBottomSheetCoordinatorDataSource?
    weak var sheetViewController: SheetViewController?
    var initHeight: CGFloat = 0.2
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = MapDataSource(initHeight: getInitHeight(), postions: [])
        //deleteButon.isHidden = true
    }

    @IBAction func addSheet(_ sender: UIButton) {
        if sheetCoordinator == nil {
            sheetCoordinator = UBottomSheetCoordinator(parent: self,
                                                       delegate: self)
        }
        
        let vc = SheetViewController()
        sheetViewController = vc
        vc.sheetCoordinator = sheetCoordinator
        sheetCoordinator.dataSource = dataSource
        vc.reloadDataCompleted = { [weak self] height in
            if let self = self {
                self.updateDaTaSoure(height: height)
            }
        }
        sheetCoordinator.addSheet(vc, to: self, animated: false, didContainerCreate: { container in
            let f = self.view.frame
            let rect = CGRect(x: f.minX, y: f.minY, width: f.width, height: f.height)
            container.roundCorners(corners: [.topLeft, .topRight], radius: 10, rect: rect)
        })
        sheetCoordinator.setCornerRadius(10)
    }
    
    private func updateDaTaSoure(height: CGFloat) {
        let heightScreen: CGFloat = height / UIScreen.main.bounds.height
        print("heightScreen: \(height)")
        let maxY = 1 - heightScreen
        dataSource = MapDataSource(initHeight: getInitHeight(), postions: [getInitHeight(), maxY])
        sheetCoordinator.dataSource = dataSource
    }
    
    @IBAction func removeSheet(_ sender: UIButton) {
        guard let sheet = sheetViewController else { return }
        sheetCoordinator.removeSheetChild(item: sheet)
    }
    
    @IBAction func resetSheet(_ sender: UIButton) {
        sheetCoordinator?.setPosition(getMinY(), animated: true)
    }
    
    func getInitHeight() -> CGFloat {
        let heightScreen: CGFloat = 240 / UIScreen.main.bounds.height
        return 1 - heightScreen
    }
    
    func getMinY() -> CGFloat {
        guard let parent = sheetCoordinator?.parent, let dataSource = sheetCoordinator?.dataSource else { return 0 }
        let availableHeight = parent.view.frame.height
        return parent.view.bounds.minY + dataSource.initialPosition(availableHeight)
    }
    
    func updateDeleteButton() {
        let sheetHeight: CGFloat = sheetViewController?.view.bounds.height ?? 0
        deleteButonBottomConstraint.constant = sheetHeight + 20
    }
}

extension MapViewController: UBottomSheetCoordinatorDelegate{

    func bottomSheet(_ container: UIView?, didPresent state: SheetTranslationState) {
//        self.addBackDimmingBackView(below: container!)
//        self.sheetCoordinator.addDropShadowIfNotExist()
//        self.handleState(state)
        updateDeleteButton()
    }

    func bottomSheet(_ container: UIView?, didChange state: SheetTranslationState) {
        handleState(state)
    }

    func bottomSheet(_ container: UIView?, finishTranslateWith extraAnimation: @escaping ((CGFloat) -> Void) -> Void) {
        extraAnimation({ percent in
            self.backView?.backgroundColor = UIColor.black.withAlphaComponent(percent/100 * 0.8)
        })
    }
    
    func handleState(_ state: SheetTranslationState){
        switch state {
        
        case .finished(_, _):
            updateDeleteButton()
        default:
            break
        }
    }

//    func handleState(_ state: SheetTranslationState){
//        switch state {
//        case .progressing(_, let percent):
//            self.backView?.backgroundColor = UIColor.black.withAlphaComponent(percent/100 * 0.8)
//        case .finished(_, let percent):
//                self.backView?.backgroundColor = UIColor.black.withAlphaComponent(percent/100 * 0.8)
//        default:
//            break
//        }
//    }
}

class MapDataSource: UBottomSheetCoordinatorDataSource {
    private var initHeight: CGFloat
    private var postions: [CGFloat]
    
    init(initHeight: CGFloat, postions: [CGFloat]) {
        self.initHeight = initHeight
        self.postions = postions
    }
    
    func sheetPositions(_ availableHeight: CGFloat) -> [CGFloat] {
        return postions.map{$0*availableHeight}
    }
    
    func initialPosition(_ availableHeight: CGFloat) -> CGFloat {
        return availableHeight*initHeight
    }
}
