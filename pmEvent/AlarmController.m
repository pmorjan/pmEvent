//
//  AlarmController.m
//  pmEvent
//

#import "AlarmController.h"
#import "ScriptMenu.h"
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
    [popUpButtonScripts setMenu:[ScriptMenu scriptMenuWithTitle:@""]];
    [self p_startTimer];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)createAlarm:(id)sender
{
    CalEvent *evt = [CalEvent event];
    evt.startDate = alarmDate;
    evt.endDate   = alarmDate;
    evt.calendar  = model.calendar;
    evt.title     = model.eventTitle == nil ? @"Alarm" : model.eventTitle;
    evt.notes     = model.eventNotes;
    if (model.eventUrl != nil) {
        evt.url = [[[NSURL URLWithString:model.eventUrl]retain]autorelease];
    }
    
    if ([evt hasAlarm]) {
        [evt removeAlarms:[evt alarms]];
    }

    // always add alarm
    CalAlarm *alarm = [CalAlarm alarm];
    alarm.absoluteTrigger = alarmDate;
    
    NSURL *url = [[popUpButtonScripts selectedItem]representedObject];    
    if (url == nil) {
        alarm.action = CalAlarmActionSound;
        alarm.sound = @"Basso";
    } else {
        alarm.action = CalAlarmActionProcedure;
        alarm.url    = url;
    }

    [evt addAlarm:alarm];
    
    NSError *err;
    if ([[CalCalendarStore defaultCalendarStore] saveEvent:evt span:CalSpanThisEvent error:&err] != YES) {
        NSAlert *alert = [NSAlert alertWithError:err];
        (void) [alert runModal];
        return;
    }
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
        uptimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(p_updateAlarmDate:)
                                                     userInfo:nil repeats:YES];
        [uptimeTimer retain];
    }
}

- (void)p_stopTimer
{
    if (uptimeTimer) {
        [uptimeTimer invalidate];
        [uptimeTimer release];
        uptimeTimer = nil;
    }
}

- (void)reboot 
{
/*    NSDictionary *error = [NSDictionary dictionary];
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:@"tell application \"System Events\" to restart"];
    [script executeAndReturnError:&error];
 */ 
    

}

#pragma mark -
- (void) dealloc
{
    [alarmFromNow release];
    [alarmDate release];
    [super dealloc];
}

@end
