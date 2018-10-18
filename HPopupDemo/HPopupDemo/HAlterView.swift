//
//  HAlterView.swift
//  HPopupDemo
//
//  Created by 俊松何 on 2018/10/18.
//  Copyright © 2018年 tianxie. All rights reserved.
//

import UIKit

class HAlterView: UIView {

    var pop : HPopup?
    
    static func alterView() -> HAlterView
    {
        let array = Bundle.main.loadNibNamed("HAlterView", owner: nil, options: nil)
        let view = array?.last as! HAlterView
        view.frame.size = CGSize(width: UIScreen.main.bounds.width - 20, height: 230)
        view.layer.masksToBounds = true
        view.layer.cornerRadius  = 6;
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pop = HPopup.popupWithContentView(self, showType: .bounceIn, dismissType: .shrinkOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        
    }
    
    
    func show(inView : UIView)
    {
        self.pop?.showAtCenter(CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2), inView: inView)
    }
    
    

}
