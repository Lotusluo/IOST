//
//  ViewController.swift
//  JAPictureCarousel
//
//  Created by Jason on 16/6/17.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let pcView = NSBundle.mainBundle().loadNibNamed("JAPictureCarouselView", owner: nil, options: nil).first as? JAPictureCarouselView
        pcView!.frame = CGRect(x: 0, y: 100.0, width: UIScreen.mainScreen().bounds.size.width, height: 200.0)
        pcView!.autoScroll = true
        view.addSubview(pcView!)
        
        
    }
}

