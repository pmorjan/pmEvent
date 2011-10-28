//
//  CalendarMenu.m
//  pmEvent
//

#import "CalendarMenu.h"
#import <CalendarStore/CalendarStore.h>

@implementation CalendarMenu

- (void)removeAllItems
{
    for (NSMenuItem *item in [self itemArray]) {
        [self removeItem:item];
    }
}

- (void)updateMenuItems
{
    NSSize imgSize = NSMakeSize(12, 8);
    
    [self setShowsStateColumn:YES];
    [self removeAllItems];
    
	NSMutableArray *calenders = [NSMutableArray arrayWithArray:[[CalCalendarStore defaultCalendarStore] calendars]];
    
    for (CalCalendar *cal in calenders) {
        
        if ([cal isEditable] == NO) {
            // don't add read-only calendars such as 'Birthdays'
            continue;
        }
        
        NSMenuItem *item = [[NSMenuItem allocWithZone:[NSMenu menuZone]]initWithTitle:cal.title action:nil keyEquivalent:@""];
        
        // create an image
        NSImage *image = [[NSImage alloc] initWithSize:imgSize];
        [image lockFocus];
        [[NSColor blackColor] set];
        [NSBezierPath fillRect: NSMakeRect(0, 0, imgSize.width, imgSize.height )];
        [cal.color set];
        [NSBezierPath fillRect: NSMakeRect(1, 1, imgSize.width -2, imgSize.height -2)];
        [image unlockFocus];
        
        // set item parameters
        [item setRepresentedObject:cal];
        [item setImage:image];
        [item setOnStateImage:[NSImage imageNamed:@"NSMenuCheckmark"]];
        [item setMixedStateImage:nil];
        [self addItem:item];
        [item release];
        [image release];
    }
}

- (id) initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title];
    if (self != nil) {
        [self updateMenuItems];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateMenuItems)
                                                     name:CalCalendarsChangedExternallyNotification
                                                   object:nil];
    }
    return self;
}

+ (id)calMenuWithTitle:(NSString *)title
{
    return [[[CalendarMenu alloc]initWithTitle:title]autorelease];
}

@end
