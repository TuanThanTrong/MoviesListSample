//
//  SheetViewController.swift
//  MoviesSample
//
//  Created by TuanThan on 09/07/2023.
//

import UIKit
import UBottomSheet

class SheetViewController: UIViewController {
    @IBOutlet weak var tableView: DynamicHeightTableView!
    
    var sheetCoordinator: UBottomSheetCoordinator?
    var reloadDataCompleted: ((CGFloat) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MapItemCell", bundle: nil), forCellReuseIdentifier: "MapItemCell")
        tableView.onUpdateContentHeight = { [weak self] height in
            self?.reloadDataCompleted?(height)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetCoordinator?.startTracking(item: self)
        tableView.reloadData()
    }

}

extension SheetViewController: Draggable{
    func draggableView() -> UIScrollView? {
        return tableView
    }
}

extension SheetViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapItemCell", for: indexPath) as! MapItemCell
        let title: String
        let subtitle: String
        switch indexPath.row {
        case 0:
            title = "Click To Add New Sheet"
            subtitle = "Row \(indexPath.row) (Move independently)"
        case 1:
            title = "Click To Add Sheet Child"
            subtitle = "Row \(indexPath.row) (Move all sheets together)"
        default:
            title = "No Action"
            subtitle = "Row \(indexPath.row)"
        }
        let model = MapItemCellViewModel(image: nil, title: title, subtitle: subtitle)
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
}
