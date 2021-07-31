//
//  ViewController.swift
//  CollectionViewSample
//
//  Created by 关东升 on 2016-11-18.
//  本书网站：http://www.51work6.com
//  智捷课堂在线课堂：http://www.zhijieketang.com/
//  智捷课堂微信公共号：zhijieketang
//  作者微博：@tony_关东升
//  作者微信：tony关东升
//  QQ：569418560 邮箱：eorient@sina.com
//  QQ交流群：162030268
//

import UIKit

class ViewController: UICollectionViewController {

    var events : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plistPath = Bundle.main.path(forResource: "events", ofType: "plist")
        //获取属性列表文件中的全部数据
        self.events = NSArray(contentsOfFile: plistPath!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.events.count / 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        let event = self.events[indexPath.section*2 + indexPath.row] as! NSDictionary
        
        cell.label.text = event["name"] as? String
        let imageFile = event["image"] as! String
        cell.imageView.image = UIImage(named: imageFile)
        
        return cell
    }
    
    //UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = self.events[indexPath.section*2 + indexPath.row] as! NSDictionary
        NSLog("select event name : %@", event["name"] as! String)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
            
        let headerView: UICollectionReusableView  = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier : "HeaderIdentifier", for:indexPath) 
        
        //TODO
        return headerView
    }
}

