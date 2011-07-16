//
//  DateCategory.h
//  pmEvent
//

#import <Foundation/Foundation.h>


@interface NSDate (DateCategory)
- (NSDate *)dateZeroSeconds;
- (NSDate *)dateAtMidnight;
- (NSDate *)dateAddOneDay;
@end
