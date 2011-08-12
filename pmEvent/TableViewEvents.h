//
//  TableViewEvents.h
//  pmEvent
//

#import <AppKit/AppKit.h>

@interface TableViewEvents : NSTableView <NSPopoverDelegate>
{
    IBOutlet NSPopover *popover;
    IBOutlet NSWindow  *window;
}

@end
