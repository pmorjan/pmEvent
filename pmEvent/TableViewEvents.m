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
    NSInteger row = [self selectedRow];

    if (row >= 0) {
        NSString *str = [event charactersIgnoringModifiers];
        if ([str isEqualToString: @" "]){
            [self togglePopover];
            return;
        }
        
        unichar keyChar = [str characterAtIndex:0];
        if (keyChar == NSDeleteCharacter || keyChar == NSDeleteFunctionKey) {
            if ([self numberOfRows] < 1) {
                [popover close];
            }
            [eventController deleteEvent:self];
            return;
        } 
    } 
    [super keyDown:event];
}

- (void)rightMouseDown:(NSEvent *)event
{
    [self togglePopover];
}

- (void)cancelOperation:(id)sender
{
    [popover close];
}

- (void)awakeFromNib
{
    [self setDoubleAction:@selector(togglePopover)];
    [popover setBehavior:NSPopoverBehaviorSemitransient];
    [popover setAnimates:NO];
    [popover setAppearance:NSPopoverAppearanceMinimal];
    [popover setDelegate:self];
}

#pragma mark -
#pragma mark NSPopover delegate methods

- (void)popoverDidShow:(NSNotification *)notification
{
    // is there a better way to avoid NSPopover beeing first responder?
    [window makeFirstResponder:self];  
}

@end
