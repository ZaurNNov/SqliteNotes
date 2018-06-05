//
//  NSObject+customCategory.h
//  SqliteNotes
//
//  Created by Zaur Giyasov on 01/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (customCategory)

-(NSString *)setCustomStringFromDate:(NSDate *)date;
-(NSDate *)setCustomDateFromString:(NSString *)dateText;
-(double)setCustomDoubleFromDate:(NSDate *)date;

@end
