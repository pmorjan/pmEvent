//
//  EventController.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>
#import "CalController.h"
#import "Model.h"

@interface EventController : NSObject
{
    IBOutlet NSButton       *buttonAllDayEvent;
    IBOutlet NSButton       *buttonDeleteEvent;

    IBOutlet NSPopUpButton      *popUpButtonAlarm;
    IBOutlet NSDatePicker       *datePickerEventStart;
    IBOutlet NSDatePicker       *datePickerEventStart2;
    IBOutlet NSDatePicker       *datePickerEventEnd;
    IBOutlet NSTextField        *alarmMinutesField;
    IBOutlet NSArrayController  *eventArrayController;

	NSDate		*eventStartDate;
    NSDate		*eventEndDate;
    NSNumber    *alarmMinutes;
    BOOL        shouldUpdateEventEndTime;

    Model       *model;
}

@property (copy)   NSNumber *alarmMinutes;
@property (readonly, retain) NSDate *currentDate;
@property (retain) NSDate *eventStartDate;
@property (retain) NSDate *eventEndDate;
@property (nonatomic, retain) Model *model;

- (IBAction)alarmPopUpMinutesChanged:(id)sender;
- (IBAction)eventEndTimeChanged:(id)sender;
- (IBAction)createEvent:(id)sender;
- (IBAction)deleteEvent:(id)sender;
- (NSArray*) events;

@end
