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
    IBOutlet NSPopUpButton  *popUpCalendars;
    IBOutlet NSPopUpButton  *popUpAlarm;
    IBOutlet NSButton       *cbQuickAlarm;
    IBOutlet NSDatePicker   *datePickerStart;
    IBOutlet NSDatePicker   *datePickerStart2;
    IBOutlet NSDatePicker   *datePickerEnd;
    IBOutlet NSDatePicker   *datePickerAlarm;
    IBOutlet NSTextField    *alarmMinutesField;
    IBOutlet NSTextField    *textFieldTitle;
    IBOutlet NSButton       *comboBoxAlarm;
    IBOutlet NSButton       *comboBoxCalendar;
    IBOutlet NSButton       *cbAllDayEvent;
    IBOutlet NSArrayController  *eventArrayController;
	NSDate			*eventStartDate;
    NSDate			*eventEndDate;
    NSDate          *alarmFromNow;
    NSNumber        *alarmMinutes;
    NSTimer         *uptimeTimer;
    CalController   *cal;
}

@property (assign) IBOutlet NSWindow *window;
@property (copy) NSNumber *alarmMinutes;
@property (copy) NSDate   *alarmFromNow;
@property(readonly, retain) NSDate   *eventStartDate;
@property(readwrite, retain) NSDate   *eventEndDate;

- (IBAction)alarmPopUpMinutesChanged:(id)sender;
- (IBAction)deleteEvent:(id)sender;
- (IBAction)createEvent:(id)sender;
- (IBAction)launchIcal:(id)sender;
- (IBAction)updateState:(id)sender;
- (IBAction)quit:(id)sender;
- (NSArray *)events;
- (void)setEventStartDate:(NSDate *)newDate;

@end
