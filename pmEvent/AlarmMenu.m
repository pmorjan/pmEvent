//
//  AlarmMenu.m
//  pmEvent
//

#import "AlarmMenu.h"

@implementation AlarmMenu

- (void)addMenuItems
{
    NSMenuItem *item;
    item = [[NSMenuItem allocWithZone:[NSMenu menuZone]]initWithTitle:@"on date" action:nil keyEquivalent:@""];
    [item setRepresentedObject:[NSNumber numberWithInt:0]];
    [self addItem:item];
    [item release];
    
    item = [[NSMenuItem allocWithZone:[NSMenu menuZone]]initWithTitle:@"minutes before" action:nil keyEquivalent:@""];
    [item setRepresentedObject:[NSNumber numberWithInt:-60]];
    [self addItem:item];
    [item release];
    
    item = [[NSMenuItem allocWithZone:[NSMenu menuZone]]initWithTitle:@"hours before" action:nil keyEquivalent:@""];
    [item setRepresentedObject:[NSNumber numberWithInt:-60 * 60]];
    [self addItem:item];
    [item release];
    
    [self addItem:[NSMenuItem separatorItem]];
    
    item = [[NSMenuItem allocWithZone:[NSMenu menuZone]]initWithTitle:@"None" action:nil keyEquivalent:@""];
    [item setRepresentedObject:nil];
    [self addItem:item];
    [item release];
}

- (id)initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title];
    if (self != nil) {
        [self addMenuItems];
        [self setShowsStateColumn:YES];
    }
    return self;
}

+ (id)alarmMenuWithTitle:(NSString *)title
{
    return [[[AlarmMenu alloc]initWithTitle:title]autorelease];
}

@end
