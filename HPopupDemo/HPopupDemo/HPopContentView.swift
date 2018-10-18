//
//  HPopContentView.swift
//  HPopup
//
//  Created by 俊松何 on 2018/10/18.
//  Copyright © 2018年 hjs. All rights reserved.
//

import UIKit

class HPopContentView: UIView {

    
    var pop : HPopup!
    
    @IBOutlet weak var tableView: UITableView!
    
    let dismisstypes : [String] = ["none","fadeOut","growOut","shrinkOut","sliderOutToTop","sliderOutToBottom","sliderOutToLeft","sliderOutToRight","bounceOut","bounceOutToTop","bounceOutToBottom","bounceOutToLeft","bounceOutToRight"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self
        tableView.delegate = self
        pop =  HPopup.popupWithContentView(self, showType: .bounceIn, dismissType: .shrinkOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
    }
  
    
    
    static func popContentView() -> HPopContentView
    {
        let array = Bundle.main.loadNibNamed("HPopContentView", owner: nil, options: nil)
        let view = array?.last as! HPopContentView
        view.frame.size = CGSize(width: UIScreen.main.bounds.width - 20, height: 300)
        view.layer.masksToBounds = true
        view.layer.cornerRadius  = 6;
        return view
    }
    
    func show(type : HPopup.HPopupShowType)
    {
        pop.showType = type
        pop.show()
    }
    
    

}

extension HPopContentView : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dismisstypes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var  cell = tableView.dequeueReusableCell(withIdentifier: "cellId")
        if(cell == nil)
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
            cell?.selectionStyle = .none
        }
        let type = dismisstypes[indexPath.row]
        cell?.textLabel?.text = type
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
     let type = dismisstypes[indexPath.row]
        if type == "none"
        {
            pop.dismissType = .none
        }else if type == "fadeOut"
        {
            pop.dismissType = .fadeOut
        }else if type == "growOut"
        {
            pop.dismissType = .growOut
        }else if type == "shrinkOut"
        {
            pop.dismissType = .shrinkOut
        }else if type == "sliderOutToTop"
        {
            pop.dismissType = .sliderOutToTop
        }else if type == "sliderOutToBottom"
        {
            pop.dismissType = .sliderOutToBottom
        }else if type == "sliderOutToLeft"
        {
            pop.dismissType = .sliderOutToLeft
        }else if type == "sliderOutToRight"
        {
            pop.dismissType = .sliderOutToRight
        }else if type == "bounceOut"
        {
            pop.dismissType = .bounceOut
        }else if type == "bounceOutToTop"
        {
            pop.dismissType = .bounceOutToTop
        }else if type == "bounceOutToBottom"
        {
            pop.dismissType = .bounceOutToBottom
        }else if type == "bounceOutToLeft"
        {
            pop.dismissType = .bounceOutToLeft
        }else if type == "bounceOutToRight"
        {
            pop.dismissType = .bounceOutToRight
        }
        pop.dismiss(animated: true)
    }
    
}

