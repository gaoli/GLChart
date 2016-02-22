#import "GLBar.h"
#import "UIColor+Helper.h"

@interface GLBar ()

@property (nonatomic, assign) CGFloat grade;

@end

@implementation GLBar

- (id)init {
    self = [super init];
    
    if (self) {
        self.grade = 0.0f;
    }
    
    return self;
}

#pragma mark - private methods

- (void)drawBarWithGrade:(CGFloat)grade color:(UIColor *)color {
    UIBezierPath *path  = [[UIBezierPath alloc] init];
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    
    [path moveToPoint   :CGPointMake(w / 2.0f, h * (1.0f - self.grade))];
    [path addLineToPoint:CGPointMake(w / 2.0f, h * (1.0f - self.grade - grade))];
    
    self.grade += grade;
    
    layer.path        = path.CGPath;
    layer.lineWidth   = w;
    layer.strokeColor = color.CGColor;
    
    [self.layer addSublayer:layer];
}

#pragma mark - getters and setters

- (void)setData:(NSArray *)data {
    _data = data;
    
    for (NSDictionary *item in data) {
        CGFloat  grade = [item[@"grade"] floatValue];
        UIColor *color = [UIColor colorWithHexString:item[@"color"]];
        
        if (grade == 0.0f || color == nil) {
            continue;
        }
        
        [self drawBarWithGrade:grade color:color];
    }
}

@end
