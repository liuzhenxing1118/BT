#import "BTLManager.h"
#import "BTLManagerOne.h"
#import "ARMacros.h"

@implementation BTLManager

+ (BTLManager *)shardInstance
{
    static BTLManager *_staticBTLManager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        _staticBTLManager = [[BTLManager alloc] init];
    });
    return _staticBTLManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.m_pBTLReceive = nil;
        self.m_pBTLProtocol = nil;
        self.m_pBTLCentralManager = nil;
        self.m_pBTLScan = nil;
        
        self.m_bIsLock = YES;
        self.m_bIsRunning = NO;
        [self initVariate];
        
        [self initBTLReceive];
        [self initBTLScan];
    }
    return self;
}

- (void)initVariate
{
    self.m_bIsSupportBT4 = YES;
    self.m_pManagerOneArray = NSMutableArray.new;
}

-(void)run
{
#ifdef BTL_IF_NEED
    if (self.m_bIsLock == YES)
        return;
#endif
    
    //如果已经启动过
    if (self.m_bIsRunning == YES)
        return;
    
    self.m_bIsRunning = YES;
    
    [self initProtocol];
    [self initBTLCentralManager];
    
#ifdef BTL_IF_NEED
    [self newWatchList];
#endif
}

- (void)initBTLReceive
{
    self.m_pBTLReceive = [[BTLReceive alloc]init];
    [self.m_pBTLReceive initVariate];
}

- (void) initProtocol
{
    self.m_pBTLProtocol = [[BTLProtocol alloc]init];
    [self.m_pBTLProtocol initVariate];
}

- (void) initBTLCentralManager
{
    self.m_pBTLCentralManager = [[BTLCentralManager alloc] init];
    [self.m_pBTLCentralManager initCentralManager];
}

- (void) initBTLScan
{
    self.m_pBTLScan = [[BTLScan alloc] init];
    [self.m_pBTLScan initVariate];
}

- (void)initBTLManagerOne:(NSString*)watchName childId:(NSString*)childId
{
    BTLManagerOne* managerOne = [[BTLManagerOne alloc]init];
    
    [managerOne initWatch:watchName childId:childId];
    [managerOne initReconnectValue];
    [managerOne connectBTLPeripheral];
    
    [self.m_pManagerOneArray addObject:managerOne];
}

- (void)addWatchInfo:(NSInteger)addIndex
{
    NSMutableArray *watchArray = [DataManager shardInstance].mChildWatchArray;
    NSMutableArray *childArray = [DataManager shardInstance].mChildArray;
    
    //index 越界
    if (addIndex >= watchArray.count || addIndex >= childArray.count) {
        assert(0);
        return;
    }
    
    ChildListModel* childInfo = childArray[addIndex];
    ChildWatchModel* watchInfo = watchArray[addIndex];
    NSString* watchName = [watchInfo getDeviceBleName];
    
    //已经解绑
    BOOL isValid = [self isValidWatch:watchName];
    if (isValid == NO)
        return;
    
    //已经存在，不重复添加
    if ([self isWatchExist:childInfo.mChildId])
        return;
    
    [self initBTLManagerOne:watchName childId:childInfo.mChildId];
}

- (BTLManagerOne *)ManagerOneByWatchName:(NSString*) name
{
    for(BTLManagerOne* managerOne in self.m_pManagerOneArray)
    {
        if([[managerOne getWatchName] isEqualToString:name])
            return managerOne;
    }
    return nil;
}

- (void)removeWatch:(NSInteger)removeIndex
{
    if (removeIndex >= self.m_pManagerOneArray.count)
        return;
    
    //取消手表连接
    [self removeManagerOne:removeIndex];
    
    [self.m_pManagerOneArray removeObjectAtIndex:removeIndex];
}

- (void)removeManagerOne:(NSInteger)removeIndex
{
    if (removeIndex >= self.m_pManagerOneArray.count)
        return;
    
    //取消手表连接
    [self.m_pManagerOneArray[removeIndex] cancelPeripheralConnection];
}

-(BOOL)isWatchExist:(NSString*)childId
{
    for (int i = 0; i < self.m_pManagerOneArray.count; i++) {
        
        BTLManagerOne* manager = self.m_pManagerOneArray[i];
        if ([[manager getChildId] isEqualToString:childId])
            return YES;
    }
    return NO;
}

- (void)scan
{
    if (self.m_pBTLScan)
        [self.m_pBTLScan scan];
}


#pragma mark - function
- (BTLManagerOne*)getCurManagerOne {
    
    NSInteger index = [self getCurManagerOneIndex];
    if (index >= self.m_pManagerOneArray.count)
        return nil;
    
    return [self.m_pManagerOneArray objectAtIndex:index];
}

