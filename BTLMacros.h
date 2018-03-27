#import "ARMacros.h"


#define BTL_1METER_RSSI 56
#define BTL_READ_RSSI_INTERVAL 1
#define BTL_WARN_INTERVAL 40
#define BTL_QUEUE_COUNT 6


#ifdef BTL_RSSI
    #define BTL_BEYOND_NEAR 75
    #define BTL_BEYOND_FAR 95
#else
    #define BTL_BEYOND_NEAR 10
    #define BTL_BEYOND_FAR 50
#endif



//录音
#define BTL_RECORD_SERVICE_UUID           @"000018B0-0000-1000-8000-00805F9B34FB"
#define BTL_RECORD_CHARACTERISTIC_UUID    @"00002AA0-0000-1000-8000-00805F9B34FB"

//Watch Log
#define BTL_WATCHLOG_SERVICE_UUID           @"000018B0-0000-1000-8000-00805F9B34FB"
#define BTL_WATCHLOG_CHARACTERISTIC_UUID    @"00002AA0-0000-1000-8000-00805F9B34FB"

//响音
#define BTL_VOICE_SERVICE_UUID           @"00001803-0000-1000-8000-00805F9B34FB"
#define BTL_VOICE_CHARACTERISTIC_UUID    @"00002A06-0000-1000-8000-00805F9B34FB"

//超距离
#define BTL_DISTANCE_SERVICE_UUID           @"00001804-0000-1000-8000-00805F9B34FB"
#define BTL_DISTANCE_CHARACTERISTIC_UUID    @"00002A07-0000-1000-8000-00805F9B34FB"


enum E_BTL_STATE
{
    E_BTL_STATE_INVAILD = 1,
    E_BTL_STATE_CONNECTING,
    E_BTL_STATE_DIDCONNECT,
    E_BTL_STATE_CONNECTING_CHARACTER,
    E_BTL_STATE_DISCONNECT,
    E_BTL_STATE_FAILCONNECT,
};

enum E_SERVICE_CHARACTER
{
    E_SC_RECORD = 1,
    E_SC_VOICE,
    E_SC_DISTANCE,
    E_SC_WATCHLOG,
};

typedef enum
{
    A2I_HANDLE_NONE,
    A2I_HANDLE_TRAINING,
    A2I_HANDLE_TRAINING_CANCEL,//sohan ATM20150627010 Add cancel training function
    A2I_HANDLE_ENROLL_DELE,
    A2I_HANDLE_TRAINING_FAILED,//sohan ATM20150627011 Disable training or tigger during trigger or training
    A2I_HANDLE_MAX//sohan ATM20150627010 Add cancel training function
}a2i_handle_type;

typedef enum
{
    A2I_ENROLL_DELE_FAILED_NONE,
    A2I_ENROLL_DELE_FAILED_ID_INVAILD,
    A2I_ENROLL_DELE_FAILED_ENROLL_NOT_EXIT,
    A2I_ENROLL_DELE_FAILED_MAX
}a2i_enroll_dele_failed_type;

typedef enum
{
    A2I_TRAINING_FAILED_NONE,
    A2I_TRAINING_FAILED_INTRIGGER,
    A2I_TRAINING_FAILED_OUTOFTIME,
    A2I_TRAINING_FAILED_TOOSAME,
    A2I_TRAINING_FAILED_NO_ENROLLMENTID, //已经不能录音，需要放弃
    A2I_TRAINING_FAILED_MAX
}a2i_training_failed_type;