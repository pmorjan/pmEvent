//
//  AlarmController.m
//  pmEvent
//

#import "AlarmController.h"
#import "CalendarMenu.h"
#import "DateCategory.h"

@interface AlarmController ()
- (void)p_updateAlarmDate:(id)userInfo;
- (void)p_startTimer;
- (void)p_stopTimer;
@end

@implementation AlarmController

@synthesize alarmFromNow;
@synthesize alarmDate;
@synthesize model;

#pragma mark -
#pragma mark init

- (id)init
{
    self = [super init];
    if (self != nil) {
        alarmFromNow    = [[[[NSDate distantPast]dateAtMidnight]dateByAddingTimeInterval:60*10]retain];
        alarmDate       = [[NSDate date]retain];
    }
    return self;
}

- (void)awakeFromNib
{
    [self p_startTimer];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)createAlarm:(id)sender
{
    CalendarEvent *evt = [[CalendarEvent alloc]init];
    evt.eventCalendar = model.calendar;
    evt.eventTitle    = model.eventTitle == nil ? @"Alarm" : model.eventTitle;
    evt.eventNotes    = model.eventNotes;
    evt.eventUrl      = model.eventUrl;
    evt.alarmAbsoluteTrigger = alarmDate;
    [evt createEventWithStart:alarmDate end:alarmDate];
    [evt release];
}

#pragma mark -
#pragma mark private methods

- (void) p_eventsChanged:(NSNotification *)notification
{
    [self willChangeValueForKey:@"events"];
    [self didChangeValueForKey:@"events"];
}

- (void)p_updateAlarmDate:(id)userInfo
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar]
                                        components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                        fromDate:self.alarmFromNow];
    self.alarmDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
}

- (void)p_startTimer
{
    if (uptimeTimer == nil) {
        DLog(@"starting alarmTimer");
        uptimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(p_updateAlarmDate:)
                                                     userInfo:nil repeats:YES];
        [uptimeTimer retain];
    }
}

- (void)p_stopTimer
{
    if (uptimeTimer) {
        DLog(@"stopping alarmTimer");
        [uptimeTimer invalidate];
        [uptimeTimer release];
        uptimeTimer = nil;
    }
}

#pragma mark -
- (void) dealloc
{
    [alarmFromNow release];
    [alarmDate release];
    [super dealloc];
}

@end
