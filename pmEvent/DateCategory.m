//
//  DateCategory.m
//  pmEvent
//

#import "DateCategory.h"

@implementation NSDate (DateCategory)

- (NSDate *)dateZeroSeconds 
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    return [gregorian dateFromComponents:components];
}

- (NSDate *)dateAtMidnight 
{   
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:flags fromDate:self];
    return [gregorian dateFromComponents:components];
}

- (NSDate *)dateByAddingOneDay
{
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSDateComponents *components = [[[NSDateComponents alloc] init]autorelease]; 
    [components setDay:1]; 
    return [gregorian dateByAddingComponents:components toDate:self options:0];
}

@end
