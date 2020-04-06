#import "Combinator.h"

@implementation Combinator
- (NSNumber*)chechChooseFromArray:(NSArray <NSNumber*>*)array {
    NSInteger cards = [array[0] integerValue];
    NSInteger desks = [array[1] integerValue];
    
    for (long i = 0; i < desks; i++) {
        if ([self binnominalCoefficent:desks with:i] == cards)
            return [NSNumber numberWithInteger:i];
    }
    
    return nil;
}

- (long)binnominalCoefficent:(long)n with:(long)k {
    long r = 1;
    long d;
    if (k > n) return 0;
    for (d = 1; d <= k; d++)
    {
       r *= n--;
       r /= d;
    }
    return r;
}



@end
