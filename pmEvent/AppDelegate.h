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
    NSString     *gitDescription;
    IBOutlet NSBox           *eventBox;
    IBOutlet NSPopUpButton   *popUpButtonCalendars;
    IBOutlet EventController *eventController;
    IBOutlet AlarmController *alarmController;
    IBOutlet NSWindow        *aboutSheet;
    IBOutlet NSWindow        *preferencesSheet;
    id                       eventMonitor;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) Model    *model;
@property (copy)   NSString *gitDescription;

- (IBAction)displayEventBox:(id)sender;
- (IBAction)displayStatusIcon:(id)sender;
- (IBAction)displayPreferencesSheet:(id)sender;
- (IBAction)displayAboutSheet:(id)sender;
- (IBAction)endSheet:(id)sender;
- (IBAction)resetPreferences:(id)sender;
- (IBAction)openUrl:(id)sender;
- (IBAction)quit:(id)sender;

@end
