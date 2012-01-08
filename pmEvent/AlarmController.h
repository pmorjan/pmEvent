//
//  AlarmController.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>
#import "CalendarEvent.h"
#import "Model.h"

@interface AlarmController : NSObject
{
    Model    *model;
	NSDate   *alarmDate;
    NSDate   *alarmFromNow;
    NSTimer  *uptimeTimer;
    IBOutlet NSPopUpButton *popUpButtonScripts;
    IBOutlet NSDatePicker  *datePickerAlarmDate;
}

@property (copy) NSDate *alarmFromNow;
@property (copy) NSDate *alarmDate;
@property (nonatomic, retain) Model *model;

- (IBAction)createAlarm:(id)sender;

@end
