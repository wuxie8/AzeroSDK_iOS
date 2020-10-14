//
//  SaiTextInputModel.m
//  AzeroDemo
//
//  Created by silk on 2020/4/1.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiTextInputModel.h"
#import "SaiUIUtils.h"
@implementation SaiTextInputModel
+ (NSString *)azeroTextInputEvent:(NSString *)eventText{
    NSString *messageId = [SaiUIUtils generateTradeNOWith:32];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"TextInput",
                        @"messageId":messageId,
                        @"dialogRequestId":@""
                },
                @"payload":@{
                        @"text":eventText,
                }
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}

+ (NSString *)azeroModelSwitchWithMode:(NSString *)mode andValue:(BOOL )value{
    NSString *messageId = [SaiUIUtils generateTradeNOWith:11];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"SwitchLocaleMode",
                        @"messageId":messageId,
                        @"dialogRequestId":@""
                },
                @"payload":@{
                        @"mode":mode,
                        @"value":value?@"ON":@"OFF"
                }
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}
+ (NSString *)azeroModelAcquireType:(NSString * )acquireType contentId:(NSString *)contentId  count:(int )count {
    NSString *messageId = [SaiUIUtils generateTradeNOWith:11];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"AcquireLauncher",
                        @"messageId":messageId,
                        @"dialogRequestId":@""
                },
                @"payload":@{
                        @"acquireType":acquireType,
                        @"contentId":contentId,
                        @"count":[NSNumber numberWithInt:count],

                }
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}

+ (NSString *)azeroModelRunSensorDataWithCalorie:(NSNumber * )calorie andDistance:(NSNumber * )distance
                                   andDuration:(NSNumber * )duration andStartTime:(NSNumber * )startTime andEndTime:(NSNumber * )endTime{
  
    NSString *messageId = [SaiUIUtils generateTradeNOWith:11];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"SensorData",
                        @"messageId":messageId,
                },
                @"payload":@{
                        @"run":@{
                                @"Id":[NSNumber numberWithLong:([self timeStamp].longLongValue+messageId.longLongValue)],
                                @"Calorie":calorie,
                                @"DataTag":[QKUITools getNowyyyymmdd],
                                @"Distance":distance,
                                @"Duration":duration,
                                @"StartTime":startTime,
                                @"EndTime":endTime
                        }
                }
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}
+ (NSString *)timeStamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这一点对时间的处理很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *dateNow = [NSDate date];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    return timeStamp;
}
+ (NSString *)azeroModelWalkSensorDataWithCalorie:(NSNumber * )calorie  andDistance:(NSNumber * )distance andStepCount:(NSNumber * )stepCount{
    NSString *messageId = [SaiUIUtils generateTradeNOWith:11];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"SensorData",
                        @"messageId":messageId,
                },
                @"payload":@{
                        @"walk":@{
                                @"Calorie":calorie,
                                @"DataTag":[QKUITools getNowyyyymmdd],
                                @"Distance":distance,
                                @"StepCount":stepCount
                        }
                }
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}
+ (NSString *)azeroManagerAnswerQuestion:(NSDictionary *)payload{
    NSString *messageId = [SaiUIUtils generateTradeNOWith:11];
    NSDictionary *dic = @{
        @"event":@{
                @"header":@{
                        @"namespace":@"AzeroExpress",
                        @"name":@"UserEvent",
                        @"messageId":messageId,
                },
                @"payload":payload
        }
    };
    NSString *jsonStr = [SaiJsonConversionModel dictionaryToJson:dic];
    return jsonStr;
}
@end
