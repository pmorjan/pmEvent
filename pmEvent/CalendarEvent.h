//
//  CalendarEvent.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>
#import <CalendarStore/CalendarStore.h>

@interface CalendarEvent : NSObject {
}
+ (void)addEvent:(CalEvent *)evt;
+ (void)deleteEvent:(CalEvent *)evt;
+ (NSArray *)eventsOnDate:(NSDate*)date;
+ (NSArray *)descriptionOfAlarmsOfEvent:(CalEvent *)evt;

@end
