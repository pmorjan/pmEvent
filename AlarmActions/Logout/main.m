//
//  main.m
//  Logout
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, char *argv[])
{
    NSString *scriptText = [NSString stringWithFormat:@"tell application \"System Events\" to log out"];
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptText];
    [script executeAndReturnError:nil];
    [script release];
    return 0;
}