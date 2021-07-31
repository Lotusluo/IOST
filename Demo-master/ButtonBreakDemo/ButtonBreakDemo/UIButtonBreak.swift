//
//  UIButtonBreak.swift
//  ButtonBreakDemo
//
//  Created by Jason on 16/6/22.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

import UIKit

class UIButtonBreak: UIButton {

    var time: NSTimeInterval?
    
    private let defaultTime: NSTimeInterval = 2.0
    private var isBreakEvents = false
    
    override func sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?) {
        
        time = time == 0 ? defaultTime : time
        
        if isBreakEvents {
            return;
        }else if(time == nil){
            super.sendAction(action, to: target, forEvent: event)
        }else if (time > 0) {
            isBreakEvents = true
            let delay = dispatch_time(DISPATCH_TIME_NOW,
                Int64(time! * Double(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                self.isBreakEvents = false
            }
            super.sendAction(action, to: target, forEvent: event)
        }
    }

}
