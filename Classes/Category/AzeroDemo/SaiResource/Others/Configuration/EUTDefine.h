//
//  EUTDefine.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/26.
//  Copyright © 2018 soundai. All rights reserved.
//

#ifndef EUTDefine_h
#define EUTDefine_h
//**********************************************************************************************
//****    AppID          ********************************************************************
//**********************************************************************************************


//#ifdef DEBUG
//
//#define APPUrl fatUrl
//#else
#define APPUrl ProductUrl
//#endif
//**********************************************************************************************
//****    UMKey          ********************************************************************
//**********************************************************************************************



//**********************************************************************************************
//****    定义的通知          ********************************************************************
//**********************************************************************************************

#define SaiContext                  [UserInfoContext sharedContext]



#define SaiNotificationCenter     [NSNotificationCenter defaultCenter]

//*********************************************************************************************
//****    RGB颜色        ********************************************************************
//**********************************************************************************************
#pragma mark Color

#define kColorFromRGBHex(value)     [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16)) / 255.0 green:((float)((value & 0xFF00) >> 8)) / 255.0 blue:((float)(value & 0xFF)) / 255.0 alpha:1.0]
#define SaiColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define Color999999  kColorFromRGBHex(0x999999)
#define Color666666  kColorFromRGBHex(0x666666)
#define Color333333  kColorFromRGBHex(0x333333)

//**********************************************************************************************
//****   调试状态              *****************************************************************
//**********************************************************************************************

#ifdef DEBUG
// 打开LOG功能
//#define TYLog(format, ...) printf("%s [第%d--] %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#define TYLog(s, ... ) NSLog( @"[%@  %s in line %d--] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent],__FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else // 发布状态
// 关闭LOG功能
#define TYLog(...)
#endif

#pragma mark 系统文件位置

#define DOCUMENT_FOLDER(fileName) [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:fileName]
#define CACHE_FOLDER(fileName)    [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]

//**********************************************************************************************
//****   屏幕尺寸             *****************************************************************
//**********************************************************************************************
//避免重复定义
#ifndef ScreenHeight
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#endif

#ifndef ScreenWidth
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#endif
#define kScreenScale   ([UIScreen mainScreen].scale)
#define ViewWidth      (self.view.bounds.size.width)
#define ViewHeight     (self.view.bounds.size.height)
#define kSCRATIO(x)   ceil(((x) * ([UIScreen mainScreen].bounds.size.width / 375)))

#define HScreenRatio   [UIScreen mainScreen].bounds.size.height/667
#define WScreenRatio   [UIScreen mainScreen].bounds.size.width/375
// 判断是否是iPhone X系列
#define IS_IPHONE_X      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
(\
CGSizeEqualToSize(CGSizeMake(375, 812),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(812, 375),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(414, 896),[UIScreen mainScreen].bounds.size)\
||\
CGSizeEqualToSize(CGSizeMake(896, 414),[UIScreen mainScreen].bounds.size))\
:\
NO)
#define kStatusBarHeight         (IS_IPHONE_X ? 44 : 20)
#define kNavHeight               (IS_IPHONE_X ? 88 : 64)
#define BOTTOM_HEIGHT            (IS_IPHONE_X ? 34 : 0)

//**********************************************************************************************
//****    判断版本         ********************************************************************
//**********************************************************************************************

#define isIOS11 ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)
#define isIOS11Low ([[UIDevice currentDevice].systemVersion doubleValue] < 11.0)
#define isIOS12 ([[UIDevice currentDevice].systemVersion doubleValue] >= 12.0)
#define isIOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
#define isIOS13 ([[UIDevice currentDevice].systemVersion doubleValue] >= 13.0)


#define blockWeakSelf __weak typeof(self) weakSelf = self
//tableview背景色
#define kTableViewBackColor                     [UIColor colorWithRed:247.0/255.0 green:248.0/255.0 blue:249.0/255.0 alpha:1]


//机型判断
#define Sai_iPhone6  (kScreenWidth == 375.f && kScreenHeight == 667.f ? YES : NO)
#define Sai_iPhoneX  (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)
#define Sai_iPhoneXS  (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)
#define Sai_iPhoneXsXrMax  (kScreenWidth == 414.f && kScreenHeight == 896.f ? YES : NO)

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#endif /* EUTDefine_h */
