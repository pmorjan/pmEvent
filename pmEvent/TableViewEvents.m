//
//  TableViewEvents.m
//  pmEvent
//

#import "TableViewEvents.h"

@implementation TableViewEvents

- (void)showEventPopover
{
    NSInteger row = [self selectedRow];
    if (row >= 0) {
        [popover showRelativeToRect:[self bounds] ofView:self preferredEdge:NSMinXEdge];
    }
}

-(void)keyDown:(NSEvent *)event 
{
    // 49 = "Space Bar"
    if ([event keyCode] == 49) {
        if ([popover isShown]) {
            [popover close];
        } else {
            [self showEventPopover];
        }
    }  else {
        [super keyDown:event];
    }
}

- (void)rightMouseDown:(NSEvent *)event
{
    [self showEventPopover];
}
    
@end
