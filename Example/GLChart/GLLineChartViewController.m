#import "GLLineChartViewController.h"
#import "GLChartData.h"
#import "GLLineChart.h"

static NSString *const kLineChartCellIdentifier = @"GLLineChartCell";

@interface GLLineChartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GLChartData *chartData;
@property (nonatomic, strong) GLLineChart *lineChart;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GLLineChartViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.title                  = @"折线图表";
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    // 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加子类视图
    [self.view addSubview:self.lineChart];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chartData.xValues = @[@"10:01", @"10:02", @"10:03", @"10:04", @"10:05",
                               @"10:06", @"10:07", @"10:08", @"10:09", @"10:10",
                               @"10:11", @"10:12", @"10:13", @"10:14", @"10:15",
                               @"10:16", @"10:17", @"10:18", @"10:19", @"10:20",
                               @"10:21", @"10:22", @"10:23", @"10:24", @"10:25",
                               @"10:26", @"10:27", @"10:28", @"10:29", @"10:30",
                               @"10:31", @"10:32", @"10:33", @"10:34", @"10:35",
                               @"10:36", @"10:37", @"10:38", @"10:39", @"10:40",
                               @"10:41", @"10:42", @"10:43", @"10:44", @"10:45",
                               @"10:46", @"10:47", @"10:48", @"10:49", @"10:50",
                               @"10:51", @"10:52", @"10:53", @"10:54", @"10:55",
                               @"10:56", @"10:57", @"10:58", @"10:59", @"11:00"];
    
    self.chartData.yValues = @[@{@"color": @"#7CB5EC",
                                 @"value": @[@18, @20, @18, @20, @18,
                                             @20, @18, @20, @18, @20,
                                             @18, @20, @18, @20, @18,
                                             @20, @18, @20, @18, @20,
                                             @18, @20, @18, @20, @18,
                                             @20, @18, @20, @18, @20,
                                             @18, @20, @18, @20, @18,
                                             @20, @18, @20, @18, @20,
                                             @18, @20, @18, @20, @18,
                                             @20, @18, @20, @18, @20,
                                             @18, @20, @18, @20, @18,
                                             @20, @18, @20, @18, @20]},
                               @{@"color": @"#F7A35C",
                                 @"value": @[@8,  @10, @8,  @10, @8,
                                             @10, @8,  @10, @8,  @10,
                                             @8,  @10, @8,  @10, @8,
                                             @10, @8,  @10, @8,  @10,
                                             @8,  @10, @8,  @10, @8,
                                             @10, @8,  @10, @8,  @10,
                                             @8,  @10, @8,  @10, @8,
                                             @10, @8,  @10, @8,  @10,
                                             @8,  @10, @8,  @10, @8,
                                             @10, @8,  @10, @8,  @10,
                                             @8,  @10, @8,  @10, @8,
                                             @10, @8,  @10, @8,  @10]}];
    
    self.lineChart.chartData = self.chartData;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            self.chartData.isFill             = YES;
            self.chartData.visibleRangeMaxNum = 0;
            self.chartData.chartInitDirection = GLChartInitDirectionLeft;
            self.chartData.isEnabledIndicator = NO;
            break;
            
        case 1:
            self.chartData.isFill = NO;
            break;
            
        case 2:
            self.chartData.visibleRangeMaxNum = 30;
            self.chartData.isEnabledIndicator = NO;
            break;
            
        case 3:
            self.chartData.chartInitDirection = GLChartInitDirectionRight;
            break;
            
        case 4:
            self.chartData.visibleRangeMaxNum = 0;
            self.chartData.isEnabledIndicator = YES;
            break;
    }
    
    self.lineChart.chartData = self.chartData;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLineChartCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLineChartCellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"恢复图表默认值";
            break;
            
        case 1:
            cell.textLabel.text = @"去除图表填充色";
            break;
            
        case 2:
            cell.textLabel.text = @"设置每屏显示数";
            break;
            
        case 3:
            cell.textLabel.text = @"设置初始化向右";
            break;
            
        case 4:
            cell.textLabel.text = @"显示图表指标器";
            break;
    }
    
    return cell;
}

#pragma mark - getters and setters

- (GLChartData *)chartData {
    if (_chartData == nil) {
        _chartData = [[GLChartData alloc] init];
    }
    
    return _chartData;
}

- (GLLineChart *)lineChart {
    if (_lineChart == nil) {
        _lineChart = [[GLLineChart alloc] init];
        
        _lineChart.frame = CGRectMake(0.0f, 10.0f, self.view.frame.size.width, 180.0f);
    }
    
    return _lineChart;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.frame          = CGRectMake(0, 200.0f, self.view.frame.size.width, self.view.frame.size.height - 200.0f);
        _tableView.delegate       = self;
        _tableView.dataSource     = self;
        _tableView.rowHeight      = 50.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

@end
