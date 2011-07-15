//
//  AppController.m
//  pmEvent
//
//  TODO: make keyboard focus ring independ of user's preferences "Full Keyboard Access"
//
#import "AppController.h"
#import "CalMenu.h"
#import "AlarmMenu.h"
#import "PMDate.h"

@interface AppController (Private)
- (void)p_updateEventDates:(id)userInfo;
- (void)p_startTimerIfNeeded;
- (void)p_stopTimer;
- (void)p_statusItemClick:(id)sender;
- (void)p_eventsChanged:(NSNotification *)notification;
@end

#pragma mark -

@implementation AppController

@synthesize window;
@synthesize alarmMinutes;
@synthesize alarmFromNow;
@synthesize eventStartDate;
@synthesize eventEndDate;

static NSDate *alarmFromNowDefault;
static NSString *defaultEventTitle = @"Event";
static NSString *defaultAlarmTitle = @"Alarm";
static NSString *defaultEventUrl   = @"";
static NSUserDefaults *prefs = nil;

#pragma mark -
#pragma mark init

- (id) init
{
    self = [super init];
    if (self != nil) {
        cal = [[CalController alloc]init];
        alarmMinutes = [NSNumber numberWithInt:5];
        alarmFromNow = [alarmFromNowDefault retain];
        [cal setEventTitle:defaultEventTitle];
        [cal setEventUrl:defaultEventUrl];
		eventStartDate  = [[[PMDate dateZeroSeconds]dateByAddingTimeInterval:600]retain];
        eventEndDate    = [[eventStartDate dateByAddingTimeInterval:60]retain];
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
    alarmFromNowDefault = [[PMDate midnightOfDate:[NSDate distantPast]]dateByAddingTimeInterval:60*10];
    [alarmFromNowDefault retain];
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

    [popUpAlarm     setMenu:[AlarmMenu alarmMenuWithTitle:@"Alarm"]];
	[self addObserver:self forKeyPath:@"eventStartDate" options:NSKeyValueObservingOptionNew context:NULL];

    NSLocale * locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]autorelease];
    [datePickerAlarm setLocale:locale];

    [datePickerStart    setEnabled:YES];
    [datePickerStart2   setEnabled:YES];
    [datePickerEnd      setEnabled:YES];
    [datePickerAlarm    setEnabled:NO];
    [comboBoxAlarm      setEnabled:YES];
    [cbAllDayEvent      setEnabled:YES];
    [alarmMinutesField  setHidden:YES];

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
    [self p_startTimerIfNeeded];
    [window makeFirstResponder:textFieldTitle];
}

- (void)windowDidResignKey:(NSNotification *)aNotification
{
    [self p_stopTimer];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)createEvent:(id)sender
{
    [cal setEventCalendar:[[popUpCalendars selectedItem]representedObject]];

    NSNumber *obj = [[popUpAlarm selectedItem]representedObject];
    if (obj == nil) {
        // no alarm
        [cal setAlarmAbsoluteTrigger:nil];
        [cal setAlarmRelativeTrigger:nil];

    } else if ([obj intValue] == 0) {
        // on date
        [cal setAlarmRelativeTrigger:nil];
        [cal setAlarmAbsoluteTrigger:eventStartDate];
    } else {
        // before
        [cal setAlarmAbsoluteTrigger:nil];
        [cal setAlarmRelativeTrigger:[NSNumber numberWithInt:[alarmMinutes intValue] * [obj intValue]]];
    }
    [cal createEventWithStart:eventStartDate end:eventEndDate];
}

- (IBAction)deleteEvent:(id)sender
{
    CalEvent *calEvent = [[eventArrayController selectedObjects]objectAtIndex:0];
    [cal deleteEvent:calEvent];
}

