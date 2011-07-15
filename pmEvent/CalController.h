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

@property(readwrite, copy)   NSString *eventTitle;
@property(readwrite, copy)   NSString *eventNotes;
@property(readwrite, copy)   NSString *eventUrl;
@property(readwrite, copy)   NSNumber *eventAllDay;
@property(readwrite, retain) CalCalendar *eventCalendar;

@property(readwrite, retain) NSDate   *alarmAbsoluteTrigger;
@property(readwrite, copy)   NSNumber *alarmRelativeTrigger;

- (void)deleteEvent:(CalEvent *)event;
- (void)createEventWithStart:(NSDate*)start end:(NSDate*)end;
+ (NSArray *)eventsOnDate:(NSDate*)date;

@end
