//
//  ACMacros.swift
//  ACCommon_Swift
//
//  Created by i云 on 14-7-25.
//  Copyright (c) 2014年 Alone Coding. All rights reserved.
//

import Foundation

let YES = Bool(1)
let NO = Bool(0)

let kACAppleID    : NSString = "Apple ID"
let kACCompanyName: NSString = "Company Name"

/*
用于在浏览器中跳转到App Store应用中去的链接 并跳转到评分页面
*/
let kScoreURL: NSString = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" + kACAppleID

/*
用于在Apple Store上请求当前Apple ID 的相关信息的链接
*/
let kAppURL: NSString = "http://itunes.apple.com/lookup?id=" + kACAppleID

func fDataURLString(text: NSString!) -> NSString {
    if text != nil && text.isKindOfClass(NSClassFromString("NSString")) {
        return "http://app.zontenapp.com.cn/" + text
    }
    
    return "http://app.zontenapp.com.cn/"
}

func fImageURLString(text: NSString!) -> NSString {
    if text != nil && text.isKindOfClass(NSClassFromString("NSString")) {
        return "http://app.zontenapp.com.cn/" + text
    }
    return "http://app.zontenapp.com.cn/"
}

/**
@synchronized的代替方法 同步锁一

:param: lock 将要锁的对象
:param: closure 要执行的操作
*/
func synced(lock: AnyObject!, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}

//func synce(closure: () -> ()) {
//    let lockQueue = dispatch_queue_create("com.test.LockQueue", nil)
//    dispatch_sync(lockQueue, closure)
//}

let kScreenSize  : CGSize  = UIScreen.mainScreen().bounds.size
let kScreenWidth : CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds)
let kScreenHeight: CGFloat = CGRectGetHeight(UIScreen.mainScreen().bounds)
let kScreenBounds: CGRect  = UIScreen.mainScreen().bounds

let kTabBarHeight       : CGFloat = 49.0
let kToolBarHeight      : CGFloat = 44.0
let kStatusBarHeight    : CGFloat = 20.0
let kNavigationBarHeight: CGFloat = 44.0

let kAppContentHeight: CGFloat = kScreenHeight - kNavigationBarHeight - kStatusBarHeight - kTabBarHeight
let kAppContentNotNav: CGFloat = kScreenHeight - kNavigationBarHeight - kStatusBarHeight
let kAppContentNotTab: CGFloat = kScreenHeight - kTabBarHeight - kStatusBarHeight

/*
故事板
*/
let vMainStoryboard: UIStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)

let vApplication  : UIApplication  = UIApplication.sharedApplication()
let vFileManager  : NSFileManager  = NSFileManager.defaultManager()
let vUserDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
let vCurrentDevice: UIDevice       = UIDevice.currentDevice()

//处理字符串
func fDealwithString(str: NSString!) -> NSString {
    if str != nil && str.isKindOfClass(NSClassFromString("NSString")) {
        return str
    }
    return ""
}

//#pragma mark - degrees/radian functions
/*
旋转的单位采用弧度(radians),而不是角度（degress）。以下两个函数，你可以在弧度和角度之间切换。
*/
func fDegreesToRadians(degrees: CGFloat) -> CGFloat {
    return degrees * CGFloat(M_PI) / 180.0
}

func fRadiansToDegrees(radians: CGFloat) -> CGFloat {
    return radians * 180.0 / CGFloat(M_PI)
}

//#pragma mark - color functions

func fColorHexA(hex: UInt, alpha: CGFloat) -> UIColor! {
    var red  : CGFloat = CGFloat((hex & 0xFF0000) >> 16) / 255.0
    var green: CGFloat = CGFloat((hex & 0x00FF00) >> 8 ) / 255.0
    var blue : CGFloat = CGFloat((hex & 0x0000FF) >> 0 ) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}

func fColorRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor! {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

func fColorRGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor! {
    return fColorRGBA(r, g, b, 1.0)
}

func fColorHex(hex: UInt) -> UIColor! {
    return fColorHexA(hex, 1.0)
}

func fAppTmpAddTo(path: NSString) -> NSString {
    return NSTemporaryDirectory().stringByAppendingPathComponent(path)
}

func ACSTR(format : String, args: CVarArgType...) -> String {
    return NSString(format: format, arguments: getVaList(args))
}

func UUID() -> NSString{
    var uuid: CFUUIDRef = CFUUIDCreate(kCFAllocatorDefault)
    var uuidStr: CFStringRef = CFUUIDCreateString(kCFAllocatorDefault, uuid)
    var uuidText: NSString = uuidStr
    return uuidStr
}

let kAppCaches  : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
let kAppLibrary : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
let kAppDocument: NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString

let kiOSVersion          : Float = (vCurrentDevice.systemVersion as NSString).floatValue
let kCurrentPhone        : NSString = vCurrentDevice.model
let kCurrentLanguage     : NSString = NSLocale.preferredLanguages()[0] as NSString
let kStatusOrientation   : UIInterfaceOrientation = vApplication.statusBarOrientation
let kCurrentOrientation  : UIDeviceOrientation = vCurrentDevice.orientation
let kCurrentSystemVersion: NSString = vCurrentDevice.systemVersion

let sharedUserInterfaceIdiom = (vCurrentDevice.respondsToSelector("userInterfaceIdiom") ? vCurrentDevice.userInterfaceIdiom : UIUserInterfaceIdiom.Phone)

let isiPad   = (sharedUserInterfaceIdiom == UIUserInterfaceIdiom.Pad)
let iPhone5  = (UIScreen.instancesRespondToSelector("currentMode") ? CGSizeEqualToSize(CGSizeMake(640.0, 1136.0), UIScreen.mainScreen().currentMode!.size) : false)
let isRetina = (UIScreen.mainScreen().scale == 2)

func isEmptyObject(obj: AnyObject!) -> Bool {
    let flag = !(obj != nil && !(obj is NSNull))
    return flag
}

func isEmptyList(list: AnyObject!) -> Bool {
    let flag = !(list != nil && !(list is NSNull) && ((list is NSArray) || (list is NSDictionary)) && list.count > 0)
    return flag
}

