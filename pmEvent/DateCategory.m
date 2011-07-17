//
//  DateCategory.m
//  pmEvent
//

#import "DateCategory.h"

@implementation NSDate (DateCategory)

- (NSDate *)dateZeroSeconds 
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:self];
    return [self dateByAddingTimeInterval:(-1 * [dateComponents second])];
}

- (NSDate *)dateAtMidnight 
{   
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate:self];
    return [calendar dateFromComponents:components];
}

- (NSDate *)dateAddOneDay 
{
    NSDateComponents *components = [[[NSDateComponents alloc] init]autorelease]; 
    [components setDay:1]; 
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

@end
