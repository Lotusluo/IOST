//
//  JAPictureCarouselView.swift
//  JAPictureCarousel
//
//  Created by Jason on 16/6/17.
//  Copyright © 2016年 littleBoy. All rights reserved.
//

import UIKit
import SDWebImage

private let MaxSection = 99
private let CollectionCellIdentifier = "JAPCCollectionCell"

class JAPictureCarouselView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    private var timer: NSTimer!
    
    private lazy var dataArr: [[String:String]] = {
        var arr: Array = [
            ["picurl":"http://s.cimg.163.com/i/img3.cache.netease.com/photo/0001/2016-06-17/BPPHPHR800AO0001.jpg.640x960.75.auto.jpg","title":"这是图一"],
            ["picurl":"http://s.cimg.163.com/i/img3.cache.netease.com/photo/0001/2016-06-17/BPPHPHCJ00AO0001.jpg.640x960.75.auto.jpg","title":"这是图二"],
            ["picurl":"http://s.cimg.163.com/i/img3.cache.netease.com/photo/0001/2016-06-17/BPPHPH2500AO0001.jpg.640x960.75.auto.jpg","title":"这是图三"],
            ["picurl":"http://s.cimg.163.com/i/img3.cache.netease.com/photo/0001/2016-06-17/BPPHPGQO00AO0001.jpg.640x960.75.auto.jpg","title":"这是图四"],
            ["picurl":"http://s.cimg.163.com/i/img3.cache.netease.com/photo/0001/2016-06-17/BPPHPGFB00AO0001.jpg.640x960.75.auto.jpg","title":"这是图五"]
        ]
        return arr
    }()
    
    //是否开启自动滚动
    var autoScroll = false {
        didSet {
            if autoScroll {addTimer()}
        }
    }
    
    override func awakeFromNib() {
    
        pageControl.numberOfPages = dataArr.count
        lblTitle.text = dataArr[pageControl.currentPage]["title"]
        collectionView.registerNib(UINib(nibName: CollectionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: CollectionCellIdentifier)
        
        //延迟0.5秒 滚动到中间的一组
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5*Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) { () -> Void in
            self.configureDefaultState()
        }
    }
    
    func configureDefaultState() {
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: MaxSection/2), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
    }
    
    //添加定时器
    private func addTimer() {
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "nextPage", userInfo: nil, repeats: true)
        self.timer = timer
        //把定时器添加到主线程中去，防止因为其他操作主线程不响应定时器
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    //移除定时器
    private func removeTimer() {
        timer.invalidate()
        timer = nil
    }
    
    func nextPage() {
        let currentIndexPathResert = resetIndexPath()
        var nextItem: Int = currentIndexPathResert.item + 1
        var nextSection: Int = currentIndexPathResert.section
        if nextItem == dataArr.count {
            nextItem = 0
            nextSection++
        }
        let nextIndexPath = NSIndexPath(forItem: nextItem, inSection: nextSection)
        collectionView.scrollToItemAtIndexPath(nextIndexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    
    //返回最中间那一组的 indexPath
    private func resetIndexPath() -> NSIndexPath {
         let currentIndexPath = collectionView.indexPathsForVisibleItems().last
         let currentIndexPathResert = NSIndexPath(forItem:currentIndexPath!.item, inSection: MaxSection/2)
        collectionView.scrollToItemAtIndexPath(currentIndexPathResert, atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
        return currentIndexPathResert
    }
}

//MARK: UICollectionViewDelegate,UICollectionViewDataSource
extension JAPictureCarouselView: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return MaxSection
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionCellIdentifier, forIndexPath: indexPath) as! JAPCCollectionCell
        cell.dict = dataArr[indexPath.item]
        return cell
    }
}

//MARK: UIScrollViewDelegate
extension JAPictureCarouselView: UIScrollViewDelegate{
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //这里加上0.5 是为了区分当滚动到中间页码不知道是上一张还是下一张的问题
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % dataArr.count
        lblTitle.text = dataArr[pageControl.currentPage]["title"]
    }
}

//MARK: UICollectionViewFlowLayout
class JAPCFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        itemSize = collectionView!.bounds.size
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        minimumInteritemSpacing = 0.0
        minimumLineSpacing = 0.0
        
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
    
    
}

//MARK: UICollectionViewCell
class JAPCCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        
    }
    
    var dict: [String:String] = [String:String]() {
        didSet{
            guard let url = NSURL(string: dict["picurl"]!) else {return}
            imageView.sd_setImageWithURL(url)
        }
    }
}








