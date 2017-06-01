#import "GLLineChartViewController.h"
#import "GLChartData.h"
#import "GLLineChart.h"

static NSString *const kHeWeatherAPI   = @"https://api.heweather.com/x3/weather?cityid=CN101210106&key=162e571b6ea446dba9c99d6d4cbbdf18";
static NSString *const kCellIdentifier = @"GLCellIdentifier";

@interface GLLineChartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSURLRequest  *request;
@property (nonatomic, strong) NSMutableData *receivedData;

@property (nonatomic, strong) GLChartData   *chartData;
@property (nonatomic, strong) GLLineChart   *lineChart;
@property (nonatomic, strong) UITableView   *tableView;

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
    
    [self requestData];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.receivedData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *data          = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:nil];
    NSArray      *dailyForecast = data[@"HeWeather data service 3.0"][0][@"daily_forecast"];
    
    NSMutableArray *max  = [NSMutableArray array];
    NSMutableArray *min  = [NSMutableArray array];
    NSMutableArray *date = [NSMutableArray array];
    
    for (NSDictionary *item in dailyForecast) {
        [max addObject:item[@"tmp"][@"max"]];
        [min addObject:item[@"tmp"][@"min"]];
        
        [date addObject:[item[@"date"] substringFromIndex:5]];
    }
    
    self.chartData.xValues   = date;
    self.chartData.yValues   = @[@{
        @"value": max,
        @"color": @"#F7A35C",
        @"alias": @"最高温度"
    }, @{
        @"value": min,
        @"color": @"#7CB5EC",
        @"alias": @"最低温度"
    }];
    
    self.chartData.xStep     = 7;
    self.chartData.lineWidth = 1.0f;
    
    self.lineChart.chartData = self.chartData;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            self.chartData.dots                 = @[];
            self.chartData.lines                = @[];
            self.chartData.isFill               = YES;
            self.chartData.visibleRangeMaxNum   = 0;
            self.chartData.chartInitDirection   = GLChartInitDirectionLeft;
            self.chartData.isEnabledIndicator   = NO;
            self.chartData.isYAxisStartFromZero = YES;
            
            [self requestData];
            break;
            
        case 1:
            self.chartData.isFill = NO;
            break;
            
        case 2:
            self.chartData.visibleRangeMaxNum = 5;
            self.chartData.isEnabledIndicator = NO;
            break;
            
        case 3:
            self.chartData.chartInitDirection = GLChartInitDirectionRight;
            break;
        
        case 4:
            self.chartData.isYAxisStartFromZero = NO;
            break;
            
        case 5:
            self.chartData.visibleRangeMaxNum = 0;
            self.chartData.isEnabledIndicator = YES;
            break;
            
        case 6:
            self.chartData.dots = @[@{@"value"   : @[self.chartData.xValues[1], self.chartData.xValues[2]],
                                      @"color"   : @"#F7A35C",
                                      @"size"    : @8.0f,
                                      @"position": @1.0f},
                                    @{@"value"   : @[self.chartData.xValues[4], self.chartData.xValues[5]],
                                      @"color"   : @"#7CB5EC",
                                      @"size"    : @8.0f,
                                      @"position": @0.5f}];
            break;
            
        case 7:
            self.chartData.lines = @[@{@"value": @[self.chartData.xValues[1], self.chartData.xValues[2]],
                                       @"color": @"#F7A35C",
                                       @"width": @1.0f},
                                     @{@"value": @[self.chartData.xValues[4], self.chartData.xValues[5]],
                                       @"color": @"#7CB5EC",
                                       @"width": @1.0f}];
            break;
            
        case 8:
            self.chartData.dots    = @[];
            self.chartData.lines   = @[];
            self.chartData.yValues = @[];
            break;
    }
    
    self.lineChart.chartData = self.chartData;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
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
            cell.textLabel.text = @"设置起始值非零";
            break;
            
        case 5:
            cell.textLabel.text = @"显示图表指标器";
            break;
            
        case 6:
            cell.textLabel.text = @"显示圆点标记";
            break;
            
        case 7:
            cell.textLabel.text = @"显示线条标记";
            break;
            
        case 8:
            cell.textLabel.text = @"清空所有数据";
            break;
    }
    
    return cell;
}

#pragma mark - private methods

- (void)requestData {
    [NSURLConnection connectionWithRequest:self.request delegate:self];
}

#pragma mark - getters and setters

- (NSURLRequest *)request {
    if (_request == nil) {
        _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kHeWeatherAPI]];
    }
    
    return _request;
}

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
        
        _tableView.frame          = CGRectMake(0, 200.0f, self.view.frame.size.width, self.view.frame.size.height - 264.0f);
        _tableView.delegate       = self;
        _tableView.dataSource     = self;
        _tableView.rowHeight      = 50.0f;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

@end
