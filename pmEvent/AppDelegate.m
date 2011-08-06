//
//  AppDelegate.m
//  pmEvent
//

#import "AppDelegate.h"
#import "CalMenu.h"
#import "AlarmMenu.h"

@implementation AppDelegate

static NSUserDefaults *prefs;

@interface AppDelegate (Private)
- (void)p_statusItemClick:(id)sender;
@end

@synthesize window;

- (id)init
{
    self = [super init];
    if (self != nil) {
        model = [[Model alloc]init];
    }
    return self;
}

+ (void)initialize
{
    if (self != [AppDelegate class])
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
    [popUpButtonCalendars setMenu:[CalMenu calMenuWithTitle:@"Calendars"]];
    NSString *calMenuTitle = [prefs valueForKey:@"calMenuTitle"];
    if (calMenuTitle != nil) {
        if ([popUpButtonCalendars itemWithTitle:calMenuTitle] != nil) {
            [popUpButtonCalendars selectItemWithTitle:calMenuTitle];
        }
    }
    [self calendarChanged:nil];

    [NSApp activateIgnoringOtherApps:YES];
    [window makeKeyAndOrderFront:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    eventController.model = model;
    alarmController.model = model;
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
    [prefs setObject:model.calendar.title forKey:@"calMenuTitle"];
    [prefs synchronize];
}

#pragma mark -
#pragma mark IBActions
- (IBAction)calendarChanged:(id)sender
{
    model.calendar = [[popUpButtonCalendars selectedItem]representedObject];
}

- (IBAction)launchIcal:(id)sender
{
    NSWorkspace *ws = [[[NSWorkspace alloc]init]autorelease];
    [ws launchApplication:@"iCal"];
}

- (IBAction)quit:(id)sender
{
    [NSApp terminate:sender];
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

-(void) dealloc
{
    [model release];
    [super dealloc];
}

@end
