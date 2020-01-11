//
//  NSOperationTableVC.m
//  LearniOS
//
//  Created by JKFunny on 2020/1/10.
//  Copyright © 2020 JKFunny. All rights reserved.
//

#import "NSOperationTableVC.h"
#import "MyOperation.h"

@interface NSOperationTableVC ()

@property (nonatomic, copy)NSArray *dataSource;
@property (nonatomic, strong)dispatch_semaphore_t semaphore;
@property (nonatomic, assign)int ticketCount;
@property (nonatomic, strong)NSLock *lock;

@end

@implementation NSOperationTableVC

/*
 NSOperation、NSOperationQueue是基于GCD的封装，完全面向对象
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSOperation相关";
    self.dataSource = @[
        @"1、单独使用NSOperation",
        @"2、InvocationOpe配合队列使用",
        @"3、BlockOpe配合队列使用",
        @"4、添加依赖",
        @"5、售票-非线程安全",
        @"6、售票-NSLock保证线程安全",
        @"7、售票-semaphore保证线程安全",
        @"8、售票-synchronized保证线程安全"
    ];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.ticketCount = 50;
    if (indexPath.row == 0) {
        [self single_operation];
    } else if (indexPath.row == 1) {
        [self invocation_with_queue];
    } else if (indexPath.row == 2) {
        [self block_with_queue];
    } else if (indexPath.row == 3) {
        [self operation_dependency];
    } else if (indexPath.row == 4) {
        [self sale_ticket_unsafe];
    } else if (indexPath.row == 5) {
        [self sale_ticket_lock_safe];
    } else if (indexPath.row == 6) {
        [self sale_ticket_semaphore_safe];
    } else if (indexPath.row == 7) {
        [self sale_ticket_synchronized_safe];
    }
}

#pragma mark - 1、单独使用NSOperation
- (void)single_operation {
    // NSOperation的子类NSInvocationOperation、NSBlockOperation，添加任务需要主动调用start方法才能执行。在start内部会调用main方法执行任务。
    // 也可以继承NSOperation，并重新实现该类的main函数
    
    // 1、NSInvocationOperation，单独使用不会开辟新线程
    NSInvocationOperation *invocOpe = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(single_test:) object:@{@"value": @"single_invocation"}];
    [invocOpe start];
    
    // 2、MyOperation(它要执行的任务在其.m的main中实现)
    MyOperation *myOpe = [[MyOperation alloc] init];
    [myOpe start];
    
    // 3、NSBlockOperation
    NSBlockOperation *blockOpe1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"111---blockOpe---%@", [NSThread currentThread]);
    }];
    [blockOpe1 start];
    
    // blockOperation追加任务后，任务总数大于1，会主动开启新线程并发执行。
    // 注：追加的任务不一定在新线程，非追加的任务也不一定在当前线程；执行顺序不确定
    NSBlockOperation *blockOpe2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"222---blockOpe---%@", [NSThread currentThread]);
    }];
    [blockOpe2 addExecutionBlock:^{
        NSLog(@"addExe111---%@", [NSThread currentThread]);
    }];
    [blockOpe2 addExecutionBlock:^{
        NSLog(@"addExe222---%@", [NSThread currentThread]);
    }];
    [blockOpe2 start];
}

- (void)single_test:(NSDictionary *)param {
    NSLog(@"%@---%@", param, [NSThread currentThread]);
}


/*
 GCD队列：
    串行队列：create & 主队列
    并发队列：create & global
 
 NSOperationQueue:
    主队列：[NSOperationQueue mainQueue] 和GCD的主队列一样
    非主队列：[[NSOperationQueue alloc] init]比较特殊，同时具备串行和并发的功能。默认为并发。
            通过设置最大并发数maxConcurrentOperationCount，可以修改串行/并发
 
     maxConcurrentOperationCount:
        1: 串行队列（串行执行所有任务，但是可能开辟多个新线程，不同任务在不同线程中串行执行）
        0: 不会执行任务
        大于1: 并发队列
        默认为-1: 表示最大并发数不限，为并发队列
    
    [queue setSuspended:YES]; 将正在执行的任务执行完成之后，暂停后续任务；可以恢复
    [queue setSuspended:NO];  继续执行任务
    [queue cancelAllOperations]; 取消所有任务，不可恢复
 */
#pragma mark - 2、InvocationOperation配合队列
- (void)invocation_with_queue {
    // 1、创建操作，封装任务
    NSInvocationOperation *ope1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocation_queue_action:) object:@"111"];
    NSInvocationOperation *ope2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocation_queue_action:) object:@"222"];
    NSInvocationOperation *ope3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocation_queue_action:) object:@"333"];
    
    // 2、创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 3、将任务添加到队列中，会开辟新线程，多个任务在多个线程并发执行
    // 注意，不能将同一个任务添加到队列中，否则会报错 [NSOperationQueue addOperation:]: operation is already enqueued on a queue
    [queue addOperation:ope1];
    [queue addOperation:ope2];
    [queue addOperation:ope3];
}

- (void)invocation_queue_action:(NSString *)str {
    NSLog(@"%@---%@", str, [NSThread currentThread]);
}

