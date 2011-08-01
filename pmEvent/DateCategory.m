//
//  DateCategory.m
//  pmEvent
//

#import "DateCategory.h"

@implementation NSDate (DateCategory)

- (NSDate *)dateZeroSeconds 
{
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    return [[NSCalendar currentCalendar] dateFromComponents:[[NSCalendar currentCalendar] components:flags fromDate:self]];
}

- (NSDate *)dateAtMidnight 
{   
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    return [[NSCalendar currentCalendar] dateFromComponents:[[NSCalendar currentCalendar] components:flags fromDate:self]];
}

- (NSDate *)dateByAddingOneDay
{
    NSDateComponents *components = [[[NSDateComponents alloc] init]autorelease]; 
    [components setDay:1]; 
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

@end
