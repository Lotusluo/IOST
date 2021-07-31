//
//  UIButton+Break.swift
//  ButtonBreakDemo
//
//  Created by Jason on 16/6/22.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

import UIKit

private let defaultTime = 0.0

extension UIButton {
    
    
    private struct AssociatedKeys {
        static var breakTime = "breakTime"
        static var isBreakEvent = "isBreakEvent"
    }
    
    var breakTime: NSTimeInterval {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.breakTime, newValue as NSTimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {

            if let breakTime = objc_getAssociatedObject(self, &AssociatedKeys.breakTime) as? NSTimeInterval {
                return breakTime
            }
            
            return defaultTime
        }
    }
    
    var isBreakEvent: Bool {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isBreakEvent, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            
            if let isBreakEvent = objc_getAssociatedObject(self, &AssociatedKeys.isBreakEvent) as? Bool {
                return isBreakEvent
            }
     
            return false
            
        }
    }

    func my_sendAction(action: Selector, to target: AnyObject?, forEvent event: UIEvent?){
        
        if self.isKindOfClass(UIButton) {
            breakTime = breakTime == 0 ? defaultTime : breakTime
            
            if isBreakEvent {
                return
            }else if breakTime > 0 {
                isBreakEvent = true
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(breakTime*Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    self.isBreakEvent = false
                })
                
                my_sendAction(action, to: target, forEvent: event)
            }else if breakTime == 0 {
                my_sendAction(action, to: target, forEvent: event)
            }
            
        }else {
            my_sendAction(action, to: target, forEvent: event)
        }
        
    }
    
    
    override public class func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }

        if self != UIButton.self {
            return
        }
        
        dispatch_once(&Static.token) {
            let originalSelector = Selector("sendAction:to:forEvent:")
            let swizzledSelector = Selector("my_sendAction:to:forEvent:")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
        
        
    }
    
    

    
    
    
}