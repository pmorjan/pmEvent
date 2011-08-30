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
+ (NSArray *)eventsWithUID:(NSString *)uid startDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSArray *)descriptionOfAlarmsOfEvent:(CalEvent *)evt;

@end
