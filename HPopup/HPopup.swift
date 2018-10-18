//
//  HPopup.swift
//  HPopupDemo
//
//  Created by 俊松何 on 2018/10/18.
//  Copyright © 2018年 tianxie. All rights reserved.
//

import UIKit

class HPopup: UIView {

    // HPopupShowType : 控制弹框显示样式
    enum HPopupShowType : Int {
        case none = 0
        case fadeIn = 1
        case growIn = 2
        case shrinkIn = 3
        case sliderInFromTop = 4
        case sliderInFromBottom = 5
        case sliderInFromLeft = 6
        case sliderInFromRight = 7
        case bounceIn = 8
        case bounceInFromTop = 9
        case bounceInFromBottom = 10
        case bounceInFromLeft = 11
        case bounceInFromRight = 12
    }
    
    //HPopupDismissType : 控制弹框消失样式
    enum HPopupDismissType : Int {
        case none = 0
        case fadeOut = 1
        case growOut = 2
        case shrinkOut = 3
        case sliderOutToTop = 4
        case sliderOutToBottom = 5
        case sliderOutToLeft = 6
        case sliderOutToRight = 7
        case bounceOut = 8
        case bounceOutToTop = 9
        case bounceOutToBottom = 10
        case bounceOutToLeft = 11
        case bounceOutToRight = 12
    }
    //HPopupMaskType : 控制弹框蒙板样式
    enum HPopupMaskType : Int {
        case none = 0
        case clear = 1
        case dimmed = 2
    }
    
    //HPopupHorizontalLayout : 控制弹框水平位置
    enum HPopupHorizontalLayout : Int {
        case custom = 0
        case left = 1
        case leftOfCenter = 2
        case center = 3
        case rightOfCenter = 4
        case right = 5
    }
    
     //HPopupHorizontalLayout : 控制弹框垂直位置
    enum HPopupVerticalLayout : Int {
        case custom = 0
        case top = 1
        case aboveCenter = 2
        case center = 3
        case belowCenter = 4
        case bottom = 5
    }
    
    
    //HPopupLayout : 弹框位置结构体
    enum HPopupLayout : Int {
        case cneter = 0
        case bottom = 1
    }
    
    //HPopupShowParameter  pop参数
    struct HPopupShowParameter
    {
        var center : CGPoint?
        var duration : Double = 0.0
        var view : UIView?
        var layout :  HPopupLayout = .cneter
    }
    
   var contentView: UIView!
    
   var showType : HPopupShowType = .none
    
   var dismissType : HPopupDismissType = .none
    
   var maskType : HPopupMaskType = .none
    
   var dimmedMaskAlpha : CGFloat = 0.5
   
   var shouldDismissOnBackgroundTouch : Bool = true
    
   var shouldDismissOnContentTouch : Bool = false
    
    
    // views
    private var backgroundView : UIView!
    private var containerView  : UIView!
    
    //state flags
    private var  isbeginShown : Bool = false
    private var  isShowing : Bool = false
    private var  isBeginDismissed : Bool = false
    

    class func popupWithContentView(_ contentView : UIView, showType : HPopupShowType = .none, dismissType : HPopupDismissType = .none, maskType : HPopupMaskType = .none, dismissOnBackgroundTouch : Bool = true, dismissOnContentTouch : Bool = false) -> HPopup
    {
        let popup = HPopup()
        popup.contentView = contentView
        popup.showType = showType
        popup.dismissType = dismissType
        popup.maskType = maskType
        popup.shouldDismissOnBackgroundTouch = dismissOnBackgroundTouch
        popup.shouldDismissOnContentTouch = dismissOnContentTouch
        return popup
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         self.autoresizesSubviews = true
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
        self.alpha = 0
        self.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        self.autoresizesSubviews = true
        
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.isUserInteractionEnabled = false
        backgroundView.autoresizingMask =  UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleHeight.rawValue | UIView.AutoresizingMask.flexibleWidth.rawValue)
        backgroundView.frame = self.bounds
        
        containerView = UIView()
        containerView.autoresizesSubviews = false
        containerView.isUserInteractionEnabled = true
        containerView.backgroundColor = UIColor.clear
        
        addSubview(backgroundView)
        addSubview(containerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitview = super.hitTest(point, with: event)
        if hitview == self
        {
            if shouldDismissOnBackgroundTouch
            {
                self.dismiss(animated: true)
            }
            
            if maskType == .none
            {
                return nil
            }else{
                return hitview
            }
        }else{
            if hitview?.isDescendant(of: containerView) ?? false
            {
                if shouldDismissOnContentTouch
                {
                    self.dismiss(animated: true)
                }
            }
            return hitview
        }
        
    }
    
    @objc func durationdismiss()
    {
        self.dismiss(animated: true)
    }
    
