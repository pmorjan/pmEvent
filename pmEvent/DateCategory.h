//
//  DateCategory.h
//  pmEvent
//

#import <Foundation/Foundation.h>


@interface NSDate (DateCategory)
- (NSDate *)dateZeroSeconds;
- (NSDate *)dateAtMidnight;
- (NSDate *)dateByAddingOneDay;
- (NSInteger)pastDaysSinceDate:(NSDate *)aDate;
- (NSString *)descriptionISO;
- (NSString *)descriptionUserPreferences;
@end
