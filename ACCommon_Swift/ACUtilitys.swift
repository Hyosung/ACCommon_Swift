//
//  ACUtilitys.swift
//  ACCommon_Swift
//
//  Created by i云 on 14-7-28.
//  Copyright (c) 2014年 Alone Coding. All rights reserved.
//

import UIKit
import ImageIO
import CoreTelephony


/*
常用工具类
*/


let kPlaceholderName: NSString = "placeholder"
let kPlaceholderColor: UIColor = fColorRGB(288.0, 288.0, 288.0)

/*
用于生成浮点型的随机数
*/

let ARC4RANDOM_MAX = 0x100000000

class ACUtilitys: NSObject {
    
    class func sharedACUtilitys() -> ACUtilitys {
        
        struct once {
            static var onceToken: dispatch_once_t = 0
            static var utilitys: ACUtilitys? = nil
        }
        dispatch_once(&once.onceToken, {
                once.utilitys = ACUtilitys()
            })
        
        return once.utilitys!
    }
    
    class func setupNetworkNotification() {
        
    }
    
    /*
    是否有打开网络
    */
    class func isNotNetwork() -> Bool {
        
    }
    
    /*
    是否启动WiFi
    */
    class func isEnableWiFi() -> Bool {
        
    }
    
    /*
    是否启动3G
    */
    class func isEnable3G() -> Bool {
        
    }
    
    /**
    获取当前设备的名称如iPhone/iPod/iPad
    */
//    class func currentDeviceName() -> NSString! {
//        var systemInfo: utsname
//        uname(&systemInfo)
//        var deviceString: NSString? = NSString.stringWithCString(&systemInfo.machine.0, encoding: NSUTF8StringEncoding)
//        return deviceString
//    }
    
    /**
    当前根视图控制器
    */
    class func currentRootViewController() -> UIViewController {
        var result: UIViewController? = nil
        // Try to find the root view controller programmically
        
        // Find the top window (that is not an alert view or other window)
        var topWindow: UIWindow = vApplication.keyWindow
        
        if topWindow.windowLevel != UIWindowLevelNormal {
            
            var windows: NSArray = vApplication.windows
            
            for topWindow in windows {
                
                if topWindow.windowLevel == UIWindowLevelNormal {
                    break;
                }
            }
        }
        
        var rootView: UIView = topWindow.subviews[0] as UIView
        
        var nextResponder = rootView.nextResponder()
        
        if nextResponder.isKindOfClass(NSClassFromString("UIViewController")) {
            
            result = nextResponder as? UIViewController
        }
        else if topWindow.respondsToSelector("rootViewController") && topWindow.rootViewController != nil {
            
            result = topWindow.rootViewController
        }
        else {
            
            assert(false, "ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].")
        }
        
        return result!
    }
    
    /*
    无缓存取图
    */
    class func imageNamed(var name: NSString!, ofType ext: NSString! = "png") -> UIImage {
        var image1x: UIImage?
        var image2x: UIImage?
        
        image1x = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource(name, ofType: ext))
        
        if ext && !ext.isEqualToString("") {
            image2x = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource(NSString(format: "%@@2x", name), ofType: ext))
        } else {
            var range: NSRange = name.rangeOfString(".", options: NSStringCompareOptions.BackwardsSearch)
            if range.location != Foundation.NSNotFound {
                name = name.stringByReplacingCharactersInRange(range, withString: "@2x.")
            } else {
                name = NSString(format: "%@@2x",name)
            }
            image2x = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource(name, ofType: ext))
        }
        
        if (isRetina && image2x) {
            return image2x!
        }
        
        if !image1x {
            return image2x!
        }
        return image1x!
    }
    
