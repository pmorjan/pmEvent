//
//  CustomSheet.h
//  pmEvent
//

#import <Cocoa/Cocoa.h>

typedef enum {
    CSDefaultReturn		= 1,
    CSAlternateReturn	= 0,
} CSReturnCode;

@interface CustomSheet : NSWindowController
{
    NSString     *messageText;
    NSString     *informativeText;
    NSString     *defaultButtonLabel;
    NSString     *alternateButtonLabel;
    CSReturnCode returnCode;
}

@property (copy) NSString *messageText;
@property (copy) NSString *informativeText;
@property (copy) NSString *defaultButtonLabel;
@property (copy) NSString *alternateButtonLabel;

- (IBAction)pushDefaultButton:(id)sender;
- (IBAction)pushAlternateButton:(id)sender;
- (NSInteger)runModalForWindow:(NSWindow *)window;

@end
