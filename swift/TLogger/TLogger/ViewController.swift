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

        Logger.log_app("app touch")
        Logger.log_sdk("sdk none")
        Logger.logVerbose("print all")
    }

}

