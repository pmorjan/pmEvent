//
//  AlarmViewController.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>
#import "CalController.h"
#import "Model.h"

@interface AlarmViewController : NSViewController
{
	NSDate		*alarmDate;
    NSDate      *alarmFromNow;
    NSTimer     *uptimeTimer;
    Model       *model;
}

@property (copy)   NSDate *alarmFromNow;
@property (retain) NSDate *alarmDate;
@property (nonatomic, retain) Model *model;

- (IBAction)createAlarm:(id)sender;

@end
