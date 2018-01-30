//
//  formattime.m
//  幼儿园平台
//
//  Created by admin on 16/1/20.
//  Copyright (c) 2016年 ZhiYiChuangXin. All rights reserved.
//

#import "formattime.h"

@implementation formattime
//时间戳转换成字符串
+ (NSString *)formateTime:(NSString *)time
{
    NSTimeInterval tempTime = [time intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterT = [[NSDateFormatter alloc] init];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimespT = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatterT setDateFormat:@"HH:mm"];
    NSDate *startDate = confromTimesp;
    NSDate *endDate = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    NSDateComponents *endDateComponents = [cal components:unitFlags fromDate:endDate];
    NSDateComponents *startDateComponents = [cal components:unitFlags fromDate:startDate];
    
    NSInteger d_endDate = [endDateComponents day];
    int64_t d_startDate = [startDateComponents day];
    
    NSString *confromTimespStr =nil;
    if (d_endDate - d_startDate == 0)
        confromTimespStr =[NSString stringWithFormat:@"今天 %@",[formatterT stringFromDate:confromTimespT]] ;
    else if (d_endDate - d_startDate == 1)
        confromTimespStr =[NSString stringWithFormat:@"昨天 %@",[formatterT stringFromDate:confromTimespT]] ;
    else if (d_endDate - d_startDate == 2)
        confromTimespStr =[NSString stringWithFormat:@"前天 %@",[formatterT stringFromDate:confromTimespT]] ;
    else
        confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

+ (NSString *)formateTimeYM:(NSString *)time{
    
    NSTimeInterval tempTime = [time intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterT = [[NSDateFormatter alloc] init];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSDate *confromTimespT = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatterT setDateFormat:@"HH:mm"];
    NSDate *startDate = confromTimesp;
    NSDate *endDate = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    NSDateComponents *endDateComponents = [cal components:unitFlags fromDate:endDate];
    NSDateComponents *startDateComponents = [cal components:unitFlags fromDate:startDate];
    
    NSInteger d_endDate = [endDateComponents day];
    int64_t d_startDate = [startDateComponents day];
    
    NSString *confromTimespStr =nil;
    if (d_endDate - d_startDate == 0)
        confromTimespStr =[NSString stringWithFormat:@"今天 %@",[formatterT stringFromDate:confromTimespT]];
    else if (d_endDate - d_startDate == 1)
        confromTimespStr =[NSString stringWithFormat:@"昨天 %@",[formatterT stringFromDate:confromTimespT]];
    else if (d_endDate - d_startDate == 2)
        confromTimespStr =[NSString stringWithFormat:@"前天 %@",[formatterT stringFromDate:confromTimespT]];
    else
        confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;

}
+ (NSString *)formateTimeOfDate:(NSString *)time{
    
    NSTimeInterval tempTime = [time intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterT = [[NSDateFormatter alloc] init];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatter setDateFormat:@"MM-dd"];
    NSDate *confromTimespT = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatterT setDateFormat:@"HH:mm"];
    NSDate *startDate = confromTimesp;
    NSDate *endDate = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    NSDateComponents *endDateComponents = [cal components:unitFlags fromDate:endDate];
    NSDateComponents *startDateComponents = [cal components:unitFlags fromDate:startDate];
    
    NSInteger d_endDate = [endDateComponents day];
    int64_t d_startDate = [startDateComponents day];
    
    NSString *confromTimespStr =nil;
    if (d_endDate - d_startDate == 0)
        confromTimespStr =[NSString stringWithFormat:@"今天 %@",[formatterT stringFromDate:confromTimespT]];
    else if (d_endDate - d_startDate == 1)
        confromTimespStr =[NSString stringWithFormat:@"昨天 %@",[formatterT stringFromDate:confromTimespT]];
    else if (d_endDate - d_startDate == 2)
        confromTimespStr =[NSString stringWithFormat:@"前天 %@",[formatterT stringFromDate:confromTimespT]];
    else
        confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}
