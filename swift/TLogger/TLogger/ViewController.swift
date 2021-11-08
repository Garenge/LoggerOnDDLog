//
//  ViewController.swift
//  TLogger
//
//  Created by 鹏鹏 on 2021/11/8.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        Logger.logVerbose_app("app touch")
        Logger.logVerbose_sdk("sdk none")
        Logger.logVerbose("print all")
    }

}

