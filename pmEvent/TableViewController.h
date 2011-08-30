//
//  TableViewController.h
//  pmEvent
//

#import <Foundation/Foundation.h>

@interface TableViewController : NSObject
{
    NSDate *dateOfEvents;
}

@property (copy) NSDate *dateOfEvents;

- (NSArray*)events;

@end
