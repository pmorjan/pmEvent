//
//  PopoverController.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>

@interface PopoverController : NSViewController <NSPopoverDelegate>
{
    NSPopover *popover;
}
- (IBAction)togglePopover:(id)sender;
- (IBAction)closePopover:(id)sender;

@end