    func showAtCenter(_ center : CGPoint,inView : UIView)
    {
        var param = HPopupShowParameter()
        param.center = center
        show(parameter: param)
    }
    
    func show()
    {
        let param = HPopupShowParameter()
        show(parameter: param)
    }
    
    func show(duration : TimeInterval)
    {
        var param = HPopupShowParameter()
        param.duration = duration
        show(parameter: param)
    }
    
    func show(layout : HPopupLayout)
    {
        var param = HPopupShowParameter()
        param.layout = layout
        show(parameter: param)
    }
    

    private func show(parameter : HPopupShowParameter)
    {
        if(!isbeginShown && !isShowing && !isBeginDismissed)
        {
            isbeginShown = true
            isShowing = false
            isBeginDismissed = false
            let frontToBackWindows = UIApplication.shared.windows
            for window in frontToBackWindows
            {
                if window.windowLevel == .normal
                {
                    window.addSubview(self)
                    break
                }
            }
            self.isHidden = false
            self.alpha = 1.0
            
            backgroundView.alpha = 0.0
            
            if(maskType == .dimmed)
            {
                backgroundView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: self.dimmedMaskAlpha)
            }else{
                backgroundView.backgroundColor = UIColor.clear
            }
            
            let backgroundAnimationBlock : (()->(Void)) = {[weak self] in
                self?.backgroundView.alpha = 1.0;
            }
            
            if(showType != .none)
            {
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveLinear, animations: backgroundAnimationBlock, completion: nil)
            }else{
                backgroundAnimationBlock()
            }
            
