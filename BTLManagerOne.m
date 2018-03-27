#import "BTLManagerOne.h"
#import "BTLMacros.h"
#import "BTLWrite.h"
#import "BTLDatas.h"
#import "BTLManager.h"

@implementation BTLManagerOne

- (void)initWatch:(NSString*) watchName childId:(NSString*)childId
{
    self.m_sChildId = childId;
    self.m_sWatchName = watchName;
}

- (void)initReconnectValue
{
    m_iReconnectType = 0;
}

- (void)connectBTLPeripheral {
    
    self.m_pBTLPeripheral = [[BTLPeripheral alloc] init];
    [self.m_pBTLPeripheral initBTLManagerOne:self];
    [self.m_pBTLPeripheral initBTLProtocolDelegate];
}

- (void)connect:(CBPeripheral *) peripheral
{
    if(self.m_pBTLPeripheral)
    {
        [self.m_pBTLPeripheral didConnectPeripheral:peripheral];
    }
}

- (void)connectRecord {
    
    self.m_pRecordBTLServiceCharacter = [[BTLServiceCharacter alloc]init];
    [self.m_pRecordBTLServiceCharacter initBtLManagerOne:self];
    [self.m_pRecordBTLServiceCharacter initBTLPeripheral:self.m_pBTLPeripheral];
    [self.m_pRecordBTLServiceCharacter initBTLProtocolDelegate];
    [self.m_pRecordBTLServiceCharacter initType:E_SC_RECORD];
    [self.m_pRecordBTLServiceCharacter initUUIDWithService:BTL_RECORD_SERVICE_UUID Characteristics:BTL_RECORD_CHARACTERISTIC_UUID];
    [self.m_pRecordBTLServiceCharacter discoverServices];
}

- (void)connectVoice {
    
    self.m_pVoiceBTLServiceCharacter = [[BTLServiceCharacter alloc]init];
    [self.m_pVoiceBTLServiceCharacter initBtLManagerOne:self];
    [self.m_pVoiceBTLServiceCharacter initBTLPeripheral:self.m_pBTLPeripheral];
    [self.m_pVoiceBTLServiceCharacter initBTLProtocolDelegate];
    [self.m_pVoiceBTLServiceCharacter initType:E_SC_VOICE];
    [self.m_pVoiceBTLServiceCharacter initUUIDWithService:BTL_VOICE_SERVICE_UUID Characteristics:BTL_VOICE_CHARACTERISTIC_UUID];
    [self.m_pVoiceBTLServiceCharacter discoverServices];
}

- (void)connectDistance {
    
    self.m_pDistanceBTLServiceCharacter = [[BTLServiceCharacter alloc]init];
    [self.m_pDistanceBTLServiceCharacter initBtLManagerOne:self];
    [self.m_pDistanceBTLServiceCharacter initBTLPeripheral:self.m_pBTLPeripheral];
    [self.m_pDistanceBTLServiceCharacter initBTLProtocolDelegate];
    [self.m_pDistanceBTLServiceCharacter initType:E_SC_DISTANCE];
    [self.m_pDistanceBTLServiceCharacter initUUIDWithService:BTL_DISTANCE_SERVICE_UUID Characteristics:BTL_DISTANCE_CHARACTERISTIC_UUID];
    [self.m_pDistanceBTLServiceCharacter discoverServices];
}

- (void)connectWatchLog {
    
    self.m_pWatchLogBTLServiceCharacter = [[BTLServiceCharacter alloc]init];
    [self.m_pWatchLogBTLServiceCharacter initBtLManagerOne:self];
    [self.m_pWatchLogBTLServiceCharacter initBTLPeripheral:self.m_pBTLPeripheral];
    [self.m_pWatchLogBTLServiceCharacter initBTLProtocolDelegate];
    [self.m_pWatchLogBTLServiceCharacter initType:E_SC_WATCHLOG];
    [self.m_pWatchLogBTLServiceCharacter initUUIDWithService:BTL_WATCHLOG_SERVICE_UUID Characteristics:BTL_WATCHLOG_CHARACTERISTIC_UUID];
    [self.m_pWatchLogBTLServiceCharacter discoverServices];
}

- (BOOL)isPeripheralConnect {
    return self.m_pBTLPeripheral.m_bIsConnect;
}

