//
//  TableViewEvents.h
//  pmEvent
//

#import <AppKit/AppKit.h>
#import "EventController.h"
#import "PopoverController.h"

@interface TableViewEvents : NSTableView
{
    IBOutlet PopoverController *popoverController;
    IBOutlet EventController   *eventController;
}

@end
