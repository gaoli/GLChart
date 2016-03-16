#import "GLBarChartViewController.h"
#import "GLChartData.h"
#import "GLBarChart.h"

static NSString *const kHeWeatherAPI   = @"https://api.heweather.com/x3/weather?cityid=CN101210106&key=162e571b6ea446dba9c99d6d4cbbdf18";
static NSString *const kCellIdentifier = @"GLCellIdentifier";

@interface GLBarChartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSURLRequest  *request;
@property (nonatomic, strong) NSMutableData *receivedData;

@property (nonatomic, strong) GLChartData *chartData;
@property (nonatomic, strong) GLBarChart  *barChart;
@property (nonatomic, strong) UITableView *tableView;

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
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSURLConnection connectionWithRequest:self.request delegate:self];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *data          = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:nil];
    NSArray      *dailyForecast = data[@"HeWeather data service 3.0"][0][@"daily_forecast"];
    
    NSMutableArray *tmp  = [NSMutableArray array];
    NSMutableArray *date = [NSMutableArray array];
    
    for (NSDictionary *item in dailyForecast) {
        CGFloat max = [item[@"tmp"][@"max"] floatValue];
        CGFloat min = [item[@"tmp"][@"min"] floatValue];
        
        [tmp addObject:@[@{@"value": @(min),       @"color": @"#7CB5EC"},
                         @{@"value": @(max - min), @"color": @"#F7A35C"}]];
        
        [date addObject:[item[@"date"] substringFromIndex:5]];
    }
    
    self.chartData.xValues   = date;
    self.chartData.yValues   = tmp;
    self.chartData.barWidth  = 25.0f;
    self.chartData.barMargin = 9.0f;
    
    self.barChart.chartData = self.chartData;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            self.chartData.chartInitDirection = GLChartInitDirectionLeft;
            break;
            
        case 1:
            self.chartData.chartInitDirection = GLChartInitDirectionRight;
            break;
    }
    
    self.barChart.chartData = self.chartData;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
            cell.textLabel.text = @"设置初始化向右";
            break;
    }
    
    return cell;
}


#pragma mark - getters and setters

- (NSURLRequest *)request {
    if (_request == nil) {
        _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kHeWeatherAPI]];
    }
    
    return _request;
}

- (NSMutableData *)receivedData {
    if (_receivedData == nil) {
        _receivedData = [NSMutableData data];
    }
    
    return _receivedData;
}

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
