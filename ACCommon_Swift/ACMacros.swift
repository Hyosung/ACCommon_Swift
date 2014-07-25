//
//  ACMacros.swift
//  ACCommon_Swift
//
//  Created by i云 on 14-7-25.
//  Copyright (c) 2014年 Alone Coding. All rights reserved.
//

import Foundation

let kACAppleID: NSString = "Apple ID"
let kACCompanyName: NSString = "Company Name"

/*
用于在浏览器中跳转到App Store应用中去的链接 并跳转到评分页面
*/
let kScoreURL: NSString = "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" + kACAppleID

/*
用于在Apple Store上请求当前Apple ID 的相关信息的链接
*/
let kAppURL: NSString = "http://itunes.apple.com/lookup?id=" + kACAppleID

func DataURLString(text: NSString) -> NSString {
    if text != nil && text.isKindOfClass(NSClassFromString("NSString")) {
        return "http://app.zontenapp.com.cn/" + text
    }
    return "http://app.zontenapp.com.cn/"
}

func ImageURLString(text: NSString) -> NSString {
    if text != nil && text.isKindOfClass(NSClassFromString("NSString")) {
        return "http://app.zontenapp.com.cn/" + text
    }
    return "http://app.zontenapp.com.cn/"
}

let kScreenSize: CGSize = UIScreen.mainScreen().bounds.size
let kScreenWidth: CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds)
let kScreenHeight: CGFloat = CGRectGetHeight(UIScreen.mainScreen().bounds)
let kScreenBounds: CGRect = UIScreen.mainScreen().bounds

let kTabBarHeight: CGFloat = 49.0
let kToolBarHeight: CGFloat = 44.0
let kStatusBarHeight: CGFloat = 20.0
let kNavigationBarHeight: CGFloat = 44.0

let APP_CONTENT_HEIGHT  (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT - TAB_BAR_HEIGHT)
let APP_CONTENT_NOT_NAV (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT)
let APP_CONTENT_NOT_TAB (SCREEN_HEIGHT - TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT)

/*
故事板
*/
let MAIN_STORYBOARD [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]

let APP_SHARE    [UIApplication sharedApplication]
let USER_DEFAULT [NSUserDefaults standardUserDefaults]
let FILE_MANAGER [NSFileManager defaultManager]

//对象强转（可针对C、OC两种）
let OBJ_CONVERT(_type,_name,_obj) _type _name = (_type)(_obj)
//OC对象强转（只针对OC对象）
let OC_OBJ_CONVERT(_type,_name,_obj,_tag) OBJ_CONVERT(_type *,_name,[_obj viewWithTag:(_tag)])

//基础类型的类型编码字符
let _C_ENCODE @"cCsSiIlLqQfdbB"
let __C_BASE_TYPE__(_value) ( [_C_ENCODE rangeOfString:[NSString stringWithCString:@encode(__typeof__(_value)) encoding:NSUTF8StringEncoding] options:NSRegularExpressionSearch].location != NSNotFound )

//C基础类型转NSNumber
let CBT_CONVERT_OC(_cvalue) ({ __typeof__(_cvalue) __NSX_PASTE__(_a,L) = (_cvalue); __C_BASE_TYPE__(__NSX_PASTE__(_a,L)) ? @(__NSX_PASTE__(_a,L)) : [NSValue value:&__NSX_PASTE__(_a,L) withObjCType:@encode(__typeof__(__NSX_PASTE__(_a,L)))]; })

//C类型转NSValue
let C_CONVERT_OC(_cobj) ({__typeof__(_cobj) __NSX_PASTE__(_a,L) = (_cobj); [NSValue value:&__NSX_PASTE__(_a,L) withObjCType:@encode(__typeof__(__NSX_PASTE__(_a,L)))]; })

//处理字符串
let DEAL_WITH_STRING(_str) ({((_str) && (![_str isKindOfClass:[NSNull class]])) ? (_str) : @"";})

