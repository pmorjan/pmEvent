//
//  TableViewController.h
//  pmEvent
//

#import <Foundation/Foundation.h>
#import "PopoverController.h"

@interface TableViewController : NSViewController
{
    NSDate *dateOfEvents;
    IBOutlet NSTableView       *tableView;
    IBOutlet PopoverController *popoverController;
    IBOutlet NSArrayController *eventArrayController;
}

@property (copy) NSDate *dateOfEvents;

- (NSArray*)events;
- (IBAction)deleteEvent:(id)sender;
- (IBAction)launchIcal:(id)sender;

@end
