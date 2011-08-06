//
//  Model.h
//  pmEvent
//


#import <Foundation/Foundation.h>

@interface Model : NSObject
{
    NSString        *eventTitle;
    NSString        *eventNotes;
    NSString        *eventUrl;
    CalCalendar     *calendar;
}

@property (copy) NSString *eventTitle;
@property (copy) NSString *eventNotes;
@property (copy) NSString *eventUrl;
@property (retain) CalCalendar *calendar;

@end
