#import "PolynomialConverter.h"

@implementation PolynomialConverter

- (NSString*)convertToStringFrom:(NSArray <NSNumber*>*)numbers {
    if (!numbers || ([numbers count] == 0) ) {
        return nil;
    }

    NSMutableString* resultMutableStr = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < [numbers count]; i++) {
        NSNumber *number = numbers[i];
        NSInteger value = (NSInteger)[number integerValue];
        if(!value) {
            continue;
        }
        NSString *sign = value < 0 ? @"-" : @"+";
        NSInteger level = [numbers count] - i - 1;
        value = labs(value);
        [resultMutableStr appendFormat:@" %@ %ldx^%ld", sign, value, level];
    }

    [resultMutableStr replaceOccurrencesOfString:@"x^1" withString:@"x" options:NSLiteralSearch range:NSMakeRange(0, [resultMutableStr length])];
    [resultMutableStr replaceOccurrencesOfString:@"x^0" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [resultMutableStr length])];
    [resultMutableStr replaceOccurrencesOfString:@"1x" withString:@"x" options:NSLiteralSearch range:NSMakeRange(0, [resultMutableStr length])];

    if ([resultMutableStr hasPrefix:@" + "]) {
        [resultMutableStr deleteCharactersInRange:NSMakeRange(0, 3)];
    } else {
        [resultMutableStr replaceCharactersInRange:NSMakeRange(0, 3) withString:@"-"];
    }
    
    return [resultMutableStr copy];
}

@end
