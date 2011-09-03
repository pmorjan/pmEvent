//
//  CustomSheet.m
//  pmEvent
//

#import "CustomSheet.h"

@implementation CustomSheet

@synthesize messageText;
@synthesize informativeText;
@synthesize defaultButtonLabel;
@synthesize alternateButtonLabel;

- (id)init
{
    if (![super initWithWindowNibName:@"CustomSheet"])
        return nil;
    
    defaultButtonLabel = @"Ok";
    return self;
}

- (void)windowDidLoad 
{
}

- (NSInteger)runModalForWindow:(NSWindow *)aWindow
{
    [NSApp beginSheet:[self window]
       modalForWindow:aWindow
        modalDelegate:self
       didEndSelector:NULL
          contextInfo:nil
     ];
    // wait until window has been closed by clicking a button
    [NSApp runModalForWindow:[self window]];
    // end modal session
    [NSApp endSheet:[self window]];
    // close panel
    [[self window] orderOut:self];
    
    return returnCode;
}

- (IBAction)pushDefaultButton:(id)sender
{
    returnCode = CSDefaultReturn;
    [NSApp stopModal];
}

- (IBAction)pushAlternateButton:(id)sender
{
    returnCode = CSAlternateReturn;
    [NSApp stopModal];
}

@end
