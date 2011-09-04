//
//  EventController.m
//  pmEvent
//

#import "EventController.h"
#import "AlarmMenu.h"
#import "DateCategory.h"
#import "CalendarEvent.h"
#import "CustomSheet.h"

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
    if ([eventEndDate compare:[NSDate date]] == NSOrderedAscending) {
        CustomSheet *sheet = [CustomSheet sheetWithTitle:@"Event start date is in the past"
                                         informativeText:@"Do you really want to create this event?" 
                                           defaultButton:@"Create" 
                                         alternateButton:@"Cancel"];
        if ([sheet runModalForWindow:[sender window]] != CSDefaultReturn) {
            return;
        }
    }
    
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
    
    [CalendarEvent saveEvent:evt span:CalSpanThisEvent];
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
            NSDictionary *d = [NSDictionary dictionaryWithObject:eventStartDate forKey:@"startDate"];
            [[NSNotificationCenter defaultCenter]postNotificationName:PMDateChangedNotification object:self userInfo:d];
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
