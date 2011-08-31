//
//  TableViewController.h
//  pmEvent
//

#import <Foundation/Foundation.h>
#import "EventController.h"
#import "PopoverController.h"

@interface TableViewController : NSViewController
{
    NSDate *dateOfEvents;
    IBOutlet NSTableView       *tableView;
    IBOutlet PopoverController *popoverController;
    IBOutlet EventController   *eventController;
}

@property (copy) NSDate *dateOfEvents;

- (NSArray*)events;

@end
