//
//  EOColorView.m 颜色color
//  EastOffice2.0
//
//  Created by YLY on 2017/11/30.
//  Copyright © 2017年 EO. All rights reserved.
//

#import "EOColorView.h"
#import "UIColor+SaiV1Color.h"

#define kSCRATIO(x)   ceil(((x) * ([UIScreen mainScreen].bounds.size.width / 375)))
#define kColorFromRGBHex(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

@interface EOColorView ()

@property (strong, nonatomic) NSArray *colorStringArr;
@property (strong, nonatomic) NSString *colorString;
@property (strong, nonatomic) UIImageView *showView;
@property (strong, nonatomic) UIView *showColor;

@end

@implementation EOColorView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    int index = floor(point.x / kSCRATIO(15));
    if (index >= 0 && index < self.colorStringArr.count) {
        NSString *colorString = self.colorStringArr[index];
        !self.colorBlock ? : self.colorBlock(colorString);
        
        if (!self.showView) {
            self.showView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fangda1"]];
            self.showView.frame = CGRectZero;
            self.showColor = [[UIView alloc] init];
            self.showColor.frame = CGRectZero;
        }
        
        [self addSubview:self.showView];
        [self.showView addSubview:self.showColor];
        self.showView.frame = CGRectMake(point.x - kSCRATIO(17.5), kSCRATIO(-37.5), kSCRATIO(35), kSCRATIO(65));
        self.showColor.frame = CGRectMake(kSCRATIO(2), kSCRATIO(2), kSCRATIO(30), kSCRATIO(28));
        self.showColor.backgroundColor = [UIColor ty_colorWithHex:colorString];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    int index = floor(point.x / kSCRATIO(15));
    if (index >= 0 && index < self.colorStringArr.count) {
        NSString *colorString = self.colorStringArr[index];
        !self.colorBlock ? : self.colorBlock(colorString);
        
        self.showView.frame = CGRectMake(point.x - kSCRATIO(17.5), kSCRATIO(-37.5), kSCRATIO(35), kSCRATIO(65));
        self.showColor.backgroundColor = [UIColor ty_colorWithHex:colorString];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.showView removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = NO;
        self.colorStringArr = @[@"dc0000", @"f88c20", @"f4eb22", @"5ce91e", @"06a723", @"21ecfa", @"23adf5", @"0057fe", @"151de4", @"6c21f7", @"cb23f4", @"fe009e", @"f7a5b1", @"f6f6f6", @"ad6130", @"85420b", @"878586", @"414141", @"000000"];
        for (int i = 0; i < self.colorStringArr.count; i++) {
            CALayer *layer = [[CALayer alloc] init];
            layer.frame = CGRectMake(i * kSCRATIO(15), 0, kSCRATIO(15), kSCRATIO(25));
            layer.backgroundColor = [UIColor ty_colorWithHex:self.colorStringArr[i]].CGColor;
            [self.layer addSublayer:layer];
        }
    }
    return self;
}

@end
