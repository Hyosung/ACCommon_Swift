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

var hostReach: Reachability?
var isSetupNetwork: Bool? = NO

class ACUtilitys: NSObject {
    
    deinit {
        if isSetupNetwork {
            NSNotificationCenter.defaultCenter().removeObserver(self, name: kReachabilityChangedNotification, object: nil)
            hostReach!.stopNotifier()
            hostReach = nil
        }
    }
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
        isSetupNetwork = YES
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: kReachabilityChangedNotification, object: nil)
        hostReach = Reachability(hostname: "http://www.baidu.com")
        hostReach!.startNotifier()
    }
    
    /*
    是否有打开网络
    */
    class func isNotNetwork() -> Bool {
        
        return (!ACUtilitys.isEnable3G() && !ACUtilitys.isEnableWiFi())
    }
    
    /*
    是否启动WiFi
    */
    class func isEnableWiFi() -> Bool {
         return (Reachability.reachabilityForLocalWiFi().currentReachabilityStatus() != NetworkStatus.NotReachable)
    }
    
    /*
    是否启动3G
    */
    class func isEnable3G() -> Bool {
        
        return (Reachability.reachabilityForInternetConnection().currentReachabilityStatus() != NetworkStatus.NotReachable)
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
   class func gifParseWithGifData(gifData: NSData!) -> NSArray! {
        if !gifData {
            return nil
        }
    
        //加载gif
        var gif: CGImageSourceRef = CGImageSourceCreateWithData((gifData as CFDataRef), nil).takeRetainedValue()
        
        //获取gif的各种属性
        var gifprops = CGImageSourceCopyPropertiesAtIndex(gif, UInt(0), nil).takeRetainedValue()
        CFShow(gifprops)
    
        //获取gif中静态图片的数量
        var count: size_t = CGImageSourceGetCount(gif)
        
        //将gif解析成UIImage类型对象，并加进images数组中
        var images: NSMutableArray = NSMutableArray(capacity: Int(count))
        
        for var index: size_t = 0; index < count; index++ {
            var ref: CGImageRef = CGImageSourceCreateImageAtIndex(gif, index, nil).takeRetainedValue()
            var img: UIImage = UIImage(CGImage: ref)
            
            if img != nil {
                images.addObject(img)
            }
        }
        
        return images
    }
    
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
    不向外部公开，私有化
    */
    private class func resizedImageWithImage(image: UIImage!, isHeight: Bool, number: CGFloat) -> UIImage {
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
        return ACUtilitys.resizedImageWithImage(image, isHeight: YES, number: toHeight)
    }
    
    /*
    知道宽度，重置图片大小
    */
    class func resizedImageWithImage(image: UIImage!, toWidth: CGFloat) -> UIImage {
        return ACUtilitys.resizedImageWithImage(image, isHeight: NO, number: toWidth)
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
    
    //私有
    private class func reckonWithSize(size: CGSize, isHeight: Bool, number: CGFloat) -> CGFloat {
        var scale: CGFloat = isHeight ? (size.width / size.height) : (size.height / size.width)
        return scale * number
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
    
        return ACUtilitys.drawMask(maskColor, foregroundColor: foregroundColor, image: ACUtilitys.imageCacheNamed(imageNamedOrExt))
    }
    
    /*
    给纯色图片重绘颜色  注:只对纯色图片有效
    @maskColor 罩遮色
    @foregroundColor 前景色
    @image 图片对象
    */
    class func drawMask(maskColor: UIColor!, foregroundColor: UIColor!, image: UIImage!) -> UIImage {
        var imageRect = CGRectMake(0.0, 0.0, CGFloat(CGImageGetWidth(image.CGImage)), CGFloat(CGImageGetHeight(image.CGImage)))
        
        // 创建位图上下文
        var context = CGBitmapContextCreate(nil, // 内存图片数据
            CGImageGetWidth(image.CGImage),  // 宽
            CGImageGetHeight(image.CGImage), // 高
            8, // 色深
            0, // 每行字节数
            CGImageGetColorSpace(image.CGImage), // 颜色空间
            CGImageGetBitmapInfo(image.CGImage)/*kCGImageAlphaPremultipliedLast*/) // alpha通道，RBGA
        
        // 设置当前上下文填充色为白色（RGBA值）
        CGContextSetRGBFillColor(
            context,
            CGColorGetComponents(foregroundColor.CGColor)[0],
            CGColorGetComponents(foregroundColor.CGColor)[1],
            CGColorGetComponents(foregroundColor.CGColor)[2],
            CGColorGetAlpha(foregroundColor.CGColor))
        
        CGContextFillRect(context,imageRect)
        
        // 用 originImage 作为 clipping mask（选区）
        
        CGContextClipToMask(context,imageRect, image.CGImage)
        
        // 设置当前填充色为黑色
        CGContextSetRGBFillColor(
            context,
            CGColorGetComponents(maskColor.CGColor)[0],
            CGColorGetComponents(maskColor.CGColor)[1],
            CGColorGetComponents(maskColor.CGColor)[2],
            CGColorGetAlpha(maskColor.CGColor))
        
        // 在clipping mask上填充黑色
        
        CGContextFillRect(context,imageRect)
        
        var newCGImage = CGBitmapContextCreateImage(context)
        var newImage = UIImage(CGImage: newCGImage, scale: image.scale, orientation: image.imageOrientation)
        
        // Cleanup
        
//        CGContextRelease(context);
//        
//        CGImageRelease(newCGImage);
        
        //    [UIImagePNGRepresentation(newImage) writeToFile:[XW_Document stringByAppendingPathComponent:[NSString stringWithFormat:@"__%@",nameOrExt]] atomically:YES];
        
        return newImage
    }
    
    /*
    根据传入的size绘制占位图 默认背景色 RGBCOLOR(228, 228, 228)
    */
    class func drawPlaceholderWithSize(size: CGSize) -> UIImage {
        return ACUtilitys.drawPlaceholderWithSize(size, bgcolor: kPlaceholderColor)
    }
    
    /*
    根据传入的size绘制占位图
    @color 背景色
    */
    class func drawPlaceholderWithSize(size: CGSize, bgcolor: UIColor!) -> UIImage {
        var oldImage = ACUtilitys.imageCacheNamed(kPlaceholderName)
        
        UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen().scale)
        
        var contextRef = UIGraphicsGetCurrentContext()
        bgcolor.setFill()
        CGContextFillRect(contextRef, CGRectMake(0, 0, size.width, size.height))
        var height = min(size.height, oldImage.size.height)
        var newSize = CGSizeMake(height - 20.0, height - 20.0)
        
        if newSize.width >= size.width {
            newSize = CGSizeMake(size.width - 20, size.width - 20)
        }
        
        CGContextTranslateCTM(contextRef, 0, size.height)
        CGContextScaleCTM(contextRef, 1, -1)
        CGContextDrawImage(contextRef, CGRectMake(size.width / 2.0 - newSize.width / 2.0,
            size.height / 2.0 - newSize.height / 2.0,
            newSize.width,
            newSize.height), oldImage.CGImage)
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /*
    根据传入的颜色绘制纯色图片 默认大小 {57，57}
    */
    class func drawingColor(color: UIColor!) -> UIImage {
        return ACUtilitys.drawingColor(color, size: CGSizeMake(57.0, 57.0))
    }
    
    /*
    绘制纯色图片
    @color 要绘制的颜色
    @size 图片大小
    */
    class func drawingColor(color: UIColor!, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen().scale)
        color.setFill()
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height))
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /*
    绘制渐变图
    */
    
    /**
    * 绘制背景色渐变的矩形，p_colors渐变颜色设置，集合中存储UIColor对象（创建Color时一定用三原色来创建）
    **/
    class func drawGradientColor(p_clipRect: CGRect, options p_options: CGGradientDrawingOptions, colors p_colors: NSArray!) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(p_clipRect.size, NO, UIScreen.mainScreen().scale)
        var p_context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(p_context)// 保持住现在的context
        CGContextClipToRect(p_context, p_clipRect)// 截取对应的context
        var colorCount = p_colors.count
        var numOfComponents = 4
        var rgb = CGColorSpaceCreateDeviceRGB()
        var colorComponents: [CGFloat] = []
        
        for var i = 0; i < colorCount; i++ {
            var color: UIColor = p_colors[i] as UIColor
            var temcolorRef = color.CGColor
            var components: ConstUnsafePointer<CGFloat> = CGColorGetComponents(temcolorRef)
            for var j = 0; j < numOfComponents; ++j {
                colorComponents[i * numOfComponents + j] = components[j]
            }
        }
        var gradient = CGGradientCreateWithColorComponents(rgb, colorComponents, nil, UInt(colorCount))
        var startPoint = p_clipRect.origin
        var endPoint = CGPointMake(CGRectGetMinX(p_clipRect), CGRectGetMaxY(p_clipRect))
        CGContextDrawLinearGradient(p_context, gradient, startPoint, endPoint, p_options)
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        CGContextRestoreGState(p_context)// 恢复到之前的context
        UIGraphicsEndImageContext()
        
        //    [UIImagePNGRepresentation(newImage) writeToFile:[XW_Document stringByAppendingPathComponent:@"xw.png"] atomically:YES];
        return newImage
    }
    
    /**
    限制UITextView或者UITextField的输入字数
    @number 能输入的字数
    @obj UITextView对象或者UITextField对象
    @string 当前对象中的字符串
    @range 当前对象的范围大小
    */
    class func isOutNumber(number: NSInteger, objcect: AnyObject!, string: NSString!, range: NSRange) -> Bool {
        //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
        
        if string.isEqualToString("\n") { //按会车可以改变
            return YES
        }
        var textField: UITextField!
        if objcect is UITextField || objcect is UITextView {
                textField = objcect as UITextField
        }
        else {
            assert(textField != nil, "对象必须是UITextField或者UITextView")
        }
    
        var toBeString: NSString = textField.text.bridgeToObjectiveC()
        toBeString = toBeString.stringByReplacingCharactersInRange(range, withString: string)//得到输入框的内容
        
        if toBeString.length > number { //如果输入框内容大于number则弹出警告
            textField.text = toBeString.substringToIndex(number)
            return NO
        }
        return YES
    }
    
    /*
    格式化文件大小
    @size 文件大小 字节（bytes）
    */
    class func formattedFileSize(size: UInt64) -> NSString {
        var formattedStr: NSString = ""
        if size <= 0 {
            formattedStr = NSLocalizedString("Empty", tableName:nil , bundle:NSBundle.mainBundle() , value:"" , comment: "")
        }
        else {
            if size > 0 && size < 1024 {
                formattedStr = NSString(format: "%qu bytes", size)
            }
            else {
                
                if size >= 1024 && size < UInt64(pow(1024.0, 2.0)) {
                    formattedStr = NSString(format: "%.1f KB", (Float(size) / 1024.0))
                }
                else {
                    if size >= UInt64(pow(1024.0, 2.0)) && size < UInt64(pow(1024.0, 3.0)) {
                        formattedStr = NSString(format: "%.2f MB", (Float(size) / pow(1024.0, 2.0)))
                    }
                    else {
                        if size >= UInt64(pow(1024.0, 3.0)) {
                            formattedStr = NSString(format: "%.3f GB", (Float(size) / pow(1024.0, 3.0)))
                        }
                    }
                }
            }
        }
        return formattedStr
    }
    
    /*
    自动检查版本是否可更新，并提示
    @url 在Apple Store 上请求的链接
    @block-releaseInfo 字典中包含了应用在Apple Store上的下载地址和更新的信息、最新版本号，对应的key是trackViewUrl、releaseNotes、version
    */
    class func automaticCheckVersion(block: ((releaseInfo: NSDictionary!) -> Void)!, url: NSString!) {
        var infoDic = NSBundle.mainBundle().infoDictionary
        
        var currentVersion: NSString = infoDic["CFBundleShortVersionString"] as NSString
        var urlString: NSString = url
        var request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL.URLWithString(urlString)
        request.HTTPMethod = "POST"
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response: NSURLResponse!, data: NSData!, error: NSError!) in
            
            var dic: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
            var infoArray: NSArray = dic["results"] as NSArray
            if infoArray.count > 0 {
                var releaseInfo: NSDictionary = infoArray[0] as NSDictionary
                var lastVersion: NSString = releaseInfo["version"] as NSString
                
                if lastVersion.compare(currentVersion) == NSComparisonResult.OrderedAscending {
                    var trackViewURLString: NSString = releaseInfo["trackViewUrl"] as NSString
                    var releaseNotes: NSString = releaseInfo["releaseNotes"] as NSString
                    
                    if block {
                        block(releaseInfo: ["trackViewUrl": trackViewURLString,
                                            "version": lastVersion,
                                            "releaseNotes": releaseNotes])
                    }
                }
            }
            })
    }
    
    /*
    检查是否有最新版本
    有最新版本就从消息中心发出消息 消息名称是 NotificationAppUpdate
    */
    class func onCheckVersion(url: NSString!) {
        var infoDic = NSBundle.mainBundle().infoDictionary
        
        var currentVersion: NSString = infoDic["CFBundleShortVersionString"] as NSString
        var urlString: NSString = url
        var request: NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL.URLWithString(urlString)
        request.HTTPMethod = "POST"
        var urlResponse: NSURLResponse? = nil
        var error: NSError? = nil
        var recervedData: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &urlResponse, error: &error)
        
        dispatch_async(dispatch_get_main_queue(), {
            
            if recervedData != nil {
                var dic: NSDictionary = NSJSONSerialization.JSONObjectWithData(recervedData, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
                var infoArray: NSArray = dic["results"] as NSArray
                if infoArray.count > 0 {
                    var releaseInfo: NSDictionary = infoArray[0] as NSDictionary
                    var lastVersion: NSString = releaseInfo["version"] as NSString
                    
                    if lastVersion.compare(currentVersion) == NSComparisonResult.OrderedAscending {
                        var trackViewURL: NSString = releaseInfo["trackViewUrl"] as NSString
                        var releaseNotes: NSString = releaseInfo["releaseNotes"] as NSString
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("NotificationAppUpdate", object: self, userInfo: ["trackViewUrl": trackViewURL,
                                       "version": lastVersion,
                                       "releaseNotes": releaseNotes])
                    }
                    else {
                        var alert: UIAlertView = UIAlertView(title: "软件更新", message: "当前版本已是最新版本", delegate: nil, cancelButtonTitle: "确定")
                        alert.show()
                    }
                }
                else {
                    
                    var alert: UIAlertView = UIAlertView(title: "软件更新", message: "当前软件还未上线", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                }
            }
            else {
                var alert: UIAlertView = UIAlertView(title: "软件更新", message: "网络连接失败", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
            })
    }
    
    /*
    跳转到App Store应用的评分页面
    @url 默认 SCORE_URL kScoreURL
    */
    class func applicationRatings(url: NSString! = kScoreURL) {
        vApplication.openURL(NSURL(string: url))
    }
    
    /*
    应用在 App Store的下载地址
    @appid 应用的Apple ID
    */
    class func appStoreUrl(appid: NSString! = kACAppleID) -> NSString {
        var info: NSDictionary = NSBundle.mainBundle().infoDictionary
        var displayName: NSString = info["CFBundleDisplayName"] as NSString
//        var displayName: NSString = info["CFBundleName"] as NSString
        //https://itunes.apple.com/us/app/bu-yi-li-ji/id647152789?mt=8&uo=4
        var spliceArray: NSMutableArray = NSMutableArray(capacity: 0)
        for var i = 0; i < displayName.length; i++ {
            var spliceText: NSString = NSString(format: "%C", displayName.characterAtIndex(i))
            spliceArray.addObject(ChineseToPinyin.pinyinFromChiniseString(spliceText))
        }
        
        var appStoreURLString: NSString = NSString(format: "https://itunes.apple.com/cn/app/%@/id%@?mt=8",spliceArray.componentsJoinedByString("-"), appid)
        return appStoreURLString.lowercaseString
    }
    
    /*
    设置导航栏的背景 支持大部分iOS版本
    */
    class func setNavigationBar(navBar: UINavigationBar!, backgroundImage: UIImage!) {
        // Insert ImageView
        var imgv: UIImageView = UIImageView(image: backgroundImage)
        imgv.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        imgv.frame = navBar.bounds
        ACUtilitys.setNavigationBar(navBar, contentView: imgv)
    }
    
    /*
    给导航栏添加一个view覆盖在上面
    */
    class func setNavigationBar(navBar: UINavigationBar!, contentView: UIView!) {
        // Insert View
        contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        contentView.frame = navBar.bounds
        var v: UIView = navBar.subviews[0] as UIView
        
        v.layer.zPosition = CGFloat(-FLT_MAX)
        contentView.layer.zPosition = CGFloat(-FLT_MAX + 1.0)
        navBar.insertSubview(contentView, atIndex: 1)
    }
    
    /*
    当请求返回无数据时显示
    @flag 是否显示
    @view 显示提示的view
    @content 提示内容
    */
    class func showNoContent(flag: Bool, displayView: UIView!, displayContent: NSString!) {
        if flag {
            var label: UILabel! = nil
            if displayView.viewWithTag(99998) {
                label = UILabel(frame: CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeight / 4.0))
                label.tag = 99998
                label.backgroundColor = UIColor.clearColor()
                label.textColor = UIColor.lightGrayColor()
                label.font = UIFont.systemFontOfSize(17.0)
                label.textAlignment = NSTextAlignment.Center
                label.center = displayView.center
                displayView.addSubview(label)
            }
            else {
                label = displayView.viewWithTag(99998) as UILabel
            }
            label.alpha = 0.0
            label.text = displayContent
            UIView.animateWithDuration(0.3, animations: {
                label.alpha = 1.0
                })
        }
        else {
            if displayView.viewWithTag(99998) {
                var view = displayView.viewWithTag(99998)
                UIView.animateWithDuration(0.3, animations: {
                    view.alpha = 0.0
                    }, completion: {
                        (finished: Bool) in
                        view.removeFromSuperview()
                    })
            }
        }
    }
    
    /*
    半角转全角
    @dbc 半角字符串
    @info 半角中空格的ascii码为32（其余ascii码为33-126），全角中空格的ascii码为12288（其余ascii码为65281-65374）
        半角与全角之差为65248
        半角转全角
    */
    class func DBCToSBC(dbc: NSString!) -> NSString {
        var sbc: NSString = ""
        for var i = 0; i < dbc.length; i++ {
            var temp:unichar = dbc.characterAtIndex(i)
            if temp >= 33 && temp <= 126 {
                temp = temp + 65248
                sbc = NSString(format: "%@%C", sbc, temp)
            }
            else {
                if temp == 32 {
                    temp = 12288
                }
                sbc = NSString(format: "%@%C",sbc,temp)
            }
        }
        return sbc
    }
    
    /*
    全角转半角
    @sbc 全角字符串
    */
    class func SBCToDBC(sbc: NSString!) -> NSString {
        var dbc: NSString = ""
        for var i = 0; i < sbc.length; i++ {
            var temp: unichar = sbc.characterAtIndex(i)
            if temp >= 65281 && temp <= 65374 {
                temp = temp - 65248
                dbc = NSString(format: "%@%C",dbc,temp)
            }
            else {
                if temp == 12288 {
                    temp = 32
                }
                dbc = NSString(format: "%@%C",dbc,temp)
            }
        }
        
        return dbc
    }
    
    /*
    生成from到to之间的随机数
    范围是[from,to) 包含from,不包含to
    */
    class func getRandomNumber(#range: (from: NSInteger, to: NSInteger)) -> NSInteger {
        
        
        return range.from + NSInteger(arc4random() % (range.to - range.from + 1))
    }
    
    /*
    生成0-to之间的随机数
    范围是[0,to) 包含0,不包含to
    */
    class func getRandomNumberTo(to: NSInteger) -> NSInteger {
        return ACUtilitys.getRandomNumber(range: (0, to))
    }
    
    /*
    生成浮点型的随机数
    范围[from,to) 包含from,不包含to
    默认随机数一位小数点
    */
    class func getFloatRandomNumber(#range: (from: Double, to: Double)) -> Double {
        var randomNumber = range.from + Double(arc4random()) / Double(ARC4RANDOM_MAX) * range.to
        
        return NSString(format:"%0.1f", randomNumber).doubleValue
    }
}
