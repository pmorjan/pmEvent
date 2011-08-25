//
//  AppDelegate.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>
#import "Model.h"
#import "EventController.h"
#import "AlarmController.h"

extern NSString *PMCalendarKey;
extern NSString *PMDisplayStatusIconKey;
extern NSString *PMDisplayEventBoxKey;

@interface AppDelegate : NSObject <NSApplicationDelegate> 
{
    NSWindow     *window;
    NSStatusItem *statusItem;
    Model        *model;
    IBOutlet NSBox           *eventBox;    
    IBOutlet NSPopUpButton   *popUpButtonCalendars;
    IBOutlet EventController *eventController;
    IBOutlet AlarmController *alarmController;
    IBOutlet NSWindow        *preferencesSheet;
    id                       eventMonitor;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)cbDisplayEventBox:(id)sender;
- (IBAction)showPreferencesSheet:(id)sender;
- (IBAction)endAllSheets:(id)sender;
- (IBAction)resetPreferences:(id)sender;
- (IBAction)cbDisplayStatusItem:(id)sender;
- (IBAction)launchIcal:(id)sender;
- (IBAction)quit:(id)sender;

@end
