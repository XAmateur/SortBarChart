//
//  ViewController.h
//  SortBarChart
//
//  Created by amateur on 11/15/16.
//  Copyright © 2016 amateur. All rights reserved.
//

#import "ViewController.h"
#import "NSMutableArray+CustomSort.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UIView *barChart;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSortArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)sort:(UIBarButtonItem *)sender
{
    self.semaphore = dispatch_semaphore_create(0);
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.0005 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        dispatch_semaphore_signal(weakSelf.semaphore);
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] - nowTime;
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"时间 :%4f",interval];
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        switch (self.segment.selectedSegmentIndex) {
            case 0:
                [self quickSort];
                break;
            case 1:
                [self bubbleSort];
                break;
                
            default:
                break;
        }
        [self invalidateTimer];
    });
}

- (void)initSortArray
{
    self.array = [NSMutableArray array];
    
    for (int i=0;i<170;i++)
    {
        int value = 20 + arc4random_uniform(400 - 20);
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*2, 415, 1, -value)];
        view.backgroundColor = [UIColor orangeColor];
        [self.barChart addSubview:view];
        [self.array addObject:view];
    }
}

- (void)bubbleSort
{
    [self.array bubbleSortCompared:^NSComparisonResult(id obj1, id obj2) {
        return [self resusltWithObj1:obj1 obj2:obj2];
    } didExchange:^(id obj1, id obj2) {
        
        [self exchangePositionWithBarOne:obj1 andBarTwo:obj2];
    }];
}

- (void)quickSort
{
    [self.array quickSortCompared:^NSComparisonResult(id obj1, id obj2) {
        return [self resusltWithObj1:obj1 obj2:obj2];
    } didExchange:^(id obj1, id obj2) {
        [self exchangePositionWithBarOne:obj1 andBarTwo:obj2];
        
    }];
}

- (IBAction)reset:(UIBarButtonItem *)sender
{
    [self invalidateTimer];
    
    for (UIView *view in self.array) {
        [view removeFromSuperview];
    }
    
    [self.array removeAllObjects];
    [self initSortArray];
}

- (NSComparisonResult )resusltWithObj1:(UIView *)obj1 obj2:(UIView *)obj2
{
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    CGFloat height1 = CGRectGetHeight(obj1.frame);
    CGFloat height2 = CGRectGetHeight(obj2.frame);
    
    if (height1 == height2) {
        return NSOrderedSame;
    }
    
    return height1 < height2 ? NSOrderedAscending : NSOrderedDescending;
}

- (void)exchangePositionWithBarOne:(UIView *)barOne andBarTwo:(UIView *)barTwo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frameOne = barOne.frame;
        CGRect frameTwo = barTwo.frame;
        frameOne.origin.x = barTwo.frame.origin.x;
        frameTwo.origin.x = barOne.frame.origin.x;
        barOne.frame = frameOne;
        barTwo.frame = frameTwo;
    });
}

- (void)invalidateTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.semaphore = nil;
}

@end
