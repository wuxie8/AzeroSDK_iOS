//
//  EOColorView.h
//  EastOffice2.0
//
//  Created by YLY on 2017/11/30.
//  Copyright © 2017年 EO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EOColorView : UIView

@property (copy, nonatomic) void(^colorBlock)(NSString *colorString);

@end
