//
//  EventController.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>
#import "Model.h"

@interface EventController : NSObject
{
    IBOutlet NSButton           *buttonAllDayEvent;
    IBOutlet NSPopUpButton      *popUpButtonAlarm;
    IBOutlet NSDatePicker       *datePickerEventStart;
    IBOutlet NSDatePicker       *datePickerEventStart2;
    IBOutlet NSDatePicker       *datePickerEventEnd;
    IBOutlet NSTextField        *alarmMinutesField;
    Model       *model;
	NSDate		*eventStartDate;
    NSDate		*eventEndDate;
    NSNumber    *alarmMinutes;
    BOOL        shouldUpdateEventEndTime;
}

@property (nonatomic, retain) Model *model;
@property (copy) NSDate *eventStartDate;
@property (copy) NSDate *eventEndDate;
@property (copy) NSNumber *alarmMinutes;
@property (assign) BOOL shouldUpdateEventEndTime;

- (IBAction)alarmPopUpMinutesChanged:(id)sender;
- (IBAction)eventEndTimeChanged:(id)sender;
- (IBAction)createEvent:(id)sender;
@end