- (IBAction)launchIcal:(id)sender {
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

- (IBAction)cbQuickAlarmChanged:(id)sender
{
    if ([cbQuickAlarm state] == NSOnState) {
        if ([[cal eventTitle] isEqualToString:defaultEventTitle]) {
            [cal setEventTitle:defaultAlarmTitle];
        }
        [datePickerStart    setEnabled:NO];
        [datePickerStart2   setEnabled:NO];
        [datePickerEnd      setEnabled:NO];
        [datePickerAlarm    setEnabled:YES];
        [comboBoxAlarm      setEnabled:NO];
        [cbAllDayEvent      setEnabled:NO];
        [popUpAlarm selectItemWithTitle:@"on date"];
        [self alarmPopUpMinutesChanged:nil];
        [self p_startTimerIfNeeded];
        [window makeFirstResponder:datePickerAlarm];
        [popUpCalendars     setNextKeyView:datePickerAlarm];
        [cal setEventAllDay:[NSNumber numberWithBool:NO]];

    } else {
        if ([[cal eventTitle] isEqualToString:defaultAlarmTitle]) {
            [cal setEventTitle:defaultEventTitle];
        }
        [datePickerStart    setEnabled:YES];
        [datePickerStart2   setEnabled:YES];
        [datePickerEnd      setEnabled:YES];
        [datePickerAlarm    setEnabled:NO];
        [comboBoxAlarm      setEnabled:YES];
        [cbAllDayEvent      setEnabled:YES];
        [window makeFirstResponder:datePickerStart];
        [popUpCalendars     setNextKeyView:datePickerStart];
        [self p_stopTimer];
        [self setEventStartDate:[PMDate dateZeroSecondsOfDate:self->eventStartDate]];
    }
    [self cbAllDayEventChanged:nil];
}

- (IBAction)cbAllDayEventChanged:(id)sender
{
    if ([cbAllDayEvent state] == NSOnState) {
		// no time part
        [datePickerStart setDatePickerElements:NSYearMonthDayDatePickerElementFlag];
        [datePickerEnd   setDatePickerElements:NSYearMonthDayDatePickerElementFlag];
    } else {
        [datePickerStart setDatePickerElements:NSYearMonthDayDatePickerElementFlag | NSHourMinuteSecondDatePickerElementFlag];
        [datePickerEnd   setDatePickerElements:NSYearMonthDayDatePickerElementFlag | NSHourMinuteSecondDatePickerElementFlag];
    }
}

- (IBAction)quit:(id)sender
{
    [NSApp terminate:sender];
}

#pragma mark -
#pragma mark Properties

- (void)setEventStartDate:(NSDate *)newDate {   

    if (eventStartDate != newDate) {                             		
            
        NSDate *oldEventStartDate = [eventStartDate copy];
		[eventStartDate release];                                      
		eventStartDate = [newDate retain];
        
        if ( ! [[PMDate midnightOfDate:newDate] isEqualToDate:[PMDate midnightOfDate:oldEventStartDate]] ){
			// this is a new day, need to update events
            [self p_eventsChanged:nil];
		}
		
		if ([cbAllDayEvent state] == NSOffState) {
			[self setEventEndDate:[eventStartDate dateByAddingTimeInterval:60*60]];
		}
        [oldEventStartDate release];
    }   
}


#pragma mark -
#pragma mark public methods

-(NSArray*) events {
	return [CalController eventsOnDate:eventStartDate];
}
	 
#pragma mark -
#pragma mark private methods


- (void) p_eventsChanged:(NSNotification *)notification
{
    [self willChangeValueForKey:@"events"];
    [self didChangeValueForKey:@"events"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void*)context
{
	// nothing to observe for now
}

- (void)p_updateEventDates:(id)userInfo
{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar]
                                        components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                        fromDate:alarmFromNow];

    [self setEventStartDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0]];
}

- (void)p_startTimerIfNeeded
{
    if ([cbQuickAlarm state] == NSOnState) {
        DLog(@"starting alarmTimer");
        if (uptimeTimer == nil) {
            uptimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self selector:@selector(p_updateEventDates:)
                                                         userInfo:nil repeats:YES];
            [uptimeTimer retain];
        }
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
    [cal dealloc];
    [super dealloc];
}

@end
