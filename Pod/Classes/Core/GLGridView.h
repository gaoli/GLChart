#import <UIKit/UIKit.h>

@interface GLGridView : UIView

@property (nonatomic, assign) NSUInteger  step;
@property (nonatomic,   copy) NSArray    *data;

@property (nonatomic, assign) CGFloat     min;
@property (nonatomic, assign) CGFloat     max;

@property (nonatomic, assign) CGFloat     lineWidth;
@property (nonatomic, strong) UIColor    *lineColor;

@property (nonatomic, strong) UIFont     *labelFont;
@property (nonatomic, strong) UIColor    *labelColor;

@end
