//
//  NSObject+customCategory.h
//  SqliteNotes
//
//  Created by Zaur Giyasov on 01/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (customCategory)

//-(NSString *)dateFofmattedFromDouble:(double)time;
-(NSString *)setCustomStringFromDate:(NSDate *)date;
//-(NSDate *)dateFromTime:(double)time;
//-(double)dateDoubleFromDate:(NSDate *)date;
-(NSDate *)setCustomDateFromString:(NSString *)dateText;
//-(NSString *)textFromDate:(NSDate *)date;
-(double)setCustomDoubleFromDate:(NSDate *)date;

//-(NSDate *)dateFromTime:(double)time
//-(NSString *)dateFofmattedFromDouble:(double)time
@end
