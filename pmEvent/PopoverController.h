//
//  PopoverController.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>

@interface PopoverController : NSViewController <NSPopoverDelegate,NSTableViewDataSource>
{
    IBOutlet NSArrayController *eventArrayController;
    IBOutlet NSTableView       *popoverAlarmTableView;
    NSPopover *popover;
    NSArray *alarmArray;
}

@property (retain) NSArray *alarmArray;

- (IBAction)togglePopover:(id)sender;
- (IBAction)closePopover:(id)sender;

@end
