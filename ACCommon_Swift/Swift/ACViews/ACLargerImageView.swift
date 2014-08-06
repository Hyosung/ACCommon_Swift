//
//  ACLargerImageView.swift
//  ACCommon_Swift
//
//  Created by i云 on 14-7-29.
//  Copyright (c) 2014年 Alone Coding. All rights reserved.
//

import UIKit

class ACLargerImageView: UIView, UIActionSheetDelegate,UIScrollViewDelegate {

    var currentSelectIndex: NSInteger = 0 {
        didSet {
            
            self.selectContentItem()
        }
    }
    private var URLStrings: NSArray!
    private var contentView: UIScrollView!
    
    private var longPressGesture: UILongPressGestureRecognizer!
    private var doubleGesture: UITapGestureRecognizer!
    private var tapGesture: UITapGestureRecognizer!
    
    init(frame: CGRect) {
        super.init(frame: frame)
        
        // Initialization code
    }
    
    private init(frame: CGRect, URLStrings: NSArray!) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.blackColor()
        self.URLStrings = URLStrings
        self.setupView()
        self.setupGesture()
        self.loadURLStrings()
    }
    
    class func largeImageViewWithImageURLStrings(URLStrings: NSArray!) -> ACLargerImageView {
        var alcImageView: ACLargerImageView = ACLargerImageView(frame: CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeight), URLStrings: URLStrings)
        return alcImageView
    }
    
    
    private func tapEvent(gesture: UITapGestureRecognizer!) {
        self.hide()
    }
    
    private func doubleEvent(gesture: UITapGestureRecognizer!) {
        var scrollView: UIScrollView = self.contentView.viewWithTag(50000 + self.currentSelectIndex) as UIScrollView
        
        if scrollView != nil {
            var imageView: UIImageView = scrollView.subviews[0] as UIImageView
            if imageView != nil {
                var point: CGPoint = gesture.locationInView(imageView)
                
                var rect: CGRect = CGRectMake((kScreenWidth - imageView.image.size.width) / 2.0,
                    (kScreenHeight - imageView.image.size.height) / 2.0,
                    imageView.image.size.width,
                    imageView.image.size.height)
                
                if CGRectContainsPoint(rect, point) {
                    var scale: CGFloat = scrollView.minimumZoomScale
                    if scrollView.zoomScale < scrollView.maximumZoomScale {
                        scale = scrollView.maximumZoomScale
                    }
                    
                    var zoomRect = self.zoomRectForScale(scale, withCenter: point, andZoomView: imageView)
                    scrollView.zoomToRect(zoomRect, animated: YES)
                }
            }
        }
    }
    
    private func longEvent(gesture: UITapGestureRecognizer!) {
        if gesture.state == UIGestureRecognizerState.Began {
            
            var actionView = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "保存到相册")
            actionView.showInView(self)
        }
    }
    
    private func zoomRectForScale(scale: CGFloat, withCenter center: CGPoint, andZoomView zoomView: UIView!) -> CGRect {
        var zoomRect: CGRect = CGRectZero
        zoomRect.size.height = zoomView.frame.size.height / scale
        zoomRect.size.width  = zoomView.frame.size.width  / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex <= 0 {
            var imageView: UIImageView = self.contentView.viewWithTag(50000 + self.currentSelectIndex).subviews[0] as UIImageView
            if imageView.image != nil {
                imageView.image.savePhotosAlbum()
            }
            else {
                var alertView = UIAlertView(title: nil, message: "图片正在加载中", delegate: nil, cancelButtonTitle: "确定")
                alertView.show()
            }
        }
    }
    
    private func setupGesture() {
        self.tapGesture = UITapGestureRecognizer(target: self, action: "tapEvent:")
        self.addGestureRecognizer(self.tapGesture)
        
        self.doubleGesture = UITapGestureRecognizer(target: self, action: "doubleEvent:")
        self.doubleGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(self.doubleGesture)
        
        self.longPressGesture = UILongPressGestureRecognizer(target: self, action: "longEvent:")
        self.addGestureRecognizer(self.longPressGesture)
        self.tapGesture.requireGestureRecognizerToFail(self.doubleGesture)
    }
        
    private func setupView() {
        self.contentView = UIScrollView(frame: self.bounds)
        self.contentView.delegate = self
        self.contentView.bouncesZoom = NO
        self.contentView.pagingEnabled = YES
        self.contentView.showsVerticalScrollIndicator = NO
        self.contentView.showsHorizontalScrollIndicator = NO
        self.addSubview(self.contentView)
    }
    
    private func loadURLStrings() {
        if self.URLStrings != nil && self.URLStrings.count > 0 {
            for var i = 0; i < self.URLStrings.count; i++ {
                var scrollView = UIScrollView(frame: CGRectMake(self.width * CGFloat(i), 0.0, self.width, self.height))
                scrollView.tag = 50000 + i
                scrollView.bounces = NO
                scrollView.delegate = self
                scrollView.minimumZoomScale = 1.0
                scrollView.maximumZoomScale = 3.0
                scrollView.multipleTouchEnabled = YES
                scrollView.showsVerticalScrollIndicator = NO
                scrollView.showsHorizontalScrollIndicator = NO
                
                var contentItemView = UIImageView(frame: scrollView.bounds)
                contentItemView.contentMode = UIViewContentMode.Center
                contentItemView.tag = 40000
                
                contentItemView.setImageWithURL(NSURL(string: self.URLStrings[i] as NSString), completed: {
                    (image: UIImage!, error: NSError!, cacheType: SDImageCacheType) in
                        if error == nil && image != nil {
                            var newImage = ACUtilitys.resizedFixedImageWithImage(image, size: contentItemView.frame.size)
                            contentItemView.image = newImage
                        }
                    })
                scrollView.addSubview(contentItemView)
                
                self.contentView.addSubview(scrollView)
            }
            
            self.contentView.contentSize = CGSizeMake(self.width * CGFloat(self.URLStrings.count), 0.0)
            self.selectContentItem()
        }
    }
    
    private func revertPreviousView() {
        var scrollView = self.contentView.viewWithTag(50000 + self.currentSelectIndex) as UIScrollView
        if scrollView != nil {
            scrollView.zoomScale = 1.0
        }
    }
    
    private func selectContentItem() {
        self.contentView.setContentOffset(CGPointMake(self.width * CGFloat(self.currentSelectIndex), 0.0), animated: YES)
    }
    
    
    func showWithView(view: UIView!) {
        self.alpha = 0.0
        view.addSubview(self)
        UIView.animateWithDuration(0.3, animations: {
                self.alpha = 1.0
            }, completion: {
                (finished: Bool) in
                vApplication.setStatusBarHidden(YES, withAnimation: UIStatusBarAnimation.Fade)
            })
    }
    
    func show() {
        self.showWithView(ACUtilitys.currentRootViewController().view.window)
    }
    
    func hide() {
        vApplication.setStatusBarHidden(NO, withAnimation: UIStatusBarAnimation.None)
        UIView.animateWithDuration(0.3, animations: {
            self.alpha = 0.0
            }, completion: {
                (finished: Bool) in
                self.removeFromSuperview()
                self.revertPreviousView()
            })
    }
    
    internal func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        if scrollView == self.contentView {
            var tempIndex: NSInteger = NSInteger(scrollView.contentOffset.x / self.width)
            
            if tempIndex != self.currentSelectIndex {
                self.revertPreviousView()
                currentSelectIndex = tempIndex
            }
        }
    }
    
    internal func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return scrollView.viewWithTag(40000)
    }
    
    internal func scrollViewDidZoom(scrollView: UIScrollView!) {
        var currentView = scrollView.viewWithTag(40000)
        var offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) / 2 : 0.0
        var offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) / 2 : 0.0
        
        currentView.center = CGPointMake(scrollView.contentSize.width / 2 + offsetX, scrollView.contentSize.height / 2 + offsetY)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
