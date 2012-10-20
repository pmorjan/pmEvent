//
//  CustomSheet.m
//  pmEvent
//

#import "CustomSheet.h"

@implementation CustomSheet

@synthesize title;
@synthesize informativeText;
@synthesize defaultButtonTitle;
@synthesize alternateButtonTitle;

- (id)init
{
    self = [super initWithWindowNibName:@"CustomSheet"];
    if (!self) {
        return nil;
    }
    [self setDefaultButtonTitle:@"Ok"];
    return self;
}

- (void)windowDidLoad 
{
    [defaultButton setKeyEquivalent:@"\r"];
    if ([alternateButton.title isCaseInsensitiveLike:@"cancel"]) {
        [alternateButton setKeyEquivalent:@"\e"];
    } else if ([defaultButton.title isCaseInsensitiveLike:@"cancel"]) {
        [defaultButton setKeyEquivalent:@"\e"];
    }
}

+ (id)sheetWithTitle:(NSString *)aTitle
     informativeText:(NSString *)aText 
       defaultButton:(NSString *)aDefaultButtonTitle
     alternateButton:(NSString *)aAlternateButtonTitle
{
    CustomSheet *sheet = [[CustomSheet alloc]init];
    sheet.title                 = aTitle;
    sheet.informativeText       = aText;
    sheet.defaultButtonTitle    = aDefaultButtonTitle;
    sheet.alternateButtonTitle  = aAlternateButtonTitle;
    return [sheet autorelease];
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
