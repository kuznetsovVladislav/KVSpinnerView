//
//  ViewController.swift
//  ExampleProject
//
//  Created by Владислав  on 31.01.17.
//  Copyright © 2017 Vladislav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func showAction(_ sender: Any) {
        KVSpinnerView.shared.show(saying: "Downlading Pokemon API")
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        KVSpinnerView.shared.dismiss()
    }
}

