//
//  TableViewEvents.m
//  pmEvent
//

#import "TableViewEvents.h"

@implementation TableViewEvents

-(void)keyDown:(NSEvent *)event 
{
    NSInteger row = [self selectedRow];

    if (row >= 0) {
        NSString *str = [event charactersIgnoringModifiers];
        if ([str isEqualToString: @" "]){
            [popoverController togglePopover:self];
            return;
        }
        
        unichar keyChar = [str characterAtIndex:0];
        if (keyChar == NSDeleteCharacter || keyChar == NSDeleteFunctionKey) {
            [eventController deleteEvent:self];
            if ([self numberOfRows] < 1) {
                [popoverController closePopover:self];
                [[self window] makeFirstResponder:[[self window] initialFirstResponder]];
            }
            return;
        } 
    } 
    [super keyDown:event];
}

- (void)rightMouseDown:(NSEvent *)event
{
    [popoverController togglePopover:self];
}

- (void)cancelOperation:(id)sender
{
    [popoverController closePopover:self];
}

- (void)doubleClickAction
{
    [popoverController togglePopover:self];
}

- (void)awakeFromNib
{
    [self setDoubleAction:@selector(doubleClickAction)];
}

@end
