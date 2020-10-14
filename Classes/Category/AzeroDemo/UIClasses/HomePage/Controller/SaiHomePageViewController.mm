//
//  SaiHomePageViewController.m
//  AzeroDemo
//
//  Created by mike on 2020/3/25.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiHomePageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Contacts/Contacts.h>
#import "AppDelegate.h"
#import "SaiMpToPcmManager.h"
#import "SaiSoundWaveView.h"

#define  imageWidth 25
#define  viewWidth 135

@interface SaiHomePageViewController ()
@property (nonatomic, strong) dispatch_queue_t timeQueue;
@property (nonatomic, strong) dispatch_queue_t recordQueue;
@property (nonatomic,assign) BOOL isInterrupt;

@end

@implementation SaiHomePageViewController
#pragma mark -  Life Cycle
+ (instancetype)sharedInstance {
    static SaiHomePageViewController *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[SaiHomePageViewController alloc]init];
    });
    return player;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self assignmentAzeroManagerBlockHandle];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SaiSoundWaveView showBlue];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self requestContactAuthorAfterSystemVersion];
    [self registerNoti];
    [[SaiMpToPcmManager sharedSaiMpToPcmManager] setup];
    [[SaiAzeroManager sharedAzeroManager] saiTtsPlayComplete:^{
        dispatch_async(self.timeQueue, ^{
            [[SaiAzeroManager sharedAzeroManager] saiManagerResetAudioQueuePlay];
        });
    }];
    [[SaiAzeroManager sharedAzeroManager] saiManagerRecordCallBack:^(NSDictionary *dict) {
        NSData *data = dict[@"data"];
        dispatch_async((self.recordQueue), ^{
            [[SaiAzeroManager sharedAzeroManager] saiAzeroManagerWriteData:data];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            float aa0=[[NSString stringWithFormat:@"%@",dict[@"volLDB"]] floatValue];
            [SaiSoundWaveView shareHud].level=aa0;
        });
    }];
}


#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response

#pragma mark -  Notification Methods
- (void)saiApplicationWillEnterForeground{
    if (self.isInterrupt) {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        self.isInterrupt = NO;
    }
}


#pragma mark -  Button Callbacks
#pragma mark -  Private Methods
- (void)assignmentAzeroManagerBlockHandle{
    blockWeakSelf;
    [[SaiAzeroManager sharedAzeroManager] saiAzeroPlayTtsStatePrepare:^{
        dispatch_async(weakSelf.timeQueue, ^{
            [[SaiMpToPcmManager sharedSaiMpToPcmManager] prepareConversionAudio];
        });
    }];
}
- (void)registerNoti{
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
}


#pragma mark -  Life Cycle
#pragma mark -  Public Methods
#pragma mark -  Setters and Getters
//懒加载创建子线程   
- (dispatch_queue_t)timeQueue
{
    if (!_timeQueue) {
        _timeQueue = dispatch_queue_create("com.timer.soundai", DISPATCH_QUEUE_CONCURRENT);
    }
    return _timeQueue;
}
- (dispatch_queue_t)recordQueue{
    if (!_recordQueue) {
        _recordQueue = dispatch_queue_create("com.record.soundai", DISPATCH_QUEUE_CONCURRENT);
    }
    return _recordQueue;
}
//请求通讯录权限
#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        blockWeakSelf;
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                TYLog(@"授权失败");
            }else {
                TYLog(@"成功授权");
                [weakSelf openContact];
            }
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        TYLog(@"用户拒绝");
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        TYLog(@"用户拒绝");
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
        [self openContact];
    }
}

//有通讯录权限-- 进行下一步操作
- (void)openContact{
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    BOOL begin = [[SaiAzeroManager sharedAzeroManager] saiAddContactsBegin];
    if (begin) {
        NSMutableArray *contactAry = [NSMutableArray array];
        [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            NSString *givenName = contact.givenName;
            NSString *familyName = contact.familyName;
            //拼接姓名
            
            NSArray *phoneNumbers = contact.phoneNumbers;
            
            if (phoneNumbers.count != 0) {
                CNLabeledValue  * cnphoneNumber = phoneNumbers[0];
                CNPhoneNumber *phoneNumber = cnphoneNumber.value;
                
                NSString * string = phoneNumber.stringValue;
                
                string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                if ([QKUITools isBlankString:string]&&[QKUITools isBlankString:familyName]&&[QKUITools isBlankString:givenName]) {
                    
                }else{
                    NSDictionary *dic = @{@"id": string,@"firstName":familyName,@"lastName":givenName,@"addresses":@[@{@"value":string,@"type":string,@"label":@"phone"}
                    ]};
                    [contactAry addObject:dic];
                    //                    BOOL success = [[SaiAzeroManager sharedAzeroManager] saiAddContact:[dic modelToJSONString]];
                    //                    TYLog(@"success = %d",success);
                }
            }
            
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[SaiAzeroManager sharedAzeroManager] saiAddContactsEnd];
            TYLog(@"查询到的联系人是什么  %@",[[SaiAzeroManager sharedAzeroManager] saiQueryContact]);
            
        });
    }
}
@end
