//
//  Model.m
//  pmEvent
//

#import "Model.h"

@implementation Model

@synthesize eventTitle, eventNotes, eventUrl;
@synthesize calendar;
@synthesize debug;

NSString * const PMDateChangedNotification = @"PMDateChanged";

- (id)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        debug = YES;
#endif
        
    }
    return self;
}

@end
