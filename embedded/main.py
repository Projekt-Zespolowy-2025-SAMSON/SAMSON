import serial

# po podlaczeniu sprawdzic i wpisac port
ser = serial.Serial('COM6', baudrate=115200, timeout=1)

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

while True:
    if ser.read(1) == b'\xAA':
        data = ser.read(4)
        if len(data) == 4:
            msb, lsb, crc_lsb, crc_msb = data
            val = (msb << 8) | lsb
            crc_recived = (crc_msb << 8) | crc_lsb
            if crc_recived == crc16([msb, lsb]):
                print(f"ADC Value: {val}")
            else:
                print("CRC Error!")


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

# while True:
#     data = ser.read(9)
#     if len(data) == 9:
#         if data[0] == 0xAA and data[8] == 0x55:
#             crc = calculate_crc8(data[1:7])
#             if crc == data[7]:
#                 ch1 = data[1] | (data[2] << 8)
#                 ch2 = data[3] | (data[4] << 8)
#                 ch3 = data[5] | (data[6] << 8)
#                 print(f"CH1: {ch1}, CH2: {ch2}, CH3: {ch3}")
#             else:
#                 print("Blad: CRC")
#         else:
#             print("Blad: start_byte lub stop_byte")
