//
//  CalController.m
//  pmEvent
//

#import "CalController.h"
#import "DateCategory.h"

@implementation CalController

@synthesize eventTitle, eventNotes, eventUrl;
@synthesize eventAllDay;
@synthesize eventCalendar;
@synthesize alarmAbsoluteTrigger, alarmRelativeTrigger;

#pragma mark -
#pragma mark init

- (id)init
{
    self = [super init];
    if (self != nil) {
        eventTitle      = @"";
        eventNotes      = @"";
        eventUrl        = @"";
        eventAllDay     = [NSNumber numberWithBool:NO];
    }
    return self;
}


#pragma mark -
#pragma mark public methodes

- (void)createEventWithStart:(NSDate*)startDate end:(NSDate*)endDate
{
    /* create and save new event */
    CalEvent *newEvent = [CalEvent event];

    if ([eventAllDay boolValue]) {
        newEvent.startDate = [startDate dateAtMidnight];
        newEvent.endDate   = [[endDate dateAtMidnight] dateByAddingOneDay];
    } else {
        newEvent.startDate  = startDate;
        newEvent.endDate    = endDate;
    }

   if ([newEvent.startDate compare:newEvent.endDate] == NSOrderedDescending) {
       NSAlert *alertPanel = [NSAlert alertWithMessageText:@"Invalid date range" defaultButton:nil
                                           alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
       [alertPanel setAlertStyle:NSCriticalAlertStyle];
       (void) [alertPanel runModal];
       return;
    }

    newEvent.title      = eventTitle;
    newEvent.notes      = eventNotes;
    newEvent.calendar   = eventCalendar;
    newEvent.isAllDay   = [eventAllDay boolValue];

    if (eventUrl != nil) {
        newEvent.url = [[[NSURL URLWithString:eventUrl]retain]autorelease];
    }

    /* remove default alarms */
    if ([newEvent hasAlarm]) {
        [newEvent removeAlarms:[newEvent alarms]];
    }

    if (alarmAbsoluteTrigger != nil) {
        CalAlarm *alarm = [CalAlarm alarm];
        alarm.absoluteTrigger = alarmAbsoluteTrigger;
        alarm.action = CalAlarmActionSound;
        alarm.sound = @"Basso";
        [newEvent addAlarm:alarm];
    }

    if (alarmRelativeTrigger != nil) {
        CalAlarm *alarm = [CalAlarm alarm];
        alarm.relativeTrigger = [alarmRelativeTrigger intValue];
        alarm.action = CalAlarmActionSound;
        alarm.sound = @"Basso";
        [newEvent addAlarm:alarm];
    }

    NSError *err;
    if ([[CalCalendarStore defaultCalendarStore] saveEvent:newEvent span:CalSpanThisEvent error:&err] != YES){
        NSAlert *alert = [NSAlert alertWithError:err];
        DLog(@"error:%@", [err localizedDescription]);
        (void) [alert runModal];
        return;
    }
}

+ (void)deleteEvent:(CalEvent *)evt
{
    NSError *err;
    if ([[CalCalendarStore defaultCalendarStore] removeEvent:evt span:CalSpanThisEvent error:&err] != YES) {
        NSAlert *alert = [NSAlert alertWithError:err];
        [alert runModal];
        DLog(@"error:%@", [err localizedDescription]);
        return;
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

+ (NSArray *)alarmStringsOfEvent:(CalEvent *)event
{
    NSMutableArray *alarmArray = [[[NSMutableArray alloc]initWithCapacity:3]autorelease];
    for(CalAlarm *alarm in [event alarms]) {
        NSString *str = @"";
        if ([alarm absoluteTrigger] != nil) {
            if ([event.startDate isEqualToDate:alarm.absoluteTrigger]) {
                str = @"on date";
            } else {
                str = [alarm.absoluteTrigger stringValue];
            }
        } else {
            int i = [alarm relativeTrigger];
            if (i != 0) {
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
        }
        [alarmArray addObject:str];
    }
    return [NSArray arrayWithArray:alarmArray];
}
@end