//方法调用，不存在不会出错
let AC_FUNCTION_CALL(_obj, _fun, ...) \
do { \
    if((_obj) && [_obj respondsToSelector:@selector(_fun)]) { \
        objc_msgSend(_obj, @selector(_fun), ##__VA_ARGS__); \
    } \
} while(0);

let AC_STATIC_INLINE static inline

#pragma mark - degrees/radian functions
/*
旋转的单位采用弧度(radians),而不是角度（degress）。以下两个函数，你可以在弧度和角度之间切换。
*/
let DegreesToRadians(degrees) ((degrees) * M_PI / 180.0)
let RadiansToDegrees(radians) ((radians) * 180.0 / M_PI)

#pragma mark - color functions

let COLORHEXA(rgbValue,alpha)                                    \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8 )) / 255.0 \
blue:((float)((rgbValue & 0x0000FF) >> 0 )) / 255.0 \
alpha:alpha]

let COLORRGBA(r,g,b,a)         \
[UIColor colorWithRed:(r) / 255.0f \
green:(g) / 255.0f \
blue:(b) / 255.0f \
alpha:(a)]

let COLORRGB(r,g,b) COLORRGBA(r,g,b,1.0)

let COLORHEX(hex) COLORHEXA(hex,1.0)

let APP_TMP_ADDTO(_path) [NSString stringWithFormat:@"%@/%@",NSTemporaryDirectory(),_path]

let APP_CACHES   [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
let APP_LIBRARY  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]
let APP_DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

let CUT_PLAN(_image,_rect) [UIImage imageWithCGImage:CGImageCreateWithImageInRect([_image CGImage], _rect)]

let IOS_VERSION          [[UIDevice currentDevice].systemVersion floatValue]
let CurrentPhone         ([UIDevice currentDevice].model)
let CurrentLanguage      ([NSLocale preferredLanguages][0])
let StatusOrientation    ([UIApplication sharedApplication].statusBarOrientation)
let CurrentOrientation   ([UIDevice currentDevice].orientation)
let CurrentSystemVersion ([UIDevice currentDevice].systemVersion)

let ACSTR(fmt,...) [NSString stringWithFormat:(fmt),##__VA_ARGS__]

//use dlog to print while in debug model
#ifdef DEBUG
let ACLog(fmt, ...) NSLog((@"[Time %s] [Function %s] [Name i雲] [Line %d] " fmt),__TIME__, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
let ACLog(...) do{ }while(0);
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    let IOS7_AND_LATER ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    #else
    let IOS7_AND_LATER (0)
    #endif
    
    //#if IOS7_AND_LATER
    //let SCORE_URL [@"itms-apps://itunes.apple.com/app/id" stringByAppendingString:APP_ID]
    //#else
    //let SCORE_URL [@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" stringByAppendingString:APP_ID]
    //#endif
    
    let isiPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    let iPhone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
    let isRetina ([UIScreen mainScreen].scale == 2)
    
    #if TARGET_OS_IPHONE
    //iPhone Device
    #endif
    
    #if TARGET_IPHONE_SIMULATOR
    //iPhone Simulator
    #endif
    
    #if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    let __IOS_64__ (1)
    #else
    let __IOS_64__ (0)
    #endif
    
    
    //ARC
    #if __has_feature(objc_arc)
    //compiling with ARC
    #else
    // compiling without ARC
    
    let SAFE_RELEASE(x) [x release];x=nil
    
    #pragma mark - common functions
    let RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }
    
    #endif
    
    //G－C－D
    let AC_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    let AC_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)
    
    /*
    保持竖屏
    */
    let AC_PORTRAIT()  \
    - (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation\
    {\
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);\
    }\
    \
    \
    - (BOOL)shouldAutorotate\
    {\
    return NO;\
    }\
    \
    - (NSUInteger)supportedInterfaceOrientations\
    {\
    return UIInterfaceOrientationMaskPortrait;\
    }\
    \
    - (UIInterfaceOrientation)preferedInterfaceOrientationForPresentation\
    {\
    return UIInterfaceOrientationPortrait;\
    }
    
    /*
    保持四个方向都可以
    */
    let AC_ORIENTATION_ALL() \
    - (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation\
    {\
    return YES;\
    }\
    \
    \
    - (BOOL)shouldAutorotate\
    {\
    return YES;\
    }\
    \
    - (NSUInteger)supportedInterfaceOrientations\
    {\
    return UIInterfaceOrientationMaskAll;\
    }\
    \
    - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation\
    {\
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;\
    }
