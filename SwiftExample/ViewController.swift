//
//  ViewController.swift
//  Example Project
//
//  Created by Владислав  on 01.02.17.
//  Copyright © 2017 Vladislav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum CellType {
        case standart
        case withStatus
        case onView
        case onViewWithStatus
        case delayedDismiss
        case imageProgress
    }
    
    var cells:[CellType] = [.standart, .withStatus,
                            .onView, .onViewWithStatus,
                            .delayedDismiss, .imageProgress]
    
    let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        addStopBarItem()
    }

    fileprivate func setupViewController() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        KVSpinnerView.settings.animationStyle = .standart
    }
    
    fileprivate func addStopBarItem() {
        let settingsItem = UIBarButtonItem(title: "Stop",
                                             style: .plain,
                                             target: self,
                                             action: #selector(stopAction(sender:)))
        navigationItem.rightBarButtonItem = settingsItem
    }
    
    fileprivate func downloadHugeImage() {
        KVSpinnerView.showProgress(saying: "Image loading")
        networkManager.progressHandler = { progress in
            KVSpinnerView.handle(progress: progress)
        }
        networkManager.downloadCompletion = { image in
            KVSpinnerView.dismiss()
        }
        networkManager.downloadImage()
    }

    func stopAction(sender: Any) {
        KVSpinnerView.dismiss()
    }
    
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! TableViewCell
        switch cells[indexPath.row] {
        case .standart:
			cell.titleLabel.text = "Standart Animation with long text"
        case .withStatus:
            cell.titleLabel.text = "Standart Animation with status"
        case .onView:
            cell.titleLabel.text = "Standart Animation on view"
        case .onViewWithStatus:
            cell.titleLabel.text = "Standart Animation on view with status"
        case .delayedDismiss:
            cell.titleLabel.text = "Delayed Dismiss"
        case .imageProgress:
            cell.titleLabel.text = "Load huge image"
        }
    	return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
		return 1
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch cells[indexPath.row] {
        case .standart:
            KVSpinnerView.settings.animationStyle = .standart
            KVSpinnerView.show()
        case .withStatus:
            KVSpinnerView.settings.animationStyle = .infinite
            KVSpinnerView.show(saying: "Infinite Animation with extremely ultimate fantastic long text")
        case .onView:
            KVSpinnerView.show(on: self.view)
        case .onViewWithStatus:
			KVSpinnerView.show(on: self.view, saying: "Shown on view")
        case .delayedDismiss:
            KVSpinnerView.show()
            KVSpinnerView.dismiss(after: 2.0)
        case .imageProgress:
            downloadHugeImage()
        }
    }
    
}
