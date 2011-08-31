//
//  TableViewController.m
//  pmEvent
//

#import "TableViewController.h"
#import "Model.h"

@implementation TableViewController

@synthesize dateOfEvents;

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
    [tableView setNextResponder:self];
    [tableView setDoubleAction:@selector(doubleClickAction)];
}

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
            [eventController deleteEvent:tableView];
            if ([tableView numberOfRows] < 1) {
                [popoverController closePopover:tableView];
                [[self.view window] makeFirstResponder:[[tableView window] initialFirstResponder]];
            }
            return;
        } 
    } 
    [super keyDown:event];
}

- (void)rightMouseDown:(NSEvent *)event
{
    [popoverController togglePopover:tableView];
}

- (void)cancelOperation:(id)sender
{
    [popoverController closePopover:tableView];
}

- (void)doubleClickAction
{
    [popoverController togglePopover:tableView];
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self]; 
    [super dealloc];
}
@end
