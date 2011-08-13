//
//  PopoverController.m
//  pmEvent
//

#import "PopoverController.h"

@implementation PopoverController

- (id)init {
    self = [super init];
    if (self) {
        popover = [[NSPopover alloc]init];
    }
    return self;
}

- (void)awakeFromNib
{
    [popover setContentViewController:self];
    [popover setBehavior:NSPopoverBehaviorSemitransient];
    [popover setAnimates:NO];
    [popover setAppearance:NSPopoverAppearanceMinimal];
    [popover setDelegate:self];    
}

- (void)togglePopover:(id)sender
{
    if ([popover isShown]) {
        [popover close];
    } else {
        [popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];
         // is there a better way to prevent NSPopover beeing first responder?
        [[sender window] makeFirstResponder:sender];
    }
}

- (void)closePopover:(id)sender
{
    if ([popover isShown]) {
        [popover close];
    }
}

@end
