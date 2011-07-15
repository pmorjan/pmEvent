//
//  PMDate.m
//  pmEvent
//

#include "PMDate.h"

@implementation PMDate

+ (NSDate *)midnightOfDate:(NSDate *)aDate 
{
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSDateComponents *components = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate:aDate];
    return [gregorian dateFromComponents:components];
}

+ (NSDate *)lastMidnight 
{
    return [PMDate midnightOfDate:[NSDate date]];
}

+ (NSDate *)dateZeroSecondsOfDate:(NSDate *)aDate 
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:aDate];
    return [aDate addTimeInterval:(-1 * [dateComponents second])];
}

+ (NSDate *)dateZeroSeconds 
{
    NSDate *currDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:currDate];
    return [currDate addTimeInterval:(-1 * [dateComponents second])];
}

@end
