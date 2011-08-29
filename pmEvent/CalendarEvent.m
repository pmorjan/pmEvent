//
//  CalendarEvent.m
//  pmEvent
//

#import "CalendarEvent.h"
#import "DateCategory.h"

@implementation CalendarEvent

+ (void)saveEvent:(CalEvent *)evt span:(CalSpan)span
{
    NSError *err;
    if ([[CalCalendarStore defaultCalendarStore] saveEvent:evt span:span error:&err] != YES) {
        NSAlert *alert = [NSAlert alertWithError:err];
        [alert runModal];
    }
}

+ (void)removeEvent:(CalEvent *)evt span:(CalSpan)span
{
    NSError *err;
    if ([[CalCalendarStore defaultCalendarStore] removeEvent:evt span:span error:&err] != YES) {
        NSAlert *alert = [NSAlert alertWithError:err];
        [alert runModal];
    }
}

+ (NSArray *)eventsOnDate:(NSDate*)date
{
    NSDate *eventStart = [date dateAtMidnight];
    NSDate *eventEnd   = [eventStart dateByAddingOneDay];
	CalCalendarStore *store = [CalCalendarStore defaultCalendarStore];
	NSPredicate *eventsPredicate = [CalCalendarStore eventPredicateWithStartDate:eventStart
                                                                         endDate:eventEnd
                                                                       calendars:[store calendars]];
    NSArray *array = [NSArray arrayWithArray:[store eventsWithPredicate:eventsPredicate]];
    return array;
}

+ (NSArray *)futureEventsWithUID:(NSString *)uid date:(NSDate *)date
{
    CalCalendarStore *store = [CalCalendarStore defaultCalendarStore];
	NSPredicate *eventsPredicate = [CalCalendarStore eventPredicateWithStartDate:date
                                                                         endDate:[NSDate distantFuture]
                                                                             UID:uid
                                                                       calendars:[store calendars]];
    NSArray *array = [NSArray arrayWithArray:[store eventsWithPredicate:eventsPredicate]];
    return array;    
}

+ (NSArray *)pastEventsWithUID:(NSString *)uid date:(NSDate *)date
{
    CalCalendarStore *store = [CalCalendarStore defaultCalendarStore];
	NSPredicate *eventsPredicate = [CalCalendarStore eventPredicateWithStartDate:[date dateFourYearsAgo]
                                                                         endDate:date
                                                                             UID:uid
                                                                       calendars:[store calendars]];
    NSArray *array = [NSArray arrayWithArray:[store eventsWithPredicate:eventsPredicate]];
    return array;    
}

+ (NSArray *)descriptionOfAlarmsOfEvent:(CalEvent *)evt
{
    NSMutableArray *alarmArray = [[[NSMutableArray alloc]initWithCapacity:3]autorelease];
    for(CalAlarm *alarm in [evt alarms]) {
      
        NSString *str = @"";
        if ([alarm absoluteTrigger] != nil) {
            // absolute alarm
            if ([evt.startDate isEqualToDate:alarm.absoluteTrigger]) {
                str = @"on date";
            } else {
                str = [alarm.absoluteTrigger descriptionISO];
            }
        } else if (alarm.relativeTrigger != 0.0) {
            // relative alarm
            int i = alarm.relativeTrigger;
            NSString *beforeAfter = i > 0 ? @"after" : @"before";
            int m = (int)abs(i/60.0);
            if (m < 240) {
                str = [NSString stringWithFormat:@"%d minutes %@", m, beforeAfter];
            } else if (m < 60 * 24) {
                str = [NSString stringWithFormat:@"%.0f hours %@", round(m/60.0), beforeAfter];                    
            } else {
                str = [NSString stringWithFormat:@"%.0f days %@", round(m/(60*24.0)), beforeAfter];                    
            } 
        } 
        
        // append action
        if ([alarm.action isEqualToString:CalAlarmActionDisplay]) {
            str = [str stringByAppendingString:@": Display Message"];
        } else if ([alarm.action isEqualTo:CalAlarmActionEmail]) {
            str = [str stringByAppendingString:@": Send Email"];
        } else if ([alarm.action isEqualTo:CalAlarmActionProcedure]) {
            NSString *script = [[alarm.url lastPathComponent]stringByDeletingPathExtension];
            str = [NSString stringWithFormat:@"%@: %@", str, script];
        } else if ([alarm.action isEqualTo:CalAlarmActionSound]) {
            str = [str stringByAppendingString:@": Play Sound"];
        }    
        
        [alarmArray addObject:str];
    }
    return [NSArray arrayWithArray:alarmArray];
}
@end
