//
//  main.m
//  Shutdown
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, char *argv[])
{
    NSString *scriptText = [NSString stringWithFormat:@"tell application \"Finder\" to shut down"];
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptText];
    [script executeAndReturnError:nil];
    [script release];
    return 0;
}
