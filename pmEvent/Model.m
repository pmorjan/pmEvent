//
//  Model.m
//  pmEvent
//

#import "Model.h"

@implementation Model

@synthesize eventTitle, eventNotes, eventUrl;
@synthesize calendar;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

@end
