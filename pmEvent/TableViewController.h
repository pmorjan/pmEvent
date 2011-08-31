//
//  TableViewController.h
//  pmEvent
//

#import <Foundation/Foundation.h>
#import "PopoverController.h"

@interface TableViewController : NSViewController
{
    NSWindow    *window;
    NSDate      *dateOfEvents;
    IBOutlet NSTableView       *tableView;
    IBOutlet PopoverController *popoverController;
    IBOutlet NSArrayController *eventArrayController;
}

@property (assign) IBOutlet NSWindow *window;
@property (copy) NSDate *dateOfEvents;

- (NSArray*)events;
- (IBAction)deleteEvent:(id)sender;
- (IBAction)launchIcal:(id)sender;

@end
