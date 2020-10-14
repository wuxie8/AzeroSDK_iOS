//
//  SaiBaseRootController.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/27.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "SaiBaseRootController.h"
#import "SaiTableView.h"
#import "SaiSoundWaveView.h"
#import "AppDelegate.h"
#import "SaiHomePageBallModel.h"
#import <objc/runtime.h>
#import "SaiHomePageViewController.h"
@interface SaiBaseRootController ()
@property(nonatomic,strong)SaiHomePageBallModel *ballModel;
@property (nonatomic ,assign) BOOL isSelfVC;
@property (nonatomic ,copy) NSString *alert_token;
@end  

@implementation SaiBaseRootController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏透明
    //    [self.navigationController.navigationBar setTranslucent:true];
    //    //把背景设为空
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.upSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
    [self.upSwipe setDirection: UISwipeGestureRecognizerDirectionRight];
    [self.upSwipe setNumberOfTouchesRequired:1];
    
    [self.view addGestureRecognizer:self.upSwipe];
    self.navigationController.navigationBar.translucent = NO;//设置导航栏为不是半透明状态
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior  = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerVadStart:^{
        TYLog(@" ==================================================================================================== saiAzeroManagerVadStart");
        dispatch_async(dispatch_get_main_queue(), ^{
            [SaiSoundWaveView showHudAni];
        });
    }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerVadStop:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [SaiSoundWaveView dismissHudAni];
            TYLog(@"--**localDetectorEventSpeechStopDetected4");
            
        });
    }];
    [[SaiAzeroManager sharedAzeroManager] saiSDKConnectionStatusChangedWithStatus:^(ConnectionStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case ConnectionStatusConnect:{
//                    [MessageAlertView showHudMessage:@"与SDK服务器建立连接"];
                    [[SaiPlaySoundManager sharedPlaySoundManager] playSoundWithSource:@"alert_network_connected.mp3"];
                }
                    
                    break;
                case ConnectionStatusPENDING:{
//                    [MessageAlertView showHudMessage:@"与SDK服务器断开连接"];
                    [[SaiPlaySoundManager sharedPlaySoundManager] playSoundWithSource:@"alert_network_disconnected.mp3"];
                    [SaiSoundWaveView hideAllView];
                }
                    break;
                case ConnectionStatusDisConnect:
                    [SaiSoundWaveView hideAllView];
                    break;
                default:
                    break;
            }
        });
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerExpress:^(NSString *type, NSString *content) {
        TYLog(@"&&&&&&type : %@ ,content : %@",type,content);
    }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroSongListInfo:^(NSString *songListStr) {
        TYLog(@"hello - saiAzeroSongListInfo ： renderPlayerInfo 内容：%@",songListStr);
    }];
    [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerRenderTemplate:^(NSString *renderTemplateStr) {
        TYLog(@"hello - saiAzeroManagerRenderTemplate ： renderTemplate 内容： %@",renderTemplateStr);

    }];
}
#pragma mark -  Button Callbacks

/**
 * @brief 将字符串转化为控制器.
 *
 * @param str 需要转化的字符串.
 *
 * @return 控制器(需判断是否为空).
 */
- (SaiBaseRootController*)stringChangeToClass:(NSString *)str {
    id vc = [[NSClassFromString(str) alloc]init];
    if ([vc isKindOfClass:[SaiBaseRootController class]]) {
        return (SaiBaseRootController *)vc;
    }
    return nil;
}
-(void)setNavigation {
    if ([[self.navigationController viewControllers] count] == 1) {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = nil;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    else
    {
        UIButton *backButton = [[UIButton alloc] init];
        backButton.frame = CGRectMake(20, kStatusBarHeight+15, 11, 19);
        [backButton setImage:[UIImage imageNamed:@"dl_back"] forState:UIControlStateNormal];
        [backButton addTarget: self action: @selector(backAction) forControlEvents: UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
        NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
        textAttrs[NSForegroundColorAttributeName] = UIColor.blackColor ;
        self.navigationController.navigationBar.titleTextAttributes =textAttrs;
    }
    
}

- (void)backAction{
    if (self.presentingViewController) {
        if (self.navigationController.childViewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else{
            [self backAnimation];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DefaultCell"];
}

/**
 *  自定义的tableView, 使用前确认tableView已经添加到view中,以及实现了对应的代理方法
 */
- (SaiTableView *)tableView{
    if (!_tableView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        if (self.isGroupTableView) {
            _tableView = [[SaiTableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        }else{
            _tableView = [[SaiTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    
    //    [self jumpAnimation];
    [super presentViewController: viewControllerToPresent animated:flag completion:completion];
}

//设置界面切换动画
/*!
 typedef enum : NSUInteger {
 Fade = 1,                   //淡入淡出
 Push,                       //推挤
 Reveal,                     //揭开
 MoveIn,                     //覆盖
 Cube,                       //立方体
 SuckEffect,                 //吮吸
 OglFlip,                    //翻转
 RippleEffect,               //波纹
 PageCurl,                   //翻页
 PageUnCurl,                 //反翻页
 CameraIrisHollowOpen,       //开镜头
 CameraIrisHollowClose,      //关镜头
 CurlDown,                   //下翻页
 CurlUp,                     //上翻页
 FlipFromLeft,               //左翻转
 FlipFromRight,              //右翻转
 
 } AnimationType;
 */
//跳转动画
-(void)jumpAnimation{
    CATransition* animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.view.window.layer addAnimation:animation forKey:nil];
    
}
-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    if ([[self.navigationController viewControllers] count] > 1) {
        [self backAnimation];
        
    }
    [super dismissViewControllerAnimated:flag completion:completion];
}


//返回动画
-(void)backAnimation{
    CATransition* animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.view.window.layer addAnimation:animation forKey:nil];
}
//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
//    [super traitCollectionDidChange:previousTraitCollection];
//    // trait发生了改变
//    if (@available(iOS 13.0, *)) {
//        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
//            TYLog(@"%@",previousTraitCollection);
//            switch (previousTraitCollection.userInterfaceStyle) {
//                case UIUserInterfaceStyleDark:
//                    //正常模式
//                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//                    break;
//                default:
//                    //深色模式
//                    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//                    [SaiNotificationCenter postNotificationName:SaiDidDarkModelNoti object:nil];
//                    break;
//            }
//        }
//    }
//}

@end
