//
//  HPopTableViewController.swift
//  HPopup
//
//  Created by 俊松何 on 2018/10/18.
//  Copyright © 2018年 hjs. All rights reserved.
//

import UIKit

class HPopTableViewController: UITableViewController {

    let popView : HPopContentView = HPopContentView.popContentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type =  HPopup.HPopupShowType(rawValue: indexPath.row)!
        popView.show(type: type)
    }
    

   
}
