//
//  AppDelegate.m
//  pmEvent
//

#import "AppDelegate.h"
#import "CalendarMenu.h"

NSString *PMDisplayStatusIconKey = @"displayStatusIcon";
NSString *PMDisplayEventBoxKey   = @"displayEventBox";
NSString *PMCalendarKey          = @"calendar";

@implementation AppDelegate

@synthesize window;

static NSUserDefaults *prefs;

#pragma mark -
#pragma mark Private

+ (void)_initializeSharedUserDefaults
{
    NSMutableDictionary *initialValues = [NSMutableDictionary dictionary]; 
    [initialValues setObject:[NSNumber numberWithBool:YES] forKey:PMDisplayStatusIconKey];
    [initialValues setObject:[NSNumber numberWithBool:YES] forKey:PMDisplayEventBoxKey];
    
    NSUserDefaultsController *defaults = [NSUserDefaultsController sharedUserDefaultsController];
    [defaults setInitialValues:initialValues];
    [defaults setAppliesImmediately:YES];
}

- (void)_displayEventBox:(BOOL)show
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

- (void)_displayStatusIcon:(BOOL)show
{
    if (show) {
        if (statusItem)
            return;
        
        statusItem = [[[NSStatusBar systemStatusBar]statusItemWithLength:-1]retain];
        [statusItem setImage:[NSImage imageNamed:@"ical.png"]];
        [statusItem setTarget:self];
        [statusItem setAction:@selector(_toggleMainWindow)];
        [statusItem setHighlightMode:YES];
    } else {
        [statusItem release];
        statusItem = nil;
    }
}

- (void)_toggleMainWindow
{
    if ([window isMiniaturized]) {
        [window deminiaturize:nil];
        [window makeFirstResponder:[window initialFirstResponder]];
    } else {
        if ([(NSWindow *)window isKeyWindow]) {
            [window miniaturize:nil];
        } else {
            [NSApp activateIgnoringOtherApps:YES];
            [window makeKeyAndOrderFront:self];
            [window makeFirstResponder:[window initialFirstResponder]];
        }
    }
}

#pragma mark -
#pragma mark Init

+ (void)initialize
{
    if (self != [AppDelegate class])
        return;

    prefs = [NSUserDefaults standardUserDefaults];
    [self _initializeSharedUserDefaults];
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        model = [[Model alloc]init];
        gitDescription = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return self;
}

- (void)awakeFromNib
{
    // popUpCalendars
    // try to pre select Calendar from preferences
    [popUpButtonCalendars setMenu:[CalendarMenu calMenuWithTitle:@"Calendars"]];
    NSString *calMenuTitle = [prefs valueForKey:PMCalendarKey];
    if (calMenuTitle != nil) {
        if ([popUpButtonCalendars itemWithTitle:calMenuTitle] != nil) {
            [popUpButtonCalendars selectItemWithTitle:calMenuTitle];
        }
    }
    model.calendar = [[popUpButtonCalendars selectedItem]representedObject];
    [self _displayStatusIcon:[[[[NSUserDefaultsController sharedUserDefaultsController]values]valueForKey:PMDisplayStatusIconKey]boolValue]];
    [self _displayEventBox:  [[[[NSUserDefaultsController sharedUserDefaultsController]values]valueForKey:PMDisplayEventBoxKey]boolValue]];
}

#pragma mark -
#pragma mark NSApplicationDelegate

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

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag 
{
    if (flag == NO) {
        [NSApp activateIgnoringOtherApps:YES];
        [window makeKeyAndOrderFront:self];
        [window makeFirstResponder:[window initialFirstResponder]];
    }
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [prefs setObject:model.calendar.title forKey:PMCalendarKey];
    [prefs synchronize];
}

#pragma mark -
#pragma mark IBAction

- (IBAction)launchIcal:(id)sender
{
    NSWorkspace *ws = [[[NSWorkspace alloc]init]autorelease];
    [ws launchApplication:@"iCal"];
}

- (IBAction)quit:(id)sender
{
    [NSApp terminate:sender];
}

- (IBAction)displayEventBox:(id)sender
{
    if ([sender state] == NSOnState) {
        [self _displayEventBox:YES];
    } else {
        [self _displayEventBox:NO];
    }
}

- (IBAction)displayAboutSheet:(id)sender 
{
    [NSApp beginSheet:aboutSheet
       modalForWindow:window
        modalDelegate:self
       didEndSelector:nil
          contextInfo:nil
     ];
}

- (IBAction)displayPreferencesSheet:(id)sender 
{
   [NSApp beginSheet:preferencesSheet
      modalForWindow:window
       modalDelegate:self
      didEndSelector:nil
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
    [[self class]_initializeSharedUserDefaults];
    [self _displayStatusIcon:[[[[NSUserDefaultsController sharedUserDefaultsController]values]valueForKey:PMDisplayStatusIconKey]boolValue]];
    [self _displayEventBox:[[[[NSUserDefaultsController sharedUserDefaultsController]values]valueForKey:PMDisplayEventBoxKey]boolValue]];
}

- (IBAction)displayStatusIcon:(id)sender 
{
    if ([sender state] == NSOnState) {
        [self _displayStatusIcon:YES];
    } else {
        [self _displayStatusIcon:NO];
    }
}

- (IBAction)openUrl:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[sender title]]];
}

#pragma mark -

- (void)dealloc
{
    [model release];
    [super dealloc];
}

@end
