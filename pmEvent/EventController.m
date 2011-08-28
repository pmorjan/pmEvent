//
//  EventController.m
//  pmEvent
//

#import "EventController.h"
#import "AlarmMenu.h"
#import "DateCategory.h"

@implementation EventController

@synthesize model;
@synthesize eventStartDate;
@synthesize eventEndDate;
@synthesize alarmMinutes;
@synthesize shouldUpdateEventEndTime;

#pragma mark -
#pragma mark init

- (id)init
{
    self = [super init];
    if (self != nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsChanged:) name:CalEventsChangedExternallyNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsChanged:) name:CalEventsChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsChanged:) name:CalCalendarsChangedExternallyNotification object:nil];
        alarmMinutes    = [[NSNumber numberWithInt:5]retain];
		eventStartDate  = [[[[NSDate date]dateZeroSeconds]dateByAddingTimeInterval:60*10]retain];
        eventEndDate    = [eventStartDate copy];
        shouldUpdateEventEndTime = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    [popUpButtonAlarm setMenu:[AlarmMenu alarmMenuWithTitle:@""]];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)createEvent:(id)sender
{
    CalEvent *evt = [CalEvent event];

    BOOL isAllDayEvent = [buttonAllDayEvent state] == NSOnState ? YES : NO;    
    if (isAllDayEvent) {
        evt.startDate = [eventStartDate dateAtMidnight];
        evt.endDate   = [[eventEndDate dateAtMidnight] dateByAddingOneDay];
    } else {
        evt.startDate  = eventStartDate;
        evt.endDate    = eventEndDate;
    }
    evt.isAllDay = isAllDayEvent;
    evt.calendar = model.calendar;
    evt.title    = model.eventTitle == nil ? @"Event" : model.eventTitle;
    evt.notes    = model.eventNotes;
    if (model.eventUrl != nil) {
        evt.url = [[[NSURL URLWithString:model.eventUrl]retain]autorelease];
    }

    if ([evt hasAlarm]) {
        [evt removeAlarms:[evt alarms]];
    }

    NSNumber *obj = [[popUpButtonAlarm selectedItem]representedObject];
    if (obj == nil) {
        // no alarm
    } else if ([obj intValue] == 0) {
        // on date
        CalAlarm *alarm = [CalAlarm alarm];
        alarm.absoluteTrigger = eventStartDate;
        alarm.action = CalAlarmActionSound;
        alarm.sound = @"Basso";
        [evt addAlarm:alarm];
    } else {
        // before
        CalAlarm *alarm = [CalAlarm alarm];
        alarm.relativeTrigger = (float)([alarmMinutes intValue] * [obj intValue]);
        alarm.action = CalAlarmActionSound;
        alarm.sound = @"Basso";
        [evt addAlarm:alarm];
    }
    
    [CalendarEvent addEvent:evt];
    model.eventTitle = nil;
    model.eventNotes = nil;
    model.eventUrl   = nil;
}

- (IBAction)alarmPopUpMinutesChanged:(id)sender
{
    NSNumber *obj = [[popUpButtonAlarm selectedItem]representedObject];
    if (obj == nil || [obj intValue] == 0) {
        // no alarm || on date
        [alarmMinutesField setHidden:YES];
    } else {
        // before
        [alarmMinutesField setHidden:NO];
        [alarmMinutesField selectText:sender];
    }
}

- (IBAction)cbAllDayEvent:(id)sender
{
    if ([buttonAllDayEvent state] == NSOnState) {
		// no time part
        [datePickerEventStart setDatePickerElements:NSYearMonthDayDatePickerElementFlag];
        [datePickerEventEnd   setDatePickerElements:NSYearMonthDayDatePickerElementFlag];
    } else {
        [datePickerEventStart setDatePickerElements:NSYearMonthDayDatePickerElementFlag | NSHourMinuteSecondDatePickerElementFlag];
        [datePickerEventEnd   setDatePickerElements:NSYearMonthDayDatePickerElementFlag | NSHourMinuteSecondDatePickerElementFlag];
    }
}

