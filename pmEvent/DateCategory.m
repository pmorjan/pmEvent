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

- (NSDate *)dateFourYearsAgo
{
    NSDateComponents *components = [[[NSDateComponents alloc] init]autorelease];
    [components setYear:-4];
    [components setDay:+1];
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}

- (NSInteger)pastDaysSinceDate:(NSDate*)aDate
{
    return [[[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:[aDate dateAtMidnight]
                                              toDate:[self dateAtMidnight] options:0]day];
}

- (NSString *)descriptionISO
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc]init]autorelease];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss"; 
    return [dateFormatter stringFromDate:self];
}

- (NSString *)descriptionUserPreferences
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:self];
}

@end
