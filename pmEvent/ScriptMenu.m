//
//  ScriptMenu.m
//  pmEvent
//

#import "ScriptMenu.h"

@interface ScriptMenu ()
- (void)p_addMenuItems;
@end

@implementation ScriptMenu

- (id)initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title];
    if (self != nil) {
        [self p_addMenuItems];
        [self setShowsStateColumn:YES];
    }
    return self;
}

+ (id)scriptMenuWithTitle:(NSString *)title
{
    return [[[ScriptMenu alloc]initWithTitle:title]autorelease];
}

-(void)p_addMenuItems
{
    NSMenuItem *item = [[NSMenuItem allocWithZone:[NSMenu menuZone]]initWithTitle:@"None" action:nil keyEquivalent:@""];
    [item setRepresentedObject:nil];
    [self addItem:item];
    [item release];
    [self addItem:[NSMenuItem separatorItem]];

    NSString *path = [[NSBundle mainBundle] resourcePath];
    NSArray *allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSArray *scripts = [allFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.scpt'"]];
    
    for (NSString *filename in scripts) {
        NSString *title = [filename stringByDeletingPathExtension];
        NSURL *url = [[NSBundle mainBundle]URLForResource:filename withExtension:nil];
        NSMenuItem *item = [[NSMenuItem allocWithZone:[NSMenu menuZone]]initWithTitle:title action:nil keyEquivalent:@""];
        [item setRepresentedObject:url];
        [self addItem:item];
        [item release];
    }
}

@end
