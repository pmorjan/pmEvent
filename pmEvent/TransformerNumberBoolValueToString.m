//
//  ValueTransformerYesNo.m
//  pmEvent
//


#import "TransformerNumberBoolValueToString.h"


@implementation TransformerNumberBoolValueToString

+ (Class)transformedValueClass
{
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    return [value intValue] == 1 ? @"yes" : @"no";
}

@end
