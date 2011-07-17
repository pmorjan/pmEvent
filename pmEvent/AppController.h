//
//  AppController.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>
#import "CalController.h"

@interface AppController : NSObject 
{
    NSWindow *window;
    NSStatusItem *statusItem;
    IBOutlet NSButton       *btDeleteEvent;
    IBOutlet NSButton       *cbAllDayEvent;

    IBOutlet NSPopUpButton  *popUpCalendars;
    IBOutlet NSPopUpButton  *popUpAlarm;
    IBOutlet NSDatePicker   *datePickerEventStart;
    IBOutlet NSDatePicker   *datePickerEventStart2;
    IBOutlet NSDatePicker   *datePickerEventEnd;
    IBOutlet NSDatePicker   *datePickerAlarmInput;
    IBOutlet NSDatePicker   *datePickerAlarmStart;
    IBOutlet NSTextField    *alarmMinutesField;
    IBOutlet NSTextField    *textFieldTitle;
    IBOutlet NSButton       *comboBoxAlarm;
    IBOutlet NSButton       *comboBoxCalendar;
    IBOutlet NSArrayController  *eventArrayController;

    NSString        *eventTitle;
    NSString        *eventNotes;
    NSString        *eventUrl;
    NSDate          *currentDate;
	NSDate			*eventStartDate;
    NSDate			*eventEndDate;
	NSDate			*alarmDate;
    NSNumber        *alarmMinutes;
    NSDate          *alarmFromNow;
    NSTimer         *uptimeTimer;
    BOOL            updateEventEndTime;
}

@property (assign) IBOutlet NSWindow *window;
@property (copy)   NSNumber *alarmMinutes;
@property (copy)   NSDate   *alarmFromNow;
@property (readonly, retain) NSDate *currentDate;
@property (retain) NSDate *eventStartDate;
@property (retain) NSDate *eventEndDate;
@property (retain) NSDate *alarmDate;
@property (copy)   NSString *eventTitle;
@property (copy)   NSString *eventNotes;
@property (copy)   NSString *eventUrl;

- (IBAction)alarmPopUpMinutesChanged:(id)sender;
- (IBAction)eventEndTimeChanged:(id)sender;
- (IBAction)createEvent:(id)sender;
- (IBAction)deleteEvent:(id)sender;
- (IBAction)createAlarm:(id)sender;
- (IBAction)launchIcal:(id)sender;
- (IBAction)quit:(id)sender;
- (NSArray *)events;

@end
