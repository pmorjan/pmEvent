//
//  EventController.m
//  pmEvent
//

#import "EventController.h"
#import "AlarmMenu.h"
#import "DateCategory.h"

@implementation EventController

@synthesize alarmMinutes;
@synthesize eventEndDate;
@synthesize eventStartDate;
@synthesize model;

#pragma mark -
#pragma mark init

- (id)init
{
    self = [super init];
    if (self != nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_eventsChanged:) name:CalEventsChangedExternallyNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_eventsChanged:) name:CalEventsChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_eventsChanged:) name:CalCalendarsChangedExternallyNotification object:nil];
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
    CalendarEvent *evt = [[CalendarEvent alloc]init];
    evt.eventCalendar = model.calendar;
    evt.eventTitle    = model.eventTitle == nil ? @"Event" : model.eventTitle;
    evt.eventNotes    = model.eventNotes;
    evt.eventUrl      = model.eventUrl;
    evt.eventAllDay   = [NSNumber numberWithBool:[buttonAllDayEvent state] == NSOnState ? YES : NO];

    NSNumber *obj = [[popUpButtonAlarm selectedItem]representedObject];
    if (obj == nil) {
        // no alarm
    } else if ([obj intValue] == 0) {
        // on date
        evt.alarmAbsoluteTrigger = eventStartDate;
    } else {
        // before
        evt.alarmRelativeTrigger = [NSNumber numberWithInt:[alarmMinutes intValue] * [obj intValue]];
    }
    [evt createEventWithStart:eventStartDate end:eventEndDate];
    [evt release];
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
    CalEvent *calEvent = [[eventArrayController selectedObjects]objectAtIndex:0];

    // need to check if the event covers multiple days
    NSInteger pastDays = [calEvent.endDate pastDaysSinceDate:calEvent.startDate];
    if ([calEvent.endDate isEqualToDate:[calEvent.endDate dateAtMidnight]]) {
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
        [alert setInformativeText:@"You can't undo this deletion."];
        NSInteger i = [alert runModal];
        [alert release];
        if (i != NSAlertFirstButtonReturn)
            return;
    }

    [CalendarEvent deleteEvent:calEvent];
}

#pragma mark -

- (void) p_eventsChanged:(NSNotification *)notification
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
            [self p_eventsChanged:nil];
		}

		if (shouldUpdateEventEndTime && [buttonAllDayEvent state] == NSOffState) {
			self.eventEndDate = [eventStartDate dateByAddingTimeInterval:60*60];
		}
        [oldStartDate release];
    }
}

#pragma mark -

- (void) dealloc
{
    [alarmMinutes release];
    [eventStartDate release];
    [eventEndDate release];
    [super dealloc];
}

@end
