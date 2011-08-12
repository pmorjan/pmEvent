//
//  TableViewEvents.h
//  pmEvent
//

#import <AppKit/AppKit.h>
#import "EventController.h"

@interface TableViewEvents : NSTableView <NSPopoverDelegate>
{
    IBOutlet NSWindow  *window;
    IBOutlet NSPopover *popover;
    IBOutlet EventController *eventController;
}

@end
