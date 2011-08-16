//
//  PopoverController.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>

@interface PopoverController : NSViewController <NSPopoverDelegate,NSTableViewDataSource>
{
    NSPopover *popover;
    IBOutlet NSArrayController *eventArrayController;
    IBOutlet NSTableView       *popoverAlarmTableView;
    NSArray *alarmArray;
}
- (IBAction)togglePopover:(id)sender;
- (IBAction)closePopover:(id)sender;

@end
