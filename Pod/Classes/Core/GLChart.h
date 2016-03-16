#import <UIKit/UIKit.h>

@class GLChartData;

@interface GLChart : UIView

@property (nonatomic, strong) GLChartData    *chartData;
@property (nonatomic, strong) UIView         *chartView;
@property (nonatomic, strong) UIScrollView   *container;
@property (nonatomic, strong) NSMutableArray *xAxisLabels;
@property (nonatomic, strong) NSMutableArray *yAxisLabels;

- (void)parseData;

- (void)checkData;

- (void)initChart;

- (void)drawChart;

- (void)loadComponents;

- (void)createXAxisLabels;

- (void)createYAxisLabels;

@end
