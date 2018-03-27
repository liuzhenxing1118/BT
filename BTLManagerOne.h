#import <Foundation/Foundation.h>
#import "BTLPeripheral.h"
#import "BTLServiceCharacter.h"
#import "BTLMacros.h"


@interface BTLManagerOne :NSObject
{
    NSInteger m_iReconnectType;
}

//连接手表
@property(strong, nonatomic, getter=getBTLPeripheral) BTLPeripheral *m_pBTLPeripheral;

//录音
@property(strong, nonatomic) BTLServiceCharacter *m_pRecordBTLServiceCharacter;

//响音
@property(strong, nonatomic) BTLServiceCharacter *m_pVoiceBTLServiceCharacter;

//超距离
@property(strong, nonatomic) BTLServiceCharacter *m_pDistanceBTLServiceCharacter;

//WATCH LOG
@property(strong, nonatomic) BTLServiceCharacter *m_pWatchLogBTLServiceCharacter;


@property(strong, nonatomic, getter=getChildId) NSString* m_sChildId;
@property(strong, nonatomic, getter=getWatchName) NSString* m_sWatchName;


- (void)initWatch:(NSString*) watchName childId:(NSString*)childId;

- (void)initReconnectValue;

- (void)connectBTLPeripheral;

- (void)connectBTLServiceCharacter:(NSUInteger)_type;

- (void)disConnectBTLServiceCharacter:(NSUInteger)_type;

- (void)reconnect;

- (void)connect:(CBPeripheral *) peripheral;

- (void)cancelPeripheralConnection;

- (void)writeVoice:(NSUInteger)_value;

- (void)writeRecord:(short)protocol a2itype:(Byte)a2itype times:(Byte)times relationship:(NSInteger)relationship mobile:(NSString *)mobile;

- (void)writeDelRecord:(short)protocol a2itype:(Byte)a2itype mobile:(NSString *)mobile;

-(void)writeWatchLog:(short)protocol;

-(void)readValue;

@end