//
//  main.m
//  Sleep
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, char *argv[])
{
    NSString *scriptText = [NSString stringWithFormat:@"tell application \"Finder\" to sleep"];
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptText];
    [script executeAndReturnError:nil];
    return 0;
}
