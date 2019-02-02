//
//  SuperViewController.swift
//  smallcase
//
//  Created by Siddharth Paneri on 02/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit

fileprivate let TAG_OFFLINE_VIEW: Int = 999
fileprivate let HEIGHT_OFFLINE_VIEW: CGFloat = 90
fileprivate let PADDING_IMAGE_CROSS: CGFloat = 10
fileprivate let PADDING_MESSAGE_LABEL: CGFloat = 10

class SuperViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        CommsProvider.isUnreachable { _ in
            self.showOfflineView()
        }

        CommsProvider.isReachable { _ in
            self.hideOfflineView()
        }
        
        CommsProvider.sharedInstance.reachability.whenReachable = { _ in
            self.hideOfflineView()
        }
        
        CommsProvider.sharedInstance.reachability.whenUnreachable = { _ in
            self.showOfflineView()
        }
        
    }
    
    /** Can be used to show offline view on top of screen */
    
    func showOfflineView() {
        DispatchQueue.main.async {
            var view_OfflineContainer = UIApplication.shared.keyWindow?.viewWithTag(TAG_OFFLINE_VIEW)
            if view_OfflineContainer != nil {
                view_OfflineContainer?.removeFromSuperview()
                view_OfflineContainer = nil
            }
            view_OfflineContainer = UIView()
            view_OfflineContainer?.frame = CGRect(x: 0, y: -HEIGHT_OFFLINE_VIEW, width: self.view.frame.size.width, height: HEIGHT_OFFLINE_VIEW)
            view_OfflineContainer?.backgroundColor = UIColor.gray
            view_OfflineContainer?.alpha = 1.0
            view_OfflineContainer?.tag = TAG_OFFLINE_VIEW
            
            let messagelabel = UILabel(frame: CGRect(x: PADDING_MESSAGE_LABEL, y: 20, width: self.view.frame.size.width - PADDING_MESSAGE_LABEL, height: HEIGHT_OFFLINE_VIEW-20))
            messagelabel.backgroundColor = UIColor.clear
            messagelabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            messagelabel.textColor = UIColor.black
            messagelabel.textAlignment = NSTextAlignment.center
            messagelabel.numberOfLines = 0
            messagelabel.text = "You are offline. Connect to internet"
            view_OfflineContainer?.addSubview(messagelabel)

            let  buttonCross : UIButton = UIButton.init(type: UIButton.ButtonType.custom)
            buttonCross.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: HEIGHT_OFFLINE_VIEW)
            buttonCross.backgroundColor = UIColor.clear
            buttonCross.addTarget(self, action: #selector(SuperViewController.hideOfflineView), for: UIControl.Event.touchUpInside)
            view_OfflineContainer?.addSubview(buttonCross)

            UIApplication.shared.keyWindow?.addSubview(view_OfflineContainer!)
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                var basketTopFrame = view_OfflineContainer!.frame
                basketTopFrame.origin.y += view_OfflineContainer!.frame.size.height
                view_OfflineContainer!.frame = basketTopFrame
            }, completion: { finished in
            })
            
        }
    }
    
    /** Can be used to fide offline view from top of screen */
    @objc func hideOfflineView() {
        DispatchQueue.main.async {
            var view_OfflineContainer = UIApplication.shared.keyWindow?.viewWithTag(TAG_OFFLINE_VIEW)
            if view_OfflineContainer != nil {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                    var basketTopFrame = view_OfflineContainer!.frame
                    basketTopFrame.origin.y -= view_OfflineContainer!.frame.size.height
                    view_OfflineContainer!.frame = basketTopFrame
                }, completion: { finished in
                    if view_OfflineContainer != nil {
                        view_OfflineContainer?.removeFromSuperview()
                        view_OfflineContainer = nil
                    }
                })
            }
        }
        
    }

}