#pragma mark - 3、BlockOperation配合队列
- (void)block_with_queue {
    // 1、创建任务
    NSBlockOperation *blockOpe1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"111---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *blockOpe2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"222---%@", [NSThread currentThread]);
    }];
    NSBlockOperation *blockOpe3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"333---%@", [NSThread currentThread]);
    }];
    // 追加任务
    [blockOpe3 addExecutionBlock:^{
        NSLog(@"add---%@", [NSThread currentThread]);
    }];
    
    // 2、创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 4;
    // 3、将任务添加到队列中，多个任务在不同线程并发执行。所有任务执行顺序不确定
    [queue addOperation:blockOpe1];
    [queue addOperation:blockOpe2];
    [queue addOperation:blockOpe3];
    
    // 队列中直接添加任务
    [queue addOperationWithBlock:^{
        NSLog(@"queue_add_ope---%@", [NSThread currentThread]);
    }];
}


#pragma mark - 4、添加依赖
- (void)operation_dependency {
    NSOperationQueue *queu1 = [[NSOperationQueue alloc] init];
    NSOperationQueue *queu2 = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"111--%@", [NSThread currentThread]);
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"222--%@", [NSThread currentThread]);
        }
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"333--%@", [NSThread currentThread]);
        }
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            NSLog(@"444--%@", [NSThread currentThread]);
        }
    }];
    
    // 添加依赖关系，可以跨队列添加
    [op1 addDependency:op3];
    [op1 addDependency:op4];
    [op2 addDependency:op4];
    
    [queu1 addOperation:op1];
    [queu1 addOperation:op2];
    [queu2 addOperation:op3];
    [queu2 addOperation:op4];
    
    // 任务完成添加监听：不是op3执行完立即调用，也不一定跟op3在同一线程中
    op3.completionBlock = ^{
        NSLog(@"op333---completion---%@", [NSThread currentThread]);
    };
    op4.completionBlock = ^{
        NSLog(@"op444---completion---%@", [NSThread currentThread]);
    };
}

#pragma mark - 5、售票-非线程安全
- (void)sale_ticket_unsafe {
    NSLog(@"start---%@", [NSThread currentThread]);
    
    // 两个队列当作售票的两个窗口
    dispatch_queue_t queue1 = dispatch_queue_create("ticket_queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("ticket_queue2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue1, ^{
        [self saleTicketUnsafe];
    });
    
    dispatch_async(queue2, ^{
        [self saleTicketUnsafe];
    });
}

- (void)saleTicketUnsafe {
    while (1) {
        if (self.ticketCount > 0) {
            self.ticketCount--;
            NSLog(@"剩余：%d---%@", self.ticketCount, [NSThread currentThread]);
        } else {
            NSLog(@"票卖完了：%d---%@", self.ticketCount, [NSThread currentThread]);
            break;
        }
    }
}

#pragma mark - 6、售票-NSLock保证线程安全
- (void)sale_ticket_lock_safe {
    NSLog(@"start---%@", [NSThread currentThread]);
    self.lock = [[NSLock alloc] init];
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *ope1 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicketLock];
    }];
    NSBlockOperation *ope2 = [NSBlockOperation blockOperationWithBlock:^{
        [self saleTicketLock];
    }];
    
    [queue1 addOperation:ope1];
    [queue2 addOperation:ope2];
}

- (void)saleTicketLock {
    while (1) {
        [self.lock lock];
        if (self.ticketCount > 0) {
            self.ticketCount--;
            NSLog(@"剩余：%d---%@", self.ticketCount, [NSThread currentThread]);
            [self.lock unlock];
        } else {
            NSLog(@"票卖完了：%d---%@", self.ticketCount, [NSThread currentThread]);
            [self.lock unlock];
            break;
        }
    }
}

#pragma mark - 7、售票-semaphore保证线程安全
- (void)sale_ticket_semaphore_safe {
    NSLog(@"start---%@", [NSThread currentThread]);
    self.semaphore = dispatch_semaphore_create(1);
    
    dispatch_queue_t queue1 = dispatch_queue_create("semaphore_queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("semaphore_queue2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue1, ^{
        [self saleTicketSemaphore];
    });
    
    dispatch_async(queue2, ^{
        [self saleTicketSemaphore];
    });
}

- (void)saleTicketSemaphore {
    while (1) {
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        if (self.ticketCount > 0) {
            self.ticketCount--;
            NSLog(@"剩余：%d---%@", self.ticketCount, [NSThread currentThread]);
            dispatch_semaphore_signal(self.semaphore);
        } else {
            dispatch_semaphore_signal(self.semaphore);
            NSLog(@"票卖完了：%d---%@", self.ticketCount, [NSThread currentThread]);
            break;
        }
    }
}

#pragma mark - 8、售票-synchronized保证线程安全
- (void)sale_ticket_synchronized_safe {
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saleTicketSynchronized) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saleTicketSynchronized) object:nil];
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}

- (void)saleTicketSynchronized {
    while (1) {
        @synchronized (self) {
            if (self.ticketCount > 0) {
                self.ticketCount--;
                NSLog(@"剩余：%d---%@", self.ticketCount, [NSThread currentThread]);
            } else {
                NSLog(@"票卖完了：%d---%@", self.ticketCount, [NSThread currentThread]);
                break;
            }
        }
    }
}

@end
