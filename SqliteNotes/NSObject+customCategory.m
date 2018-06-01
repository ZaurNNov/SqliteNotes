//
//  NSObject+customCategory.m
//  SqliteNotes
//
//  Created by Zaur Giyasov on 01/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "NSObject+customCategory.h"

@implementation NSObject (customCategory)

-(NSString *)dateFofmattedFromDouble:(double)time {
    //Example:
    //double timeCreated = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"notecreated"]] doubleValue];
    
    NSString *dateStrFormat = @"YYYY-MM-dd HH:MM:ss";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = dateStrFormat;
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *currentDateString = [dateFormat stringFromDate:[self dateFromTime:time]];
    //NSLog(@"Time NSDateFormatter: %@", [dateFormat stringFromDate:[self dateFromTime:time]]);
    return currentDateString;
}

-(NSString *)dateFofmattedFromDate:(NSDate *)date {
    //Example:
    //double timeCreated = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"notecreated"]] doubleValue];
    
    NSString *dateStrFormat = @"YYYY-MM-dd HH:MM:ss";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = dateStrFormat;
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    //NSLog(@"Time NSDateFormatter: %@", [dateFormat stringFromDate:[self dateFromTime:time]]);
    NSString *currentDateString = [dateFormat stringFromDate:date];
    //NSLog(@"Prfile creation date is = %@",ProfileCreationDate);
    return currentDateString;
}

-(NSDate *)dateFromTime:(double)time {
    NSDate *dateCreated = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
    return dateCreated;
}

-(double)dateDoubleFromDate:(NSDate *)date {
    return [date timeIntervalSinceReferenceDate];
}

-(NSDate *)dateFromText:(NSString *)dateText {
    //dateText = NSString *ss = @"2012-09-16 23:59:59";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:+0020]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    NSDate *capturedDate = [dateFormatter dateFromString: dateText];
    NSLog(@"Captured Date %@", [capturedDate description]);
    return capturedDate;
}

-(NSString *)textFromDate:(NSDate *)date {
    double dt = [self dateDoubleFromDate:date];
    return [self dateFofmattedFromDouble:dt];
}


@end
