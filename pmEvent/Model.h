//
//  Model.h
//  pmEvent
//

#import <Foundation/Foundation.h>
#import <CalendarStore/CalendarStore.h>

@interface Model : NSObject
{
    NSString        *eventTitle;
    NSString        *eventNotes;
    NSString        *eventUrl;
    CalCalendar     *calendar;
    BOOL            debug;
}

@property (copy) NSString *eventTitle;
@property (copy) NSString *eventNotes;
@property (copy) NSString *eventUrl;
@property (retain) CalCalendar *calendar;
@property (assign) BOOL debug;

@end