- (NSInteger)getCurManagerOneIndex
{
    NSString*childId = [DataManager shardInstance].mCurrentChild.mChildId;
    
    for (int i = 0; i < self.m_pManagerOneArray.count; i++) {
        
        BTLManagerOne* manager = self.m_pManagerOneArray[i];
        if ([[manager getChildId] isEqualToString:childId])
            return i;
    }
    return 0;
}

-(void)newWatchList
{
#ifdef BTL_IF_NEED
    if (self.m_bIsLock == YES)
        return;
#endif
    
    [self setIsHaveWatch:YES];
    [self checkWatch];
}

- (void)checkWatch
{
    if ([self isCheck] == NO)
        return;
    
    //获取有效表个数
    NSInteger newWatchCount = [self getValidWatchCount];
    
    //有新添加
    if (newWatchCount > self.m_pManagerOneArray.count) {
        
        [self add];
    }
    //有解绑或取消关注
    else if (newWatchCount < self.m_pManagerOneArray.count) {
        
        [self remove];
    }
    else {
    }
}

- (BOOL)isCheck
{
    //蓝牙是否开启//
    if (self.m_bIsPoweredOn == NO)
        return NO;
    
    //该设备不支持蓝牙4.0
    if (self.m_bIsSupportBT4 == NO)
        return NO;
    
    //还没有手表数据
    if (self.m_bIsHaveWatch == NO)
        return NO;
    
    return YES;
}

- (void)add
{
    NSMutableArray* childArray = [DataManager shardInstance].mChildArray;
    NSMutableArray *addArray = NSMutableArray.new;
    
    for (int i = 0; i < childArray.count; i++) {
        
        ChildListModel* childInfo = childArray[i];
        BOOL isExist = [self isWatchExist:childInfo.mChildId];
        if (!isExist) {
            //add index
            [addArray addObject: [NSNumber numberWithInt:i]];
        }
    }
    
    if (addArray.count <= 0)
        return;
    
    //addWatch
    for (int i = 0; i < addArray.count; i++)
        [self addWatchInfo:[addArray[i] integerValue]];
    
    //添加后，尝试连接
    [self scan];
}

- (void)remove
{
    NSMutableArray* watchArray = [DataManager shardInstance].mChildWatchArray;
    NSMutableArray* childArray = [DataManager shardInstance].mChildArray;
    NSMutableArray* managerArray = self.m_pManagerOneArray;
    NSMutableArray *removeArray = NSMutableArray.new;
    
    //manager
    for (int i = 0; i < managerArray.count; i++) {
        
        BOOL isExist = NO;
        
        //child
        BTLManagerOne* managerOne = managerArray[i];
        for (int j = 0; j < childArray.count; j++) {
            
            ChildListModel* childInfo = childArray[j];
            ChildWatchModel* watchInfo = watchArray[j];
            
            
            BOOL isChildIdEqual = [childInfo.mChildId isEqualToString: [managerOne getChildId]];
            if (isChildIdEqual == YES) {
                
                //找到，判断手表是否被解绑过（IMEI为“”）
                //解绑：isExist = NO; 未解绑：isExist = YES;
                isExist = [self isValidWatch:[watchInfo getDeviceBleName]];
            }
        }
        
        //未找到(取消关注)：isExist = NO;
        //解绑/未解绑
        if (isExist == NO) {
            [removeArray addObject: [NSNumber numberWithInt:i]];
        }
    }
    
    if (removeArray.count <= 0)
        return;
    
    //reomveWatch
    for (int i = 0; i < removeArray.count; i++)
        [self removeWatch:[removeArray[i] integerValue]];
}

- (NSInteger)getValidWatchCount
{
    NSInteger watchCount = 0;
    NSMutableArray *watchArray = [DataManager shardInstance].mChildWatchArray;

    for (int i = 0; i < watchArray.count; i++) {
        
        ChildWatchModel* watchInfo = watchArray[i];
        
        //如果是未绑定的手表
        NSString* watchName = [watchInfo getDeviceBleName];
        if ([self isValidWatch:watchName])
            watchCount++;
    }
    return watchCount;
}

- (BOOL)isValidWatch:(NSString*)watchName
{
    //如果是未绑定的手表
    if (watchName == nil || [watchName isEqualToString:@""] || [watchName isEqualToString:@"KIDO"])
        return NO;
    else
        return YES;
}

- (BOOL)getIsCurWatchValid
{
    NSString* watchName = [[DataManager shardInstance].mCurrentWatch getDeviceBleName];
    return [self isValidWatch:watchName];
}

- (void)destory
{
    //删除手表，断开蓝牙连接
    for (int i = 0; i < self.m_pManagerOneArray.count; i++)
        [self removeManagerOne:i];
    
    [self.m_pManagerOneArray removeAllObjects];
    
    //停止扫描
    [self.m_pBTLScan stop];
    [self.m_pBTLScan initVariate];
    
    //delegate = nil
    [self.m_pBTLProtocol initVariate];
    [self.m_pBTLReceive initVariate];
    
    //init
    [self initVariate];
}

@end