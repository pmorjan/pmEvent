//
//  AppController.m
//  pmEvent
//
//  TODO: make keyboard focus ring independ of user's preferences "Full Keyboard Access"
//
#import "AppController.h"
#import "CalMenu.h"
#import "AlarmMenu.h"
#import "DateCategory.h"

@interface AppController (Private)
- (void)p_updateAlarmDates:(id)userInfo;
- (void)p_startTimer;
- (void)p_stopTimer;
- (void)p_statusItemClick:(id)sender;
- (void)p_eventsChanged:(NSNotification *)notification;
@end

#pragma mark -

@implementation AppController

@synthesize window;
@synthesize alarmMinutes;
@synthesize alarmFromNow;
@synthesize eventEndDate;
@synthesize alarmDate;
@synthesize eventTitle, eventNotes, eventUrl;

static NSUserDefaults *prefs = nil;

#pragma mark -
#pragma mark init

- (id)init
{
    self = [super init];
    if (self != nil) {
        alarmMinutes = [[NSNumber numberWithInt:5]retain];
#ifdef DEBUG
        eventNotes = @"### Debug Mode ###";
#endif
        alarmFromNow    = [[[[NSDate distantPast]dateAtMidnight]dateByAddingTimeInterval:60*10]retain];
		eventStartDate  = [[[[NSDate date]dateZeroSeconds]dateByAddingTimeInterval:60*10]retain];
        eventEndDate    = [[eventStartDate dateByAddingTimeInterval:60*60]retain];
        alarmDate       = [[NSDate date]retain];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_eventsChanged:) name:CalEventsChangedExternallyNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_eventsChanged:) name:CalEventsChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_eventsChanged:) name:CalCalendarsChangedExternallyNotification object:nil];

    }
    return self;
}

+ (void)initialize
{
    if (self != [AppController class])
        return;
    
    prefs = [NSUserDefaults standardUserDefaults];
}

- (void)awakeFromNib
{
    statusItem = [[[NSStatusBar systemStatusBar]statusItemWithLength:-1]retain];
    [statusItem setImage:[NSImage imageNamed:@"ical.png"]];
    [statusItem setTarget:self];
    [statusItem setAction:@selector(p_statusItemClick:)];
    [statusItem setHighlightMode:YES];

    // popUpCalendars
    // item in preferences might be no longer available
    [popUpCalendars setMenu:[CalMenu calMenuWithTitle:@"Calendars"]];
    NSString *calMenuTitle = [prefs valueForKey:@"calMenuTitle"];
    if (calMenuTitle != nil) {
        if ([popUpCalendars itemWithTitle:calMenuTitle] != nil) {
            [popUpCalendars selectItemWithTitle:calMenuTitle];
        }
    }
    [popUpAlarm setMenu:[AlarmMenu alarmMenuWithTitle:@""]];

    [window makeFirstResponder:datePickerAlarmInput];        
    [NSApp activateIgnoringOtherApps:YES];
    [window makeKeyAndOrderFront:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
#ifdef DEBUG
	return YES;
#endif
	return NO;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [prefs setObject:[[popUpCalendars selectedItem]title] forKey:@"calMenuTitle"];
    [prefs synchronize];
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification
{
    [self p_startTimer];
    updateEventEndTime = YES;
    [window makeFirstResponder:datePickerAlarmInput];        
}

- (void)windowDidResignKey:(NSNotification *)aNotification
{
    [self p_stopTimer];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)createEvent:(id)sender
{
    CalController *cal = [[CalController alloc]init];
    cal.eventCalendar = [[popUpCalendars selectedItem]representedObject];
    cal.eventTitle    = eventTitle == nil ? @"NoTitle" : eventTitle;
    cal.eventNotes    = eventNotes;
    cal.eventUrl      = eventUrl;
    
    NSNumber *obj = [[popUpAlarm selectedItem]representedObject];
    if (obj == nil) {
        // no alarm
    } else if ([obj intValue] == 0) {
        // on date
        cal.alarmAbsoluteTrigger = eventStartDate;
    } else {
        // before
        cal.alarmRelativeTrigger = [NSNumber numberWithInt:[alarmMinutes intValue] * [obj intValue]];
    }
    [cal createEventWithStart:eventStartDate end:eventEndDate];
    [cal release];
}

- (IBAction)createAlarm:(id)sender
{
    CalController *cal = [[CalController alloc]init];
    cal.eventCalendar = [[popUpCalendars selectedItem]representedObject];
    cal.eventTitle    = eventTitle == nil ? @"NoTitle" : self.eventTitle;
    cal.eventNotes    = eventNotes;
    cal.eventUrl      = eventUrl;
    cal.alarmAbsoluteTrigger = alarmDate;
    [cal createEventWithStart:alarmDate end:alarmDate];
    [cal release];
}

- (IBAction)deleteEvent:(id)sender
{
    CalEvent *calEvent = [[eventArrayController selectedObjects]objectAtIndex:0];
    [CalController deleteEvent:calEvent];
}

- (IBAction)launchIcal:(id)sender 
{
    NSWorkspace *ws = [[[NSWorkspace alloc]init]autorelease];
    [ws launchApplication:@"iCal"];
}

- (IBAction)alarmPopUpMinutesChanged:(id)sender
{
    NSNumber *obj = [[popUpAlarm selectedItem]representedObject];
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
    if ([cbAllDayEvent state] == NSOnState) {
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
    updateEventEndTime = NO;
}

- (IBAction)quit:(id)sender
{
    [NSApp terminate:sender];
}

#pragma mark -
#pragma mark Properties

- (NSDate *)currentDate 
{
    return [NSDate date];
}

- (NSDate *)eventStartDate 
{
    return [[eventStartDate retain] autorelease];
}

- (void)setEventStartDate:(NSDate *)newDate 
{

    if (eventStartDate != newDate) {                             		
            
        NSDate *oldStartDate = [eventStartDate copy];
		[eventStartDate release];                                      
		eventStartDate = [newDate retain];
        
        if ( ! [[newDate dateAtMidnight] isEqualToDate:[oldStartDate dateAtMidnight]] ){
			// this is a new day, need to update events
            [self p_eventsChanged:nil];
		}
		
		if (updateEventEndTime && [cbAllDayEvent state] == NSOffState) {
			[self setEventEndDate:[eventStartDate dateByAddingTimeInterval:60*60]];
		}
        [oldStartDate release];
    }   
}

#pragma mark -
#pragma mark public methods

- (NSArray*) events {
	return [CalController eventsOnDate:eventStartDate];
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
                                        fromDate:alarmFromNow];
    [self setAlarmDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0]];
}

- (void)p_startTimer
{
    if (uptimeTimer == nil) {
        DLog(@"starting alarmTimer");
        uptimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self 
                                                     selector:@selector(p_updateAlarmDate:)
                                                     userInfo:nil 
                                                      repeats:YES];
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

- (void)p_statusItemClick:(id)sender
{
    if ([window isVisible]) {
        if ([(NSWindow *)window isKeyWindow]) {
            [window performClose:self];
        } else {
            [NSApp activateIgnoringOtherApps:YES];
        }
    } else {
        [NSApp activateIgnoringOtherApps:YES];
        [window makeKeyAndOrderFront:self];
    }
}

#pragma mark -
- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
