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

# while True:
#     if ser.read(1) == b'\xAA':
#         data = ser.read(4)
#         if len(data) == 4:
#             msb, lsb, crc_lsb, crc_msb = data
#             val = (msb << 8) | lsb
#             crc_recived = (crc_msb << 8) | crc_lsb
#             if crc_recived == crc16([msb, lsb]):
#                 print(f"ADC Value: {val}")
#             else:
#                 print("CRC Error!")

time_now = datetime.now().strftime("%d%m%H%M%S")
start = time.time()
while True:
# for i in range(10000):
    data = ser.read(9)
    # print(f"data: {data}")
    if len(data) == 9:
        if data[0] == 0xAA:
            ch1 = (data[1] << 8) | data[2]
            ch2 = (data[3] << 8) | data[4]
            ch3 = (data[5] << 8) | data[6]
            crc_recived = (data[7] << 8) | data[8]
            crc_calculated = crc16([data[1], data[2], data[3], data[4], data[5], data[6]])
            # print(f"recived: {crc_recived}, calculated: {crc_calculated}")
            if crc_recived == crc_calculated:
                print(f"adc1: {ch1},   adc2: {ch2},    adc3: {ch3}")
                # print(time_now)
                with open(f'EMG_{time_now}.txt', 'a') as f:
                    f.write(f'{ch1};{ch2};{ch3}\n')
                odebrane += 1
            else:
                print("crc error")

        else:
            print("Blad: start_byte lub stop_byte")
print(f"time:{time.time() - start}    odebrane:{odebrane}")

# import time

# start = time.time()
# print("hello")
# end = time.time()
# print(end - start)


# def calculate_crc8(data):
#     crc = 0
#     for byte in data:
#         crc ^= byte
#         for _ in range(8):
#             if crc & 0x80:
#                 crc = (crc << 1) ^ 0x07
#             else:
#                 crc <<= 1
#             crc &= 0xFF
#     return crc


            # crc = crc16(data[1:6])
            # print(f"crc: {crc},    data[7]: {data[7] | (data[8] << 8)}")
            # if crc == data[7] | (data[8] << 8):
            #     ch1 = data[1] | (data[2] << 8)
            #     ch2 = data[3] | (data[4] << 8)
            #     ch3 = data[5] | (data[6] << 8)
            #     print(f"CH1: {ch1}, CH2: {ch2}, CH3: {ch3}")
            # else:
            #     print("Blad: CRC")