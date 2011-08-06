//
//  AppDelegate.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>
#import "Model.h"
#import "EventController.h"
#import "AlarmController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {

    NSWindow     *window;
    NSStatusItem *statusItem;
    Model        *model;

    IBOutlet NSPopUpButton   *popUpButtonCalendars;
    IBOutlet EventController *eventController;
    IBOutlet AlarmController *alarmController;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)calendarChanged:(id)sender;
- (IBAction)launchIcal:(id)sender;
- (IBAction)quit:(id)sender;

@end
