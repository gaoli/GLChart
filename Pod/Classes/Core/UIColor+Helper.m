#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0f
                           green:((rgbValue & 0xFF00)   >> 8)  / 255.0f
                            blue:(rgbValue & 0xFF)             / 255.0f
                           alpha:1.0];
}

@end
