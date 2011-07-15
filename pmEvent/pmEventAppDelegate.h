//
//  pmEventAppDelegate.h
//  pmEvent
//
//  Created by peter on 2011-07-15.
//  Copyright 2011 NoWhere. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface pmEventAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
