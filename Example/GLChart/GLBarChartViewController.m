#import "GLBarChartViewController.h"
#import "GLChartData.h"
#import "GLBarChart.h"

@interface GLBarChartViewController ()

@property (nonatomic, strong) GLChartData *chartData;
@property (nonatomic, strong) GLBarChart  *barChart;

@end

@implementation GLBarChartViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.title                  = @"柱状图表";
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    // 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加子类视图
    [self.view addSubview:self.barChart];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chartData.xValues = @[@"10:01", @"10:02", @"10:03", @"10:04", @"10:05", @"10:06", @"10:07",
                               @"10:08", @"10:09", @"10:10", @"10:11", @"10:12", @"10:13", @"10:14",
                               @"10:15", @"10:16", @"10:17", @"10:18", @"10:19", @"10:20", @"10:21"];
    
    self.chartData.yValues = @[@[@{@"value": @0,   @"color": @"#7CB5EC"}, @{@"value": @100, @"color": @"#F7A35C"}],
                               @[@{@"value": @10,  @"color": @"#7CB5EC"}, @{@"value": @90,  @"color": @"#F7A35C"}],
                               @[@{@"value": @20,  @"color": @"#7CB5EC"}, @{@"value": @80,  @"color": @"#F7A35C"}],
                               @[@{@"value": @30,  @"color": @"#7CB5EC"}, @{@"value": @70,  @"color": @"#F7A35C"}],
                               @[@{@"value": @40,  @"color": @"#7CB5EC"}, @{@"value": @60,  @"color": @"#F7A35C"}],
                               @[@{@"value": @50,  @"color": @"#7CB5EC"}, @{@"value": @50,  @"color": @"#F7A35C"}],
                               @[@{@"value": @60,  @"color": @"#7CB5EC"}, @{@"value": @40,  @"color": @"#F7A35C"}],
                               @[@{@"value": @70,  @"color": @"#7CB5EC"}, @{@"value": @30,  @"color": @"#F7A35C"}],
                               @[@{@"value": @80,  @"color": @"#7CB5EC"}, @{@"value": @20,  @"color": @"#F7A35C"}],
                               @[@{@"value": @90,  @"color": @"#7CB5EC"}, @{@"value": @10,  @"color": @"#F7A35C"}],
                               @[@{@"value": @100, @"color": @"#7CB5EC"}, @{@"value": @0,   @"color": @"#F7A35C"}],
                               @[@{@"value": @90,  @"color": @"#7CB5EC"}, @{@"value": @10,  @"color": @"#F7A35C"}],
                               @[@{@"value": @80,  @"color": @"#7CB5EC"}, @{@"value": @20,  @"color": @"#F7A35C"}],
                               @[@{@"value": @70,  @"color": @"#7CB5EC"}, @{@"value": @30,  @"color": @"#F7A35C"}],
                               @[@{@"value": @60,  @"color": @"#7CB5EC"}, @{@"value": @40,  @"color": @"#F7A35C"}],
                               @[@{@"value": @50,  @"color": @"#7CB5EC"}, @{@"value": @50,  @"color": @"#F7A35C"}],
                               @[@{@"value": @40,  @"color": @"#7CB5EC"}, @{@"value": @60,  @"color": @"#F7A35C"}],
                               @[@{@"value": @30,  @"color": @"#7CB5EC"}, @{@"value": @70,  @"color": @"#F7A35C"}],
                               @[@{@"value": @20,  @"color": @"#7CB5EC"}, @{@"value": @80,  @"color": @"#F7A35C"}],
                               @[@{@"value": @10,  @"color": @"#7CB5EC"}, @{@"value": @90,  @"color": @"#F7A35C"}],
                               @[@{@"value": @0,   @"color": @"#7CB5EC"}, @{@"value": @100, @"color": @"#F7A35C"}]];
    
    self.barChart.chartData = self.chartData;
}

#pragma mark - getters and setters

- (GLChartData *)chartData {
    if (_chartData == nil) {
        _chartData = [[GLChartData alloc] init];
    }
    
    return _chartData;
}

- (GLBarChart *)barChart {
    if (_barChart == nil) {
        _barChart = [[GLBarChart alloc] init];
        
        _barChart.frame = CGRectMake(0.0f, 10.0f, self.view.frame.size.width, 180.0f);
    }
    
    return _barChart;
}

@end
