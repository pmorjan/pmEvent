//
//  AppDelegate.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>
#import "Model.h"
#import "EventController.h"
#import "AlarmController.h"

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

- (IBAction)calendarChanged:(id)sender;
- (IBAction)toggleEventBox:(id)sender;
- (IBAction)showPreferencesSheet:(id)sender;
- (IBAction)endAllSheets:(id)sender;
- (IBAction)resetPreferences:(id)sender;
- (IBAction)launchIcal:(id)sender;
- (IBAction)quit:(id)sender;
- (void)savePreferences;
- (void)didEndPreferencesSheet:(NSWindow *)sheet;

@end
