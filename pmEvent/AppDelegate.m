//
//  AppDelegate.m
//  pmEvent
//

#import "AppDelegate.h"
#import "CalendarMenu.h"

NSString *PMDisplayStatusIconKey = @"displayStatusIcon";
NSString *PMDisplayEventBoxKey   = @"displayEventBox";
NSString *PMCalendarKey          = @"calendar";

@interface AppDelegate ()
+ (void)initDefaults;
- (void)statusItemClick:(id)sender;
- (void)displayEventBox:(BOOL)show;
- (void)displayStatusIcon:(BOOL)show;
@end

@implementation AppDelegate

@synthesize window;

static NSUserDefaults *prefs;

+ (void)initialize
{
    if (self != [AppDelegate class])
        return;

    prefs = [NSUserDefaults standardUserDefaults];
    [self initDefaults];
    
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        model = [[Model alloc]init];
    }
    return self;
}

+ (void)initDefaults
{
    NSMutableDictionary *initialValues = [NSMutableDictionary dictionary]; 
    [initialValues setObject:[NSNumber numberWithBool:YES] forKey:PMDisplayStatusIconKey];
    [initialValues setObject:[NSNumber numberWithBool:YES] forKey:PMDisplayEventBoxKey];

    NSUserDefaultsController *defaults = [NSUserDefaultsController sharedUserDefaultsController];
    [defaults setInitialValues:initialValues];
    [defaults setAppliesImmediately:YES];
}

- (void)awakeFromNib
{
    // popUpCalendars
    // item in preferences might be no longer available
    [popUpButtonCalendars setMenu:[CalendarMenu calMenuWithTitle:@"Calendars"]];
    NSString *calMenuTitle = [prefs valueForKey:PMCalendarKey];
    if (calMenuTitle != nil) {
        if ([popUpButtonCalendars itemWithTitle:calMenuTitle] != nil) {
            [popUpButtonCalendars selectItemWithTitle:calMenuTitle];
        }
    }
    [self displayStatusIcon:[[[[NSUserDefaultsController sharedUserDefaultsController]values]valueForKey:PMDisplayStatusIconKey]boolValue]];
    [self displayEventBox:[[[[NSUserDefaultsController sharedUserDefaultsController]values]valueForKey:PMDisplayEventBoxKey]boolValue]];
     
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag 
{
    [self statusItemClick:nil];
    return YES;
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
    [prefs setObject:model.calendar.title forKey:PMCalendarKey];
    [prefs synchronize];
}

- (void)displayEventBox:(BOOL)show
{
    if (eventBox.isHidden != show)
        return;
    
    NSSize boxSize = [eventBox frame].size;
    NSRect windowRect = [window frame];
    
    if (show) {
        windowRect.size.height += boxSize.height;
        windowRect.origin.y    -= boxSize.height;
        [window setFrame:windowRect display:YES animate:YES];
        [eventBox setHidden:NO];
    } else {
        [eventBox setHidden:YES];
        windowRect.size.height -= boxSize.height;
        windowRect.origin.y    += boxSize.height;
        [window setFrame:windowRect display:YES animate:YES];        
    }    
}

- (void)displayStatusIcon:(BOOL)show
{
    if (show) {
        if (statusItem)
            return;
        
        statusItem = [[[NSStatusBar systemStatusBar]statusItemWithLength:-1]retain];
        [statusItem setImage:[NSImage imageNamed:@"ical.png"]];
        [statusItem setTarget:self];
        [statusItem setAction:@selector(statusItemClick:)];
        [statusItem setHighlightMode:YES];
    } else {
        [statusItem release];
        statusItem =nil;
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
}

#pragma mark -
#pragma mark IBActions

- (IBAction)launchIcal:(id)sender
{
    NSWorkspace *ws = [[[NSWorkspace alloc]init]autorelease];
    [ws launchApplication:@"iCal"];
}

- (IBAction)quit:(id)sender
{
    [NSApp terminate:sender];
}

- (IBAction)cbDisplayEventBox:(id)sender
{
    if ([sender state] == NSOnState) {
        [self displayEventBox:YES];
    } else {
        [self displayEventBox:NO];
    }
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
    [[self class]initDefaults];
    [self displayStatusIcon:[[[[NSUserDefaultsController sharedUserDefaultsController]values]valueForKey:PMDisplayStatusIconKey]boolValue]];
    [self displayEventBox:[[[[NSUserDefaultsController sharedUserDefaultsController]values]valueForKey:PMDisplayEventBoxKey]boolValue]];
}

- (IBAction)cbDisplayStatusItem:(id)sender 
{
    if ([sender state] == NSOnState) {
        [self displayStatusIcon:YES];
    } else {
        [self displayStatusIcon:NO];
    }
}

#pragma mark -

- (void)dealloc
{
    [model release];
    [super dealloc];
}

@end