            let completionBlock : ((Bool)->(Void)) = {[weak self]
                finish in
                self?.isbeginShown = false
                self?.isShowing = true
                self?.isbeginShown = false
                
                if(parameter.duration > 0.0)
                {
                    self?.perform(#selector(self?.durationdismiss), with: nil, afterDelay: parameter.duration)
                }
            }
            
            if self.contentView.superview != containerView
            {
                containerView.addSubview(self.contentView)
            }
            
            var containerFrame = containerView.frame
            containerFrame.size = self.contentView.frame.size
            containerView.frame = containerFrame
            
            var contentViewFrame = contentView.frame
            contentViewFrame.origin = CGPoint.zero
            self.contentView.frame = contentViewFrame
            
            self.contentView.layoutIfNeeded()
            
            var finalContainerFrame = containerFrame
            

            if let centerInView = parameter.center
            {
                var centerInSelf : CGPoint
                if let fromView = parameter.view
                {
                    centerInSelf = self.convert(centerInView, from: fromView)
                }else{
                    centerInSelf = centerInView
                }
                finalContainerFrame.origin.x = centerInSelf.x - finalContainerFrame.width / 2.0
                finalContainerFrame.origin.y = centerInSelf.y - finalContainerFrame.height / 2.0
                
            }else{
                
                if(parameter.layout == HPopupLayout.bottom)
                {
                    finalContainerFrame.origin.x = (self.bounds.width - containerFrame.width) / 2.0
                    finalContainerFrame.origin.y = (self.bounds.height - containerFrame.height)
                }else{
                    finalContainerFrame.origin.x = (self.bounds.width - containerFrame.width) / 2.0
                    finalContainerFrame.origin.y = (self.bounds.height - containerFrame.height) / 2.0
                }
            }
            
            switch showType{
            case .none: break
                
            case .fadeIn :
                containerView.alpha = 0.0
                containerView.transform = CGAffineTransform.identity
                let startFrame = finalContainerFrame
                containerView.frame = startFrame
                UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.containerView.alpha = 1.0
                }, completion: completionBlock)
                break
            case .growIn:
                containerView.alpha = 0.0
                let startFrame = finalContainerFrame
                containerView.frame = startFrame
                containerView.transform =  CGAffineTransform(scaleX: 0.85, y: 0.85)
                UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.containerView.alpha = 1.0
                    self.containerView.transform = CGAffineTransform.identity;
                    self.containerView.frame = finalContainerFrame
                }, completion: completionBlock)
                break
            case .shrinkIn:
                containerView.alpha = 0.0
                let startFrame = finalContainerFrame
                containerView.frame = startFrame
                containerView.transform =  CGAffineTransform(scaleX: 1.25, y: 1.25)
                UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.containerView.alpha = 1.0
                    self.containerView.transform = CGAffineTransform.identity;
                    self.containerView.frame = finalContainerFrame
                }, completion: completionBlock)
                break
            case .sliderInFromTop:
                containerView.alpha = 1.0
                containerView.transform = CGAffineTransform.identity
                var startFrame = finalContainerFrame
                startFrame.origin.y = -finalContainerFrame.height
                containerView.frame = startFrame
                UIView.animate(withDuration: 0.30, delay: 0, options: UIView.AnimationOptions(rawValue: (7 << 16)), animations: {
                    self.containerView.frame = finalContainerFrame
                }, completion: completionBlock)
                break
                
            case .sliderInFromBottom:
                containerView.alpha = 1.0
                containerView.transform = CGAffineTransform.identity
                var startFrame = finalContainerFrame
                startFrame.origin.y = self.bounds.height
                containerView.frame = startFrame
                UIView.animate(withDuration: 0.30, delay: 0, options: UIView.AnimationOptions(rawValue: (7 << 16)), animations: {
                    self.containerView.frame = finalContainerFrame
                }, completion: completionBlock)
                break
            
            case .sliderInFromLeft:
                containerView.alpha = 1.0
                containerView.transform = CGAffineTransform.identity
                var startFrame = finalContainerFrame
                startFrame.origin.y =  -finalContainerFrame.width
                containerView.frame = startFrame
                UIView.animate(withDuration: 0.30, delay: 0, options: UIView.AnimationOptions(rawValue: (7 << 16)), animations: {
                    self.containerView.frame = finalContainerFrame
                }, completion: completionBlock)
                break
                
            case .sliderInFromRight:
                containerView.alpha = 1.0
                containerView.transform = CGAffineTransform.identity
                var startFrame = finalContainerFrame
                startFrame.origin.y =  self.frame.width
                containerView.frame = startFrame
                UIView.animate(withDuration: 0.30, delay: 0, options: UIView.AnimationOptions(rawValue: (7 << 16)), animations: {
                    self.containerView.frame = finalContainerFrame
                }, completion: completionBlock)
                break
            case .bounceIn:
                 containerView.alpha = 0.0
                 let startFrame = finalContainerFrame
                 containerView.frame = startFrame;
                 containerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1);
                 UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 15.0, options: UIView.AnimationOptions(rawValue: 0), animations: {
                    self.containerView.alpha = 1.0
                    self.containerView.transform = CGAffineTransform.identity
                 }, completion: completionBlock)
                break
            case .bounceInFromTop:
                containerView.alpha = 1.0
                containerView.transform =  CGAffineTransform.identity
                var startFrame = finalContainerFrame
                startFrame.origin.y = -finalContainerFrame.height
                containerView.frame = startFrame;
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: UIView.AnimationOptions(rawValue: 0), animations: {
                    self.containerView.frame = finalContainerFrame
                }, completion: completionBlock)
                break
                
            case .bounceInFromBottom:
                containerView.alpha = 1.0
                containerView.transform =  CGAffineTransform.identity
                var startFrame = finalContainerFrame
                startFrame.origin.y = self.bounds.height
                containerView.frame = startFrame;
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: UIView.AnimationOptions(rawValue: 0), animations: {
                    self.containerView.frame = finalContainerFrame
                }, completion: completionBlock)
                break
                
            case .bounceInFromLeft:
                containerView.alpha = 1.0
                containerView.transform =  CGAffineTransform.identity
                var startFrame = finalContainerFrame
                startFrame.origin.x = -finalContainerFrame.width
                containerView.frame = startFrame;
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: UIView.AnimationOptions(rawValue: 0), animations: {
                    self.containerView.frame = finalContainerFrame
                }, completion: completionBlock)
                break
                
            case .bounceInFromRight:
                containerView.alpha = 1.0
                containerView.transform =  CGAffineTransform.identity
                var startFrame = finalContainerFrame
                startFrame.origin.x = self.frame.width
                containerView.frame = startFrame;
                UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10.0, options: UIView.AnimationOptions(rawValue: 0), animations: {
                    self.containerView.frame = finalContainerFrame
                }, completion: completionBlock)
                break
                
            }
        }
    }
    
    func dismiss(animated : Bool)  {
        
        if(isShowing && !isBeginDismissed)
        {
            isbeginShown = false
            isShowing = false
            isBeginDismissed = true
            
            //取消定时弹框
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(durationdismiss), object: nil)
            
            let backgroundAnimationBlock : (()->(Void)) = {
                self.backgroundView.alpha = 0.0
            }
            
            if(animated && (showType != .none))
            {
                UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: backgroundAnimationBlock, completion: nil)
            }else{
                backgroundAnimationBlock()
            }
            
            let completionBlock : ((Bool)->(Void)) = { finish in
                self.removeFromSuperview()
                self.isbeginShown = false
                self.isShowing = false
                self.isBeginDismissed = false
                self.containerView.transform = CGAffineTransform.identity
            }
            
            let bounce1Duration : TimeInterval = 0.13
            let bounce2Duration : TimeInterval = bounce1Duration * 2.0
            
            if(animated)
            {
                switch dismissType{
                case .fadeOut:
                    UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                        self.containerView.alpha = 0.0
                    }, completion: completionBlock)
                    break
                case .growOut:
                    UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                        self.containerView.alpha = 0.0
                        self.containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1);
                    }, completion: completionBlock)
                    break
                case .shrinkOut:
                    UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
                        self.containerView.alpha = 0.0
                        self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
                    }, completion: completionBlock)
                    break
                case .sliderOutToTop:
                    UIView.animate(withDuration: 0.3, delay: 0, options:UIView.AnimationOptions(rawValue: (7 << 16)), animations: {
                        var finalFrame = self.containerView.frame
                        finalFrame.origin.y = -finalFrame.height
                        self.containerView.frame = finalFrame
                    }, completion: completionBlock)
                    break
                case .sliderOutToBottom:
                    UIView.animate(withDuration: 0.3, delay: 0, options:UIView.AnimationOptions(rawValue: (7 << 16)), animations: {
                        var finalFrame = self.containerView.frame
                        finalFrame.origin.y = self.frame.height
                        self.containerView.frame = finalFrame
                    }, completion: completionBlock)
                    break
                case .sliderOutToLeft:
                    UIView.animate(withDuration: 0.3, delay: 0, options:UIView.AnimationOptions(rawValue: (7 << 16)), animations: {
                        var finalFrame = self.containerView.frame
                        finalFrame.origin.x = -finalFrame.width
                        self.containerView.frame = finalFrame
                    }, completion: completionBlock)
                    break
                case .sliderOutToRight:
                    UIView.animate(withDuration: 0.3, delay: 0, options:UIView.AnimationOptions(rawValue: (7 << 16)), animations: {
                        var finalFrame = self.containerView.frame
                        finalFrame.origin.x = self.frame.width
                        self.containerView.frame = finalFrame
                    }, completion: completionBlock)
                    break
                case .bounceOut:
                    UIView.animate(withDuration: bounce1Duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                        self.containerView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1);
                    }) { (finsih) in
                        UIView.animate(withDuration: bounce2Duration, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                            self.containerView.alpha = 0.0
                            self.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                        }, completion: completionBlock)
                    }
                    break

                case .bounceOutToTop:
                    UIView.animate(withDuration: bounce1Duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                        var finalFrame = self.containerView.frame
                        finalFrame.origin.y = finalFrame.origin.y + 40.0
                        self.containerView.frame = finalFrame
                    }) { (finsih) in
                        UIView.animate(withDuration: bounce2Duration, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                            var finalFrame = self.containerView.frame
                            finalFrame.origin.y = -finalFrame.height
                            self.containerView.frame = finalFrame
                        }, completion: completionBlock)
                    }
                    break
                case .bounceOutToBottom:
                    UIView.animate(withDuration: bounce1Duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                        var finalFrame = self.containerView.frame
                        finalFrame.origin.y = finalFrame.origin.y - 40.0
                        self.containerView.frame = finalFrame
                    }) { (finsih) in
                        UIView.animate(withDuration: bounce2Duration, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                            var finalFrame = self.containerView.frame
                            finalFrame.origin.y = self.frame.height
                            self.containerView.frame = finalFrame
                        }, completion: completionBlock)
                    }
                    break
                case .bounceOutToLeft:
                    UIView.animate(withDuration: bounce1Duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                        var finalFrame = self.containerView.frame
                        finalFrame.origin.x = finalFrame.origin.x + 40.0
                        self.containerView.frame = finalFrame
                    }) { (finsih) in
                        UIView.animate(withDuration: bounce2Duration, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                            var finalFrame = self.containerView.frame
                            finalFrame.origin.x =  -finalFrame.width
                            self.containerView.frame = finalFrame
                        }, completion: completionBlock)
                    }
                    break
                case .bounceOutToRight:
                    UIView.animate(withDuration: bounce1Duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                        var finalFrame = self.containerView.frame
                        finalFrame.origin.x = finalFrame.origin.x - 40.0
                        self.containerView.frame = finalFrame
                    }) { (finsih) in
                        UIView.animate(withDuration: bounce2Duration, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                            var finalFrame = self.containerView.frame
                            finalFrame.origin.x =  self.frame.width
                            self.containerView.frame = finalFrame
                        }, completion: completionBlock)
                    }
                    break
                default:
                    self.containerView.alpha = 0.0
                    completionBlock(true)
                    break
                }

            }else{
                self.containerView.alpha = 0.0
                completionBlock(true)
            }
            
        }
    }
    
    
   private func isIPhoneXType() -> Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        return UIApplication.shared.windows[0].safeAreaInsets != UIEdgeInsets.zero
    }

    private func bottomSafeDistance() -> CGFloat
    {
        if(isIPhoneXType())
        {
            return 34.0
        }else{
           return 0.0
        }
    }
    
    
    

}
