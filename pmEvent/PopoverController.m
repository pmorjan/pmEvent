//
//  PopoverController.m
//  pmEvent
//

#import "PopoverController.h"
#import "DateCategory.h"
#import "CalendarEvent.h"

@implementation PopoverController
@synthesize alarmArray;

- (id)init 
{
    self = [super init];
    if (self) {
        popover = [[NSPopover alloc]init];
        alarmArray = [[NSArray alloc]init];
    }
    return self;
}

- (void)awakeFromNib
{
    popover.contentViewController = self;
    popover.behavior   = NSPopoverBehaviorSemitransient;
    popover.animates   = NO;
    popover.appearance = NSPopoverAppearanceMinimal;
    popover.delegate   = self;    
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object 
                        change:(NSDictionary *)change context:(void *)context
{
    if (object == eventArrayController) {
        if ([keyPath isEqualTo:@"selectionIndexes"]) {
            // selection in eventTableView has changed
            if ([[eventArrayController selectedObjects] count] > 0) {
                self.alarmArray = [CalendarEvent descriptionOfAlarmsOfEvent:[[eventArrayController selectedObjects]objectAtIndex:0]];
            }
            [popoverAlarmTableView reloadData];
        } 
    }
}

#pragma mark -
#pragma mark Table View Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv
{
    return [alarmArray count];
}

- (id)tableView:(NSTableView *)tv 
        objectValueForTableColumn:(NSTableColumn *)tableColumn
        row:(NSInteger)row
{
    return [alarmArray objectAtIndex:row];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
}

#pragma mark -

- (void)dealloc 
{
    [eventArrayController removeObserver:self forKeyPath:@"selectionIndexes"];
    [alarmArray release];
    [super dealloc];
}
@end
