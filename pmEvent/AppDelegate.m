//
//  AppDelegate.m
//  pmEvent
//

#import "AppDelegate.h"
#import "CalendarMenu.h"

@interface AppDelegate ()
- (void)statusItemClick:(id)sender;
- (void)setEventBoxHidden:(BOOL)hide;
@end

@implementation AppDelegate

@synthesize window;

static NSUserDefaults *prefs;

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
    [statusItem setAction:@selector(statusItemClick:)];
    [statusItem setHighlightMode:YES];

    // popUpCalendars
    // item in preferences might be no longer available
    [popUpButtonCalendars setMenu:[CalendarMenu calMenuWithTitle:@"Calendars"]];
    NSString *calMenuTitle = [prefs valueForKey:@"calMenuTitle"];
    if (calMenuTitle != nil) {
        if ([popUpButtonCalendars itemWithTitle:calMenuTitle] != nil) {
            [popUpButtonCalendars selectItemWithTitle:calMenuTitle];
        }
    }
    [self calendarChanged:nil];

    [self setEventBoxHidden:[prefs boolForKey:@"hideEventBox"]];
    
    [NSApp activateIgnoringOtherApps:YES];
    [window makeKeyAndOrderFront:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    eventController.model = model;
    alarmController.model = model;
    eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^(NSEvent *incomingEvent) {
        NSEvent *result = incomingEvent;
        NSWindow *targetWindow = [incomingEvent window];
        if ([targetWindow isSheet]) {
            if ([incomingEvent type] == NSKeyDown) {
                if ([incomingEvent keyCode] == 53) {
                    // Escape
                    [self endAllSheets:nil];
                    result = nil; // don't process this event
                }
            }
        }
        return result;  // process event
    }];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return NO;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self savePreferences];
}

- (void)savePreferences
{
    [prefs setObject:model.calendar.title forKey:@"calMenuTitle"];
    [prefs setBool:[eventBox isHidden] forKey:@"hideEventBox"];
    [prefs synchronize];
}

- (void)setEventBoxHidden:(BOOL)hide
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

- (void)statusItemClick:(id)sender
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

- (void)didEndPreferencesSheet:(NSWindow *)sheet 
{
    [self savePreferences];
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
    [self setEventBoxHidden:![eventBox isHidden]];
}

- (IBAction)showPreferencesSheet:(id)sender 
{
   [NSApp beginSheet:preferencesSheet
      modalForWindow:window
       modalDelegate:self
      didEndSelector:@selector(didEndPreferencesSheet:)
         contextInfo:nil
    ];
}

- (IBAction)endAllSheets:(id)sender 
{    
    for (NSWindow *w in [NSApp windows]) {
        if ([w isSheet]) {
            [NSApp endSheet:w];
            [w orderOut:w];
        }
    }
}

- (IBAction)resetPreferences:(id)sender
{
    NSDictionary *defaultsDict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (NSString *key in [defaultsDict allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

#pragma mark -

- (void)dealloc
{
    [model release];
    [super dealloc];
}

@end
