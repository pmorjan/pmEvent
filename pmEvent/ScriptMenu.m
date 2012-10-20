//
//  ScriptMenu.m
//  pmEvent
//
//  See https://discussions.apple.com/docs/DOC-4082 for
//  how to save scripts to "~/Library/Workflows/Applications/Calendar/"

#import "ScriptMenu.h"

@implementation ScriptMenu

- (void)addMenuItems
{
    NSMenuItem *item = [[NSMenuItem allocWithZone:[NSMenu menuZone]]initWithTitle:@"None" action:nil keyEquivalent:@""];
    [item setRepresentedObject:nil];
    [self addItem:item];
    [item release];
    [self addItem:[NSMenuItem separatorItem]];
    
    NSArray *domains = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *path = [[domains objectAtIndex:0] stringByAppendingPathComponent:@"Workflows/Applications/Calendar"];

    NSArray *allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSArray *scripts = [allFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.app'"]];
        
    for (NSString *filename in scripts) {
        NSURL *url = [NSURL fileURLWithPathComponents:[NSArray arrayWithObjects:path, filename, nil]];
        NSMenuItem *item = [[NSMenuItem allocWithZone:[NSMenu menuZone]]initWithTitle:filename action:nil keyEquivalent:@""];
        [item setRepresentedObject:url];
        [self addItem:item];
        [item release];
    }
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

+ (id)scriptMenuWithTitle:(NSString *)title
{
    return [[[ScriptMenu alloc]initWithTitle:title]autorelease];
}

@end
