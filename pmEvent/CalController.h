//
//  CalController.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>

@interface CalController : NSObject {

    
    NSString    *eventTitle;
    NSString    *eventNotes;
    NSString    *eventUrl;
    NSNumber    *eventAllDay;
    CalCalendar *eventCalendar;
    
    NSDate      *alarmAbsoluteTrigger;
    NSNumber    *alarmRelativeTrigger;
}

@property(copy)   NSString *eventTitle;
@property(copy)   NSString *eventNotes;
@property(copy)   NSString *eventUrl;
@property(copy)   NSNumber *eventAllDay;
@property(retain) CalCalendar *eventCalendar;

@property(retain) NSDate   *alarmAbsoluteTrigger;
@property(copy)   NSNumber *alarmRelativeTrigger;

+ (void)deleteEvent:(CalEvent *)event;
+ (NSArray *)eventsOnDate:(NSDate*)date;

- (void)createEventWithStart:(NSDate*)start end:(NSDate*)end;

@end
