//
//  TableViewController.m
//  pmEvent
//

#import "TableViewController.h"
#import "CalendarEvent.h"
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