- (void)connectBTLServiceCharacter:(NSUInteger)_type {
    
    if ([self isPeripheralConnect] == NO) {
        [EUtil showToastWithTitle:@"正在连接手表，请稍等。"];
        m_iReconnectType = m_iReconnectType * 10 + _type;
    }
    else {
        NSLog(@"===== BTL: 开始连接Service、Character ======");
        switch (_type) {
                
            case E_SC_RECORD:
                [self connectRecord];
                break;
                
            case E_SC_VOICE:
                [self connectVoice];
                break;
                
            case E_SC_DISTANCE:
                [self connectDistance];
                break;
                
            case E_SC_WATCHLOG:
                [self connectWatchLog];
                
            default:
                break;
        }
    }
}

- (void)disConnectBTLServiceCharacter:(NSUInteger)_type {
    
    BTLServiceCharacter* m_pBTLServiceCharacter = nil;
    switch (_type) {
            
        case E_SC_RECORD:
            m_pBTLServiceCharacter = self.m_pRecordBTLServiceCharacter;
            break;
            
        case E_SC_VOICE:
            m_pBTLServiceCharacter = self.m_pVoiceBTLServiceCharacter;
            break;
            
        case E_SC_DISTANCE:
            m_pBTLServiceCharacter = self.m_pWatchLogBTLServiceCharacter;
            break;
            
        default:
            break;
    }
    
    //删除协议
    [m_pBTLServiceCharacter removeBTLProtocolDelegate];
    
    //删除计时器//
    if ([m_pBTLServiceCharacter getIsConnect]) {
        [m_pBTLServiceCharacter removeTimer];
    }
    
    NSLog(@"===== BTL: 退出界面，取消协议 ======");
}

- (void)reconnect
{
    if (m_iReconnectType <= 0)
        return;
    
    m_iReconnectType = 0;
    
    NSInteger type = m_iReconnectType / 10;
    NSInteger caseType = m_iReconnectType % 10;
    
    if (type == 1)
    {
        [self connectBTLServiceCharacter:caseType];
    }
    else if (type == 2) {
        [self disConnectBTLServiceCharacter:caseType];
    }
    else {
    }
}

- (void)cancelPeripheralConnection
{
    //如果连接上
    if ([self isPeripheralConnect] == YES)
    {
        [[[BTLManager shardInstance] getBTLCentralManager] cancelPeripheralConnection:self.m_pBTLPeripheral.m_pCBPeripheral];
    }

    [self.m_pBTLPeripheral removeBTLProtocolDelegate];
}

- (void)writeVoice:(NSUInteger)_value {
    
    CBPeripheral * _peripheral = self.m_pBTLPeripheral.m_pCBPeripheral;
    CBCharacteristic * _characteristic = [self.m_pVoiceBTLServiceCharacter getCharacteristic];
    
    if (_value == 0) {
        
        [BTLWrite closeVoice:_peripheral characteristic:_characteristic];
    }
    else {
        [BTLWrite openVoice:_peripheral characteristic:_characteristic];
    }
}

- (void)writeRecord:(short)protocol a2itype:(Byte)a2itype times:(Byte)times relationship:(NSInteger)relationship mobile:(NSString *)mobile
{
    CBPeripheral * _peripheral = self.m_pBTLPeripheral.m_pCBPeripheral;
    CBCharacteristic * _characteristic = [self.m_pRecordBTLServiceCharacter getCharacteristic];
    
    NSData* datas = [BTLDatas prepareRecordDataWithProtocol:protocol a2itype:a2itype times:times relationship:relationship mobile:mobile];
    
    [BTLWrite writeRecord:_peripheral characteristic:_characteristic datas:datas];
}

- (void)writeDelRecord:(short)protocol a2itype:(Byte)a2itype mobile:(NSString *)mobile
{
    CBPeripheral * _peripheral = self.m_pBTLPeripheral.m_pCBPeripheral;
    CBCharacteristic * _characteristic = [self.m_pRecordBTLServiceCharacter getCharacteristic];
    
    NSData* datas = [BTLDatas prepareDelRecordDataWithProtocol:protocol a2itype:a2itype mobile:mobile];
    
    [BTLWrite writeRecord:_peripheral characteristic:_characteristic datas:datas];
}

-(void)writeWatchLog:(short)protocol
{
    CBPeripheral * _peripheral = self.m_pBTLPeripheral.m_pCBPeripheral;
    CBCharacteristic * _characteristic = [self.m_pWatchLogBTLServiceCharacter getCharacteristic];
    [BTLWrite writeWatchLog:_peripheral characteristic:_characteristic protocol:protocol];
}

-(void)readValue
{
    CBPeripheral * _peripheral = self.m_pBTLPeripheral.m_pCBPeripheral;
    CBCharacteristic * _characteristic = [self.m_pWatchLogBTLServiceCharacter getCharacteristic];
    [_peripheral readValueForCharacteristic:_characteristic];
}

- (void)dealloc {
    ;
}


@end