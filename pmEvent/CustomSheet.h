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
    IBOutlet NSButton   *defaultButton;
    IBOutlet NSButton   *alternateButton;
    NSString            *title;
    NSString            *informativeText;
    NSString            *defaultButtonTitle;
    NSString            *alternateButtonTitle;
    CSReturnCode        returnCode;
}

@property (copy) NSString *title;
@property (copy) NSString *informativeText;
@property (copy) NSString *defaultButtonTitle;
@property (copy) NSString *alternateButtonTitle;

+ (id)sheetWithTitle:(NSString *)aTitle
     informativeText:(NSString *)aText 
       defaultButton:(NSString *)aDefaultButtonTitle
     alternateButton:(NSString *)aAlternateButtonTitle;

- (IBAction)pushDefaultButton:(id)sender;
- (IBAction)pushAlternateButton:(id)sender;
- (NSInteger)runModalForWindow:(NSWindow *)aWindow;

@end
