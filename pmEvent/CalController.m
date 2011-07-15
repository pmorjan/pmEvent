//
//  CalController.m
//  pmEvent
//

#import "CalController.h"
#import "PMDate.h"

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
        newEvent.startDate = [PMDate midnightOfDate:startDate];
        newEvent.endDate   = [PMDate midnightOfDate:[endDate dateByAddingTimeInterval:24*3600]];
    } else {
        newEvent.startDate  = startDate;
        newEvent.endDate    = endDate;
    }

   if (    [newEvent.startDate compare:newEvent.endDate] == NSOrderedSame
        || [newEvent.startDate compare:newEvent.endDate] == NSOrderedDescending) {
       NSAlert *alertPanel = [NSAlert alertWithMessageText:@"Invalid date range" defaultButton:nil
                                           alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
       [alertPanel setAlertStyle:NSCriticalAlertStyle];
       (void) [alertPanel runModal];
       return;
    }

    newEvent.title      = eventTitle;
    newEvent.notes      = eventNotes;
    newEvent.url        = [[[NSURL URLWithString:eventUrl]retain]autorelease];
    newEvent.calendar   = eventCalendar;
    newEvent.isAllDay   = [eventAllDay boolValue];

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
        NSAlert *alertPanel = [NSAlert alertWithError:err];
        (void) [alertPanel runModal];
        DLog(@"error:%@", [err localizedDescription]);
        return;
    }
}

-(void)deleteEvent:(CalEvent *)evt
{
    NSError *err;
    if ([[CalCalendarStore defaultCalendarStore] removeEvent:evt span:CalSpanThisEvent error:&err] != YES) {
        NSAlert *alertPanel = [NSAlert alertWithError:err];
        (void) [alertPanel runModal];
        DLog(@"error:%@", [err localizedDescription]);
        return;
    }
}

+ (NSArray *)eventsOnDate:(NSDate*)date
{
	
    NSDate *eventStartMidnight = [PMDate midnightOfDate:date];
    NSDateComponents *oneDay = [[[NSDateComponents alloc] init]autorelease]; 
    [oneDay setDay:1]; 
    NSDate *eventStartMidnightPlus1d = [[NSCalendar currentCalendar] dateByAddingComponents:oneDay toDate:eventStartMidnight options:0];
    
	CalCalendarStore *store = [CalCalendarStore defaultCalendarStore];
	NSPredicate *eventsPredicate = [CalCalendarStore eventPredicateWithStartDate:eventStartMidnight
                                                                         endDate:eventStartMidnightPlus1d
                                                                       calendars:[store calendars]];
    return [NSArray arrayWithArray:[store eventsWithPredicate:eventsPredicate]];
}

#pragma mark dealloc

- (void)dealloc
{
    [alarmAbsoluteTrigger release];
    [eventCalendar release];
    [super dealloc];
}

@end