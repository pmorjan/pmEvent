//
//  TableViewController.m
//  pmEvent
//

#import "TableViewController.h"
#import "CalendarEvent.h"
#import "Model.h"
#import "DateCategory.h"

@implementation TableViewController

@synthesize dateOfEvents;
@synthesize window;

- (id)init
{
    self = [super init];
    if (self) {
        dateOfEvents = [[NSDate date]retain];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

        [nc addObserver:self selector:@selector(eventsChanged:) name:CalEventsChangedExternallyNotification object:nil];
        [nc addObserver:self selector:@selector(eventsChanged:) name:CalEventsChangedNotification object:nil];
        [nc addObserver:self selector:@selector(eventsChanged:) name:CalCalendarsChangedExternallyNotification object:nil];
        [nc addObserver:self selector:@selector(dateChanged:)   name:PMDateChangedNotification object:nil];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setNextResponder:[window contentView]];
    [tableView setNextResponder:self];
    [tableView setDoubleAction:@selector(doubleClickAction)];
}

- (void)eventsChanged:(NSNotification *)notification
{
    [self willChangeValueForKey:@"events"];
    [self didChangeValueForKey:@"events"];
}

- (void)dateChanged:(NSNotification *)notification
{
    [self willChangeValueForKey:@"events"];
    self.dateOfEvents = [[notification userInfo] objectForKey:@"startDate"];
    [self didChangeValueForKey:@"events"];
}

- (NSArray*)events
{
	return [CalendarEvent eventsOnDate:self.dateOfEvents];
}

#pragma mark -
#pragma mark Key Events

-(void)keyDown:(NSEvent *)event 
{
    NSInteger row = [tableView selectedRow];
    
    if (row >= 0) {
        NSString *str = [event charactersIgnoringModifiers];
        if ([str isEqualToString: @" "]){
            [popoverController togglePopover:tableView];
            return;
        }
        
        unichar keyChar = [str characterAtIndex:0];
        if (keyChar == NSDeleteCharacter || keyChar == NSDeleteFunctionKey) {
            [self deleteEvent:tableView];
            if ([tableView numberOfRows] < 1) {
                [popoverController closePopover:tableView];
                [window makeFirstResponder:[window initialFirstResponder]];
            }
            return;
        } 
    } 
    if ([event type] == NSKeyDown) {
        if ([event keyCode] == 53) {
            // Escape
            [popoverController closePopover:tableView];
            return;
        }
    }
    [super keyDown:event];
}

- (void)cancelOperation:(id)sender
{
    [popoverController closePopover:tableView];
}

#pragma mark -
#pragma mark Mouse Events

- (void)doubleClickAction
{
    [popoverController togglePopover:tableView];
}

- (void)rightMouseDown:(NSEvent *)event
{
    [popoverController togglePopover:tableView];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)deleteEvent:(id)sender
{
    CalEvent *evt = [[eventArrayController selectedObjects]objectAtIndex:0];
    
    // check if the event covers multiple days
    NSInteger pastDays = [evt.endDate pastDaysSinceDate:evt.startDate];
    if ([evt.endDate isEqualToDate:[evt.endDate dateAtMidnight]]) {
        //  end day that ends at midnight does not count
        pastDays--;
    }
    if (pastDays > 0) {
        // Event covers multiple days
        NSAlert *alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"This event covers %ld days.", pastDays +1]
                                         defaultButton:@"Delete" 
                                       alternateButton:@"Cancel" 
                                           otherButton:nil
                             informativeTextWithFormat:@"Do you really want to delete this event ?"];
        if ([alert runModal] != NSAlertDefaultReturn) {
            return;
        }
    }
    
    /* ToDo: enhance deleting a multi-occurence event 
     *
     *      4y ago ------------------>| start ------------------ end |<-------------------------- distant future 
     */
    NSArray *pastEvents   = [CalendarEvent eventsWithUID:[evt uid] startDate:[evt.startDate dateFourYearsAgo] endDate:evt.startDate];
    NSArray *futureEvents = [CalendarEvent eventsWithUID:[evt uid] startDate:evt.endDate endDate:[NSDate distantFuture]];
    
    //DLog(@"past:%ld  future:%ld",[pastEvents count], [futureEvents count]);
    
    CalSpan span = CalSpanThisEvent;

    if ([pastEvents count] + [futureEvents count] > 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"This is a multi-occurrence Event." 
                                         defaultButton:@"Delete" 
                                       alternateButton:@"Cancel" 
                                           otherButton:nil
                             informativeTextWithFormat:@"Do you really want to delete all occurrences of this event ?"];
        if ([alert runModal] == NSAlertDefaultReturn) {
            span = CalSpanAllEvents; 
        } else {
            return;
        }
    }
    
    NSUndoManager *undoManager = [sender undoManager];
    [undoManager setActionName:@"Remove Event"];        
    [[undoManager prepareWithInvocationTarget:[CalendarEvent class]] saveEvent:evt span:span];
    [CalendarEvent removeEvent:evt span:span];
    if ([[eventArrayController arrangedObjects]count] < 1) {
        [[sender window] makeFirstResponder:[[sender window] initialFirstResponder]];
    }
}

- (IBAction)launchIcal:(id)sender
{    
    NSString *source;
    if ([eventArrayController selectedObjects].count > 0) {
        // open iCal, show existing event
        CalEvent *calEvent = [[eventArrayController selectedObjects]objectAtIndex:0];
        
        source = [NSString stringWithFormat:@"tell application \"iCal\" \n activate\n" 
                            "tell calendar \"%@\" \n set MyEvent to first event whose uid=\"%@\" \n end tell\n"
                            "if MyEvent is not null then \n show MyEvent\n end if\n"
                            "end tell", calEvent.calendar.title, calEvent.uid];
        
        
    } else {
        // open iCal on date
        source = [NSString stringWithFormat:@"tell application \"iCal\"\n" 
                            "view calendar at date \"%@\" \n activate\n end tell", [dateOfEvents descriptionIcalDate]];
    }
    
    NSDictionary *errorInfo = [NSDictionary dictionary];
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:source];
    
    if ([script executeAndReturnError:&errorInfo] == nil) {
    
        NSString *msg  = [NSString stringWithFormat:@"%@ (Error %@)",
                            [errorInfo objectForKey:@"NSAppleScriptErrorMessage"],
                            [errorInfo objectForKey:@"NSAppleScriptErrorNumber"]];
        NSAlert *alert = [NSAlert alertWithMessageText:msg
                                         defaultButton:@"OK"
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@""];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert runModal];
    }
}

#pragma mark -

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self]; 
    [super dealloc];
}
@end
