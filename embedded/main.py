import serial
import time
from datetime import datetime

# po podlaczeniu sprawdzic i wpisac port
ser = serial.Serial('COM7', baudrate=230400, timeout=1)
odebrane = 0

def calculate_crc8(data):
    crc = 0x00
    for b in data:
        crc ^= b
        for _ in range(8):
            crc = (crc << 1) ^ 0x07 if (crc & 0x80) else (crc << 1)
        crc &= 0xFF
    return crc

def crc16(data):
    crc = 0xFFFF
    for byte in data:
        crc ^= byte
        for _ in range(8):
            if crc & 0x0001:
                crc >>= 1
                crc ^= 0xA001
            else:
                crc >>= 1
    return crc


time_now = datetime.now().strftime("%d%m%H%M%S")
start = time.time()
while True:
# for i in range(10000):
    data = ser.read(9)
    # print(f"data: {data}")
    if len(data) == 9:
        if data[0] == 0xAA:
            ch1 = (data[1] << 8) | data[2]
            # with open(f'EMG2_{time_now}.txt', 'a') as f:
            #     f.write(f'{ch1}\n')
            ch2 = (data[3] << 8) | data[4]
            ch3 = (data[5] << 8) | data[6]
            crc_recived = (data[7] << 8) | data[8]
            crc_calculated = crc16([data[1], data[2], data[3], data[4], data[5], data[6]])
            print(f"recived: {crc_recived}, calculated: {crc_calculated}")
            if crc_recived == crc_calculated:
                print(f"adc1: {ch1},   adc2: {ch2},    adc3: {ch3}")
                # print(time_now)
                with open(f'EMG_{time_now}.txt', 'a') as f:
                    # f.write(f'{ch1};{ch2};{ch3}\n')
                    f.write(f'{ch2}\n')
                odebrane += 1
            else:
                print("crc error")
        elif data[0] == 0xCC:
            time_now = datetime.now().strftime("%d%m%H%M%S")
            print(f"Ustawiono nowy czas")
        elif data[0] == 0x99:
            print(f"Zakonczono plik")
        else:
            print("Blad: start_byte")
print(f"time:{time.time() - start}    odebrane:{odebrane}")


# while True:
# # for i in range(10000):
#     data = ser.read(9)
#     # print(f"data: {data}")
#     if len(data) == 9:
#         # if data[0] == 0xAA:
#             ch1 = (data[1] << 8) | data[2]
#             ch2 = (data[3] << 8) | data[4]
#             ch3 = (data[5] << 8) | data[6]
#             crc_recived = (data[7] << 8) | data[8]
#             crc_calculated = crc16([data[1], data[2], data[3], data[4], data[5], data[6]])
#             # print(f"recived: {crc_recived}, calculated: {crc_calculated}")
#             if crc_recived == crc_calculated:
#                 print(f"adc1: {ch1},   adc2: {ch2},    adc3: {ch3}")
#                 # print(time_now)
#                 with open(f'EMG_{time_now}.txt', 'a') as f:
#                     f.write(f'{ch1};{ch2};{ch3}\n')
#                 odebrane += 1
#             else:
#                 print("crc error")

#         # else:
#             # print("Blad: start_byte lub stop_byte")



# while True:
# # for i in range(10000):
#     data = ser.read(9)
#     # print(f"data: {data}")
#     if len(data) == 9:
#         if data[0] == 0xAA:
#             ch1 = (data[1] << 8) | data[2]
#             # with open(f'EMG2_{time_now}.txt', 'a') as f:
#             #     f.write(f'{ch1}\n')
#             ch2 = (data[3] << 8) | data[4]
#             ch3 = (data[5] << 8) | data[6]
#             crc_recived = (data[7] << 8) | data[8]
#             crc_calculated = crc16([data[1], data[2], data[3], data[4], data[5], data[6]])
#             print(f"recived: {crc_recived}, calculated: {crc_calculated}")
#             if crc_recived == crc_calculated:
#                 print(f"adc1: {ch1},   adc2: {ch2},    adc3: {ch3}")
#                 # print(time_now)
#                 with open(f'EMG_{time_now}.txt', 'a') as f:
#                     f.write(f'{ch1};{ch2};{ch3}\n')
#                 odebrane += 1
#             else:
#                 print("crc error")

#         else:
#             print("Blad: start_byte")