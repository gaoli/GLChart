#import <UIKit/UIKit.h>

@class GLChartData;

@interface GLChart : UIView

@property (nonatomic, strong) GLChartData  *chartData;
@property (nonatomic, strong) UIScrollView *chartView;

@end
