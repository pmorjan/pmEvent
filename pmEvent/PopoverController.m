//
//  PopoverController.m
//  pmEvent
//

#import "PopoverController.h"
#import "DateCategory.h"

@implementation PopoverController

- (id)init {
    self = [super init];
    if (self) {
        popover = [[NSPopover alloc]init];
        alarmArray = [[NSMutableArray alloc]initWithCapacity:3];
    }
    return self;
}

- (void)awakeFromNib
{
    [popover setContentViewController:self];
    [popover setBehavior:NSPopoverBehaviorSemitransient];
    [popover setAnimates:NO];
    [popover setAppearance:NSPopoverAppearanceMinimal];
    [popover setDelegate:self];    
    [eventArrayController addObserver:self 
                           forKeyPath:@"selectionIndexes" 
                              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial
                              context:nil];
    [popoverAlarmTableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];
}

- (void)togglePopover:(id)sender
{
    if ([popover isShown]) {
        [popover close];
    } else {
        [popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];
         // is there a better way to prevent NSPopover beeing first responder?
        [[sender window] makeFirstResponder:sender];
    }
}

- (void)closePopover:(id)sender
{
    if ([popover isShown]) {
        [popover close];
    }
}

- (void)updateAlarmArray
{
    if ([[eventArrayController selectedObjects] count] > 0) {
        [alarmArray removeAllObjects];
        CalEvent *event = [[eventArrayController selectedObjects]objectAtIndex:0];
        for(CalAlarm *alarm in [event alarms]) {
            NSString *str = @"";
            if ([alarm absoluteTrigger] != nil) {
                if ([event.startDate isEqualToDate:alarm.absoluteTrigger]) {
                    str = @"on date";
                } else {
                    str = [alarm.absoluteTrigger stringValue];
                }
            } else {
                int i = [alarm relativeTrigger];
                if (i != 0) {
                    NSString *beforeAfter = i > 0 ? @"after" : @"before";
                    int m = (int)abs(i/60.0);
                    if (m < 60) {
                        str = [NSString stringWithFormat:@"%d minutes %@", m, beforeAfter];
                    } else if (m < 60 * 24) {
                        str = [NSString stringWithFormat:@"%.1f hours %@", m/60.0, beforeAfter];                    
                    } else if (m < 60 * 24 * 365) {
                        str = [NSString stringWithFormat:@"%.1f days %@",  m/(24 * 60.0), beforeAfter];                    
                    }
                }
            }
            [alarmArray addObject:str];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualTo:@"selectionIndexes"]) {
        [self updateAlarmArray];
        [popoverAlarmTableView reloadData];
    } 
}

#pragma mark -
#pragma mark table View
- (int)numberOfRowsInTableView:(NSTableView *)tv
{
    return (int)[alarmArray count];
}

- (id)tableView:(NSTableView *)tv 
        objectValueForTableColumn:(NSTableColumn *)tableColumn
        row:(int)row
{
    return [alarmArray objectAtIndex:row];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
}

- (void)dealloc 
{
    [eventArrayController removeObserver:self forKeyPath:@"selectionIndexes"];
    [alarmArray release];
    [super dealloc];
}
@end
