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
- (void)p_setEventBoxHidden:(BOOL)hide;
@end

@synthesize window;


+ (void)initialize
{
    if (self != [AppDelegate class])
        return;

    prefs = [NSUserDefaults standardUserDefaults];
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        model = [[Model alloc]init];
    }
    return self;
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

    [self p_setEventBoxHidden:[prefs boolForKey:@"hideEventBox"]];
    
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
    [prefs setBool:[eventBox isHidden] forKey:@"hideEventBox"];
    [prefs synchronize];
}

- (void)p_setEventBoxHidden:(BOOL)hide
{
    if (eventBox.isHidden == hide)
        return;
    
    NSSize boxSize = [eventBox frame].size;
    NSRect windowRect = [window frame];
    
    if (hide) {
        [eventBox setHidden:YES];
        windowRect.size.height -= boxSize.height;
        windowRect.origin.y    += boxSize.height;
        [window setFrame:windowRect display:YES animate:YES];        
    } else {
        windowRect.size.height += boxSize.height;
        windowRect.origin.y    -= boxSize.height;
        [window setFrame:windowRect display:YES animate:YES];
        [eventBox setHidden:NO];
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
        [window makeFirstResponder:[window initialFirstResponder]];
    }
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

- (IBAction)toggleEventBox:(id)sender
{
    [self p_setEventBoxHidden:![eventBox isHidden]];
}

#pragma mark -

-(void) dealloc
{
    [model release];
    [super dealloc];
}

@end
