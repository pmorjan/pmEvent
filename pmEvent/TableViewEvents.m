//
//  TableViewEvents.m
//  pmEvent
//

#import "TableViewEvents.h"

@implementation TableViewEvents

- (void)togglePopover
{
    if ([popover isShown]) {
        [popover close];
    } else {
        if ([self selectedRow] >= 0) {
            [popover showRelativeToRect:[self bounds] ofView:self preferredEdge:NSMinXEdge];
        }
    }
}

-(void)keyDown:(NSEvent *)event 
{
    if ([[event characters] isEqualToString: @" "]){
        [self togglePopover];
    }  else {
        [super keyDown:event];
    }
}

- (void)rightMouseDown:(NSEvent *)event
{
    [self togglePopover];
}

- (void)cancelOperation:(id)sender
{
}

- (void)awakeFromNib
{
    [self setDoubleAction:@selector(togglePopover)];
    [popover setBehavior:NSPopoverBehaviorSemitransient];
    [popover setAnimates:NO];
    [popover setAppearance:NSPopoverAppearanceMinimal];
    
}

@end
