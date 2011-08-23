//
//  AlarmController.m
//  pmEvent
//

#import "AlarmController.h"
#import "ScriptMenu.h"
#import "DateCategory.h"

@interface AlarmController ()
- (void)updateAlarmDate:(id)userInfo;
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
    if (uptimeTimer == nil) {
        uptimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateAlarmDate:)
                                                     userInfo:nil repeats:YES];
        [uptimeTimer retain];
    }
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
    
    [popUpButtonScripts selectItemAtIndex:0];
    
    NSError *err;
    if ([[CalCalendarStore defaultCalendarStore] saveEvent:evt span:CalSpanThisEvent error:&err] != YES) {
        NSAlert *alert = [NSAlert alertWithError:err];
        (void) [alert runModal];
        return;
    }
    model.eventTitle = nil;
    model.eventNotes = nil;
    model.eventUrl   = nil;
}

#pragma mark -
#pragma mark private methods

- (void) eventsChanged:(NSNotification *)notification
{
    [self willChangeValueForKey:@"events"];
    [self didChangeValueForKey:@"events"];
}

- (void)updateAlarmDate:(id)userInfo
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar]
                                        components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                        fromDate:self.alarmFromNow];
    self.alarmDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
}

#pragma mark -
- (void) dealloc
{
    [uptimeTimer invalidate];
    [uptimeTimer release];
    [alarmFromNow release];
    [alarmDate release];
    [super dealloc];
}

@end