+ (NSString *)formateTimeOfDate2:(NSString *)time{
    
    NSTimeInterval tempTime = [time intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterT = [[NSDateFormatter alloc] init];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatter setDateFormat:@"dd/MM月"];
    NSDate *confromTimespT = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatterT setDateFormat:@"HH:mm"];
    NSDate *startDate = confromTimesp;
    NSDate *endDate = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    NSDateComponents *endDateComponents = [cal components:unitFlags fromDate:endDate];
    NSDateComponents *startDateComponents = [cal components:unitFlags fromDate:startDate];
    
    NSInteger d_endDate = [endDateComponents day];
    int64_t d_startDate = [startDateComponents day];
    
    NSString *confromTimespStr =nil;
    if (d_endDate - d_startDate == 0)
        confromTimespStr =[NSString stringWithFormat:@"今天 %@",[formatterT stringFromDate:confromTimespT]];
    else if (d_endDate - d_startDate == 1)
        confromTimespStr =[NSString stringWithFormat:@"昨天 %@",[formatterT stringFromDate:confromTimespT]];
    else if (d_endDate - d_startDate == 2)
        confromTimespStr =[NSString stringWithFormat:@"前天 %@",[formatterT stringFromDate:confromTimespT]];
    else
        confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}
+ (NSString *)formateTimeOfDate3:(NSString *)time{
    
    NSTimeInterval tempTime = [time intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterT = [[NSDateFormatter alloc] init];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSDate *confromTimespT = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatterT setDateFormat:@"HH:mm"];
    NSDate *startDate = confromTimesp;
    NSDate *endDate = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    NSDateComponents *endDateComponents = [cal components:unitFlags fromDate:endDate];
    NSDateComponents *startDateComponents = [cal components:unitFlags fromDate:startDate];
    
    NSInteger d_endDate = [endDateComponents day];
    int64_t d_startDate = [startDateComponents day];
    
    NSString *confromTimespStr =nil;
    if (d_endDate - d_startDate == 0)
        confromTimespStr =[NSString stringWithFormat:@"今天 %@",[formatterT stringFromDate:confromTimespT]] ;
    else if (d_endDate - d_startDate == 1)
        confromTimespStr =[NSString stringWithFormat:@"昨天 %@",[formatterT stringFromDate:confromTimespT]] ;
    else if (d_endDate - d_startDate == 2)
        confromTimespStr =[NSString stringWithFormat:@"前天 %@",[formatterT stringFromDate:confromTimespT]] ;
    else
        confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}
+ (NSString *)formateTimeOfDate4:(NSString *)time{
    
    NSTimeInterval tempTime = [time intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    NSDateFormatter *formatterT = [[NSDateFormatter alloc] init];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatter setDateFormat:@"YYYY.MM.dd"];
//    NSDate *confromTimespT = [NSDate dateWithTimeIntervalSince1970:tempTime];
//    [formatterT setDateFormat:@"HH:mm"];
//    NSDate *startDate = confromTimesp;
//    NSDate *endDate = [NSDate date];
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
//    NSDateComponents *endDateComponents = [cal components:unitFlags fromDate:endDate];
//    NSDateComponents *startDateComponents = [cal components:unitFlags fromDate:startDate];
    
//    NSInteger d_endDate = [endDateComponents day];
//    int64_t d_startDate = [startDateComponents day];
    
    NSString *confromTimespStr =nil;
//    if (d_endDate - d_startDate == 0)
//        confromTimespStr =[NSString stringWithFormat:@"今天 %@",[formatterT stringFromDate:confromTimespT]] ;
//    else if (d_endDate - d_startDate == 1)
//        confromTimespStr =[NSString stringWithFormat:@"昨天 %@",[formatterT stringFromDate:confromTimespT]] ;
//    else if (d_endDate - d_startDate == 2)
//        confromTimespStr =[NSString stringWithFormat:@"前天 %@",[formatterT stringFromDate:confromTimespT]] ;
//    else
        confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}
@end
