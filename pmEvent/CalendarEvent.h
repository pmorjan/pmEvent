//
//  CalendarEvent.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>
#import <CalendarStore/CalendarStore.h>

@interface CalendarEvent : NSObject {
}
+ (void)saveEvent:(CalEvent *)evt span:(CalSpan)span;
+ (void)removeEvent:(CalEvent *)evt span:(CalSpan)span;
+ (NSArray *)eventsOnDate:(NSDate*)date;
+ (NSArray *)futureEventsWithUID:(NSString *)uid date:(NSDate *)date;
+ (NSArray *)pastEventsWithUID:(NSString *)uid date:(NSDate *)date;
+ (NSArray *)descriptionOfAlarmsOfEvent:(CalEvent *)evt;

@end
