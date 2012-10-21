//
//  main.m
//  iTunesSleep
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, char *argv[])
{
    NSString *scriptText = [NSString stringWithFormat:@"set volume output volume 50\n"
                            @"tell application \"iTunes\"\n"
                            @"  set sound volume to 50\n"
                            @"  play\n"
                            @"end tell"];
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:scriptText];
    [script executeAndReturnError:nil];
    return 0;
}
