//
//  PopoverController.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>

@interface PopoverController : NSViewController <NSPopoverDelegate>
{
    NSPopover *popover;
    IBOutlet NSArrayController *eventArrayController;
    IBOutlet NSTableView       *popoverAlarmTableView;
    NSMutableArray *alarmArray;
}
- (IBAction)togglePopover:(id)sender;
- (IBAction)closePopover:(id)sender;

@end