//    class func imageNamed(name: NSString!) -> UIImage {
//        return ACUtilitys.imageNamed(name, ofType: "png")
//    }
    
    class func imagedExtJpg(name: NSString!) -> UIImage {
        return ACUtilitys.imageNamed(name, ofType: "jpg")
    }
    
    /*
    有缓存取图
    */
    class func imageCacheNamed(name: NSString!) -> UIImage {
        return UIImage(named: name)
    }
    
    /*
    截取当前View上的内容，并返回图片
    */
    /*+ (UIImage *)getImageFromView:(UIView *) orgView; */
    
    /*
    将多张图片合成一张
    @images 例:@[ @{ @"image": image1,@"rect": @"{{0,0},{120,120}}" },@{ @"image": image2,@"rect": @"{{120,0},{120,120}}" }]
    @size 合成图片的大小
    @return 合成的图片
    */
    class func imagesSynthesisWithImages(imagesInfo: NSArray!, andSize size: CGSize) -> UIImage {
        var newImage: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        for imageInfo in imagesInfo {
            var curImage: UIImage = (imageInfo as NSDictionary)["image"] as UIImage
            var curRect: CGRect = CGRectFromString((imageInfo["rect"] as NSString))
            if curImage != nil {
                curImage.drawInRect(curRect)
            }
        }
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /**
    gif图片解析
    */
  /*  class func gifParseWithGifData(gifData: NSData!) -> NSArray! {
        if !gifData {
            return nil
        }
        
        //加载gif
        var gif: CGImageSourceRef = CGImageSourceCreateWithData(gifData, nil)
        
        //获取gif的各种属性
        var gifprops = CGImageSourceCopyPropertiesAtIndex(gif, UInt(0), nil)
        
        //获取gif中静态图片的数量
        var count: size_t = CGImageSourceGetCount(gif)
        
        //将gif解析成UIImage类型对象，并加进images数组中
        var images: NSMutableArray = NSMutableArray(capacity: Int(count))
        
        for var index: size_t = 0; index < count; index++ {
            var ref: CGImageRef = CGImageSourceCreateImageAtIndex(gif, index, nil)
            var img: UIImage = UIImage(CGImage: ref)
            
            if img != nil {
                images.addObject(img)
            }
        }
        
        return images
    } */
    
    //用来辨别设备所使用网络的运营商
    class func checkCarrier() -> NSString {
        var ret: NSString = ""
        
        var info: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        var carrier: CTCarrier = info.subscriberCellularProvider
        
        if carrier == nil {
            
            return ret
        }
        
        var code: NSString = carrier.mobileNetworkCode
        
        if code.isEqualToString("") {
            
            return ret
        }
        
        if code.isEqualToString("00") || code.isEqualToString("02") || code.isEqualToString("07") {
            
            ret = "移动"
        }
        
        if code.isEqualToString("01") || code.isEqualToString("06") {
            ret = "联通"
        }
        
        if code.isEqualToString("03") || code.isEqualToString("05") {
            ret = "电信"
        }
        
        return ret
    }
    
    class func getTimeDiffString(timestamp: NSTimeInterval) -> NSString {
        
        var cal: NSCalendar = NSCalendar.currentCalendar()
        var todate: NSDate = NSDate(timeIntervalSince1970: timestamp)
        var today: NSDate = NSDate.date() //当前时间
        
        var unitFlags = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit
        var gap: NSDateComponents = cal.components(unitFlags, fromDate: today, toDate: todate, options: nil) //计算时间差
        
        if abs(gap.day) > 0 {
            return NSString(format: "%ld天前", abs(gap.day))
        }
        else if abs(gap.hour) > 0 {
            return NSString(format: "%ld小时前", abs(gap.hour))
        }
        else {
            return NSString(format: "%ld分钟前", abs(gap.minute))
        }
    }
    
    /*
    从传入图片上截取指定区域的图片
    */
    class func cutImageWithFrame(var frame: CGRect, image: UIImage!) -> UIImage {
        var height: CGFloat = ACUtilitys.reckonWithSize(image.size, width: CGRectGetWidth(frame))
        if image.size.width < CGRectGetWidth(frame) {
            frame.size.width = image.size.width
            if image.size.height < CGRectGetHeight(frame) {
                frame.size.height = image.size.height
            }
        } else {
            var newImage: UIImage = ACUtilitys.zoomImageWithSize(CGSizeMake(CGRectGetWidth(frame), height), image: image)
            if newImage.size.height < CGRectGetHeight(frame) {
                frame.size.height = newImage.size.height
            }
        }
        var cutImageRef: CGImageRef = CGImageCreateWithImageInRect(image.CGImage, frame)
        var cutImage: UIImage = UIImage(CGImage: cutImageRef)
        return cutImage
    }
    
    /*
    缩放传入图片到指定大小
    */
    class func zoomImageWithSize(size: CGSize, image: UIImage!) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, size.height)
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1)
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height), image.CGImage)
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /*
    重置图片的大小，图片不变形，只压缩
    @number 高度或者宽度
    @flag 传入的number值是高度或者宽度 YES:高度，NO:宽度
    */
    class func resizedImageWithImage(image: UIImage!, isHeight: Bool, number: CGFloat) -> UIImage {
        var size: CGSize
        if isHeight {
            size = CGSizeMake(ACUtilitys.reckonWithSize(image.size, height: number), number)
        }
        else{
            size = CGSizeMake(number, ACUtilitys.reckonWithSize(image.size, width: number))
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        image.drawInRect(CGRectMake(0.0, 0.0, size.width, size.height))
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
    重置图片的大小，图片不变形，只压缩,图片居中绘制
    @size 图片大小
    */
    class func resizedImageWithImage(image: UIImage!, size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen().scale)
        var newSize: CGSize = ACUtilitys.reckonWithSize(image.size, newSize: size)
        image.drawInRect(CGRectMake(size.width / 2.0 - newSize.width / 2.0, size.height / 2.0 - newSize.height / 2.0, newSize.width, newSize.height))
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /**
    重置图片的大小，图片不变形，只压缩
    @size 图片大小
    */
    class func resizedFixedImageWithImage(image: UIImage!, size: CGSize) -> UIImage {
        var newSize: CGSize = ACUtilitys.reckonWithSize(image.size, newSize: size)
        UIGraphicsBeginImageContextWithOptions(newSize, NO, UIScreen.mainScreen().scale);
        image.drawInRect(CGRectMake(0.0,
                                    0.0,
                                    newSize.width,
                                    newSize.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /*
    知道高度，重置图片大小
    */
    class func resizedImageWithImage(image: UIImage!, toHeight: CGFloat) -> UIImage {
        
    }
    
    /*
    知道宽度，重置图片大小
    */
    class func resizedImageWithImage(image: UIImage!, toWidth: CGFloat) -> UIImage {
    
    }
    
    /**
    传入原来的size与要转换的size，计算出新的size
    */
    class func reckonWithSize(oldSize: CGSize, newSize: CGSize) -> CGSize {
        var newWidth: CGFloat = min(oldSize.width, newSize.width)
        var newHeight: CGFloat = ACUtilitys.reckonWithSize(oldSize, width: newWidth)
        if newHeight > newSize.height {
            newWidth = ACUtilitys.reckonWithSize(oldSize, height: newHeight)
            newHeight = newSize.height
        }
        newHeight = min(newHeight, oldSize.height)
        return CGSizeMake(newWidth, newHeight)
    }
    
    class func reckonWithSize(size: CGSize, isHeight: Bool, number: CGFloat) -> CGFloat {
        var newNumber: CGFloat = 0.0
        var scale1: CGFloat = size.height / size.width
        var scale2: CGFloat = size.width / size.height
        if !isHeight {
            newNumber = scale1 * number
        }
        else {
            newNumber = scale2 * number
        }
        return newNumber
    }
    
    /*
    根据高度计算对应的宽度
    */
    class func reckonWithSize(size: CGSize, height: CGFloat) -> CGFloat {
        return ACUtilitys.reckonWithSize(size, isHeight: YES, number: height)
    }
    
    /*
    根据宽度计算对应的高度
    */
    class func reckonWithSize(size: CGSize, width: CGFloat) -> CGFloat {
        return ACUtilitys.reckonWithSize(size, isHeight: NO, number: width)
    }
    
    /*
    给纯色图片重绘颜色  注:只对纯色图片有效
    @maskColor 罩遮色
    @foregroundColor 前景色
    @nameOrExt 图片名称包括后缀
    */
    class func drawMask(maskColor: UIColor!, foregroundColor: UIColor!, imageNamedOrExt: NSString!) -> UIImage {
    
    }
    
    /*
    给纯色图片重绘颜色  注:只对纯色图片有效
    @maskColor 罩遮色
    @foregroundColor 前景色
    @image 图片对象
    */
    class func drawMask(maskColor: UIColor!, foregroundColor: UIColor!, image: UIImage!) -> UIImage {
    
    }
    
    /*
    根据传入的size绘制占位图 默认背景色 RGBCOLOR(228, 228, 228)
    */
    class func drawPlaceholderWithSize(size: CGSize) -> UIImage {
    
    }
    
    /*
    根据传入的size绘制占位图
    @color 背景色
    */
    class func drawPlaceholderWithSize(size: CGSize, bgcolor: UIColor!) -> UIImage {
    
    }
    
    /*
    根据传入的颜色绘制纯色图片 默认大小 {57，57}
    */
    class func drawingColor(color: UIColor!) -> UIImage {
    
    }
    
    /*
    绘制纯色图片
    @color 要绘制的颜色
    @size 图片大小
    */
    class func drawingColor(color: UIColor!, size: CGSize) -> UIImage {
    
    }
    
    /*
    绘制渐变图
    */
    class func drawGradientColor(p_clipRect: CGRect, options p_options: CGGradientDrawingOptions, colors p_colors: NSArray!) -> UIImage {
    
    }
    
    /**
    限制UITextView或者UITextField的输入字数
    @number 能输入的字数
    @obj UITextView对象或者UITextField对象
    @string 当前对象中的字符串
    @range 当前对象的范围大小
    */
    class func isOutNumber(number: NSInteger, objcect: AnyObject!, range: NSRange) -> Bool {
    
    }
    
    /*
    格式化文件大小
    @size 文件大小 字节（bytes）
    */
    class func formattedFileSize(size: UInt64) -> NSString {
    
    }
    
    /*
    自动检查版本是否可更新，并提示
    @url 在Apple Store 上请求的链接
    @block-releaseInfo 字典中包含了应用在Apple Store上的下载地址和更新的信息、最新版本号，对应的key是trackViewUrl、releaseNotes、version
    */
    class func automaticCheckVersion(((releaseInfo: NSDictionary!) -> Void)!, url: NSString!) {
    
    }
    
    /*
    检查是否有最新版本
    有最新版本就从消息中心发出消息 消息名称是 NotificationAppUpdate
    */
    class func onCheckVersion(url: NSString!) {
        
    }
    
    /*
    跳转到App Store应用的评分页面
    @url 默认 SCORE_URL
    */
    class func applicationRatings(url: NSString!) {
        
    }
    
    /*
    应用在 App Store的下载地址
    @appid 应用的Apple ID
    */
    class func appStoreUrl(appid: NSString!) -> NSString {
    
    }
    
    /*
    设置导航栏的背景 支持大部分iOS版本
    */
    class func setNavigationBar(navBar: UINavigationBar!, backgroundImage: UIImage!) {
    
    }
    
    /*
    给导航栏添加一个view覆盖在上面
    */
    class func setNavigationBar(navBar: UINavigationBar!, contentView: UIView!) {
    
    }
    
    /*
    当请求返回无数据时显示
    @flag 是否显示
    @view 显示提示的view
    @content 提示内容
    */
    class func showNoContent(flag: Bool, displayView: UIView!, displayContent: NSString!) {
    
    }
    
    /*
    半角转全角
    @dbc 半角字符串
    */
    class func DBCToSBC(dbc: NSString!) -> NSString {
    
    }
    
    /*
    全角转半角
    @sbc 全角字符串
    */
    class func SBCToDBC(sbc: NSString!) -> NSString {
    
    }
    
    /*
    生成from到to之间的随机数
    范围是[from,to) 包含from,不包含to
    */
    class func getRandomNumber(from: NSInteger, to: NSInteger) -> NSInteger {
    
    }
    
    /*
    生成0-to之间的随机数
    范围是[0,to) 包含0,不包含to
    */
    class func getRandomNumberTo(to: NSInteger) -> NSInteger {
        
    }
    
    /*
    生成浮点型的随机数
    范围[from,to) 包含from,不包含to
    默认随机数一位小数点
    */
    class func getFloatRandomNumber(from: Double, to: Double) -> Double {
    
    }
}