- (IBAction)eventEndTimeChanged:(id)sender
{
    shouldUpdateEventEndTime = NO;
}

- (IBAction)deleteEvent:(id)sender
{
    CalEvent *evt = [[eventArrayController selectedObjects]objectAtIndex:0];

    // need to check if the event covers multiple days
    NSInteger pastDays = [evt.endDate pastDaysSinceDate:evt.startDate];
    if ([evt.endDate isEqualToDate:[evt.endDate dateAtMidnight]]) {
        //  end day that ends at midnight does not count
        pastDays--;
    }
    if (pastDays > 0) {
        // Event covers multiple days
        NSAlert *alert = [[NSAlert alloc]init];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert addButtonWithTitle:@"Delete"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:[NSString stringWithFormat:@"This event covers %ld days.",pastDays +1]];
        NSInteger i = [alert runModal];
        [alert release];
        if (i != NSAlertFirstButtonReturn)
            return;
    }

    /*
        ToDo: How to check for multiple occurrences ?
        // Event has multiple occurrences
    */
    
    NSUndoManager *undoManager = [[sender window] undoManager];
    [undoManager registerUndoWithTarget:[CalendarEvent class]
                        selector:@selector(addEvent:)
                          object:evt];
    [undoManager setActionName:@"Remove Event"];
    
    [CalendarEvent deleteEvent:evt];

    if ([[eventArrayController arrangedObjects]count] < 1) {
        [[sender window] makeFirstResponder:[[sender window] initialFirstResponder]];
    }
}

- (IBAction)launchIcal:(id)sender
{    
    if ([eventArrayController selectedObjects].count > 0) {
        CalEvent *calEvent = [[eventArrayController selectedObjects]objectAtIndex:0];
        
        NSString *source = [NSString stringWithFormat:@"tell application \"iCal\" \n activate\n" 
                        "tell calendar \"%@\" \n set MyEvent to first event whose uid=\"%@\" \n end tell\n"
                        "if MyEvent is not null then \n show MyEvent\n end if\n"
                        "end tell", calEvent.calendar.title, calEvent.uid];

        NSDictionary *errorInfo = [NSDictionary dictionary];
        NSAppleScript *script = [[NSAppleScript alloc] initWithSource:source];
        [script executeAndReturnError:&errorInfo];
        // TODO: error handling, all day events

    } else {
        NSWorkspace *ws = [[[NSWorkspace alloc]init]autorelease];
        [ws launchApplication:@"iCal"];
    }
}

#pragma mark -

- (void)eventsChanged:(NSNotification *)notification
{
    [self willChangeValueForKey:@"events"];
    [self didChangeValueForKey:@"events"];
}

- (NSArray*)events
{
	return [CalendarEvent eventsOnDate:eventStartDate];
}

- (NSDate *)currentDate
{
    return [NSDate date];
}

#pragma mark -
#pragma mark Properties

- (NSDate *)eventStartDate
{
    return [[eventStartDate retain] autorelease];
}

- (void)setEventStartDate:(NSDate *)newDate
{
    if (eventStartDate != newDate) {

        NSDate *oldStartDate = [eventStartDate copy];
		[eventStartDate release];
        eventStartDate = nil;
		eventStartDate = [newDate retain];

        if ( ! [[newDate dateAtMidnight] isEqualToDate:[oldStartDate dateAtMidnight]] ){
			// this is a new day, need to update events
            [self eventsChanged:nil];
		}

		if (shouldUpdateEventEndTime && [buttonAllDayEvent state] == NSOffState) {
			self.eventEndDate = [eventStartDate dateByAddingTimeInterval:60*60];
		}
        [oldStartDate release];
    }
}

#pragma mark -

- (void)dealloc
{
    [alarmMinutes release];
    [eventStartDate release];
    [eventEndDate release];
    [super dealloc];
}

@end
