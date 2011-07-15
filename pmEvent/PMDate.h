//
//  PMDate.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>

@interface PMDate : NSDate 
{
}

+ (NSDate *)lastMidnight;
+ (NSDate *)midnightOfDate:(NSDate *)aDate;
+ (NSDate *)dateZeroSeconds;
+ (NSDate *)dateZeroSecondsOfDate:(NSDate *)aDate;

@end
