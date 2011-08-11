//
//  TextViewWithURL.m
//  pmEvent
//

#import "TextFieldWithURL.h"

@implementation TextFieldWithURL


- (void)mouseDown:(NSEvent *)theEvent
{    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[self stringValue]]];
}

- (void)resetCursorRects
{
	[self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
}

@end
