//
//  ViewController.swift
//  HPopupDemo
//
//  Created by 俊松何 on 2018/10/18.
//  Copyright © 2018年 hjs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let alterView : HAlterView = HAlterView.alterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func showClick(_ sender: UIButton) {
        alterView.show(inView: self.view)
        
    }
}

