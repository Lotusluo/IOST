//
//  ViewController.swift
//  ButtonBreakDemo
//
//  Created by Jason on 16/6/22.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let btn = UIButton(type: UIButtonType.Custom)
        btn.frame = CGRectMake(0, 100, 150, 30)
        btn.backgroundColor = UIColor.redColor()
        view.addSubview(btn)
        btn.breakTime = 2.0
        btn.addTarget(self, action: "btnClick1", forControlEvents: UIControlEvents.TouchUpInside)

    
        let btn2 = UIButtonBreak(type: UIButtonType.Custom)
        btn2.time = 2;
        btn2.frame = CGRectMake(0, 150, 150, 30)
        btn2.backgroundColor = UIColor.redColor()
        view.addSubview(btn2)
        btn2.addTarget(self, action: "btnClick2", forControlEvents: UIControlEvents.TouchUpInside)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func btnClick1() {
        print("\(NSDate())")
    }
    
    func btnClick2() {
        print("\(NSDate())")
    }

    

}

