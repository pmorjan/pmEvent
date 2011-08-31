//
//  DateCategory.h
//  pmEvent
//

#import <Foundation/Foundation.h>


@interface NSDate (DateCategory)
- (NSDate *)dateZeroSeconds;
- (NSDate *)dateAtMidnight;
- (NSDate *)dateByAddingOneDay;
- (NSDate *)dateFourYearsAgo;
- (NSInteger)pastDaysSinceDate:(NSDate *)aDate;
- (NSString *)descriptionISO;
- (NSString *)descriptionIcalDate;
- (NSString *)descriptionUserPreferences;
@end
