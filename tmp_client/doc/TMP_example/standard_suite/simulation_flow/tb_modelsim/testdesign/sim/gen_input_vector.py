import os
import sys
import random
#############################input config######################
##input style :
#inc: increase     like 1 2 3 4 
#dec: decrease     like 4 3 2 1
#rdm: random       like 2 9 1 7
#clk: clock        will be 0 1 0 1 0 1 0 1 0 1 0 1
#cen: clocken      will be 1 1 1 1 1 1 1 1 1 1 1 1
#rst: reset        will be 1 1 1 0 0 0 0 0 0 0 0 0
##
##style: (width in binary, signal name, signal style)
out_file = 'test_vector.in'
total_lines = 100
input_dict = {
               'in_1': [4,'DA','inc', '0'],
               'in_2': [4,'DB','inc', '0'],
               'in_3': [1,'CLK','clk', '0']
              };
#you can input some more input signal but do use the name as in_6, in7(do not skip any number).
#the maximum input signal number is 50.
#############################digital translate######################
class Dig_tran:
    def __init__(self):
        """ set environment , initial value

            define translate functions
        """
        self.base = [str(x) for x in range(10)] + [ chr(x) for x in range(ord('A'),ord('A')+6)]

    # bin2dec
    def bin2dec(self, string_num):
        return str(int(string_num, 2))

    # hex2dec
    def hex2dec(self, string_num):
        return str(int(string_num.upper(), 16))

    # dec2bin
    def dec2bin(self, string_num):
        num = int(string_num)
        mid = []
        if num == 0:
            return '0'
        while True:
            if num == 0: 
                break
            num,rem = divmod(num, 2)
            mid.append(self.base[rem])
        return ''.join([str(x) for x in mid[::-1]])

    # dec2hex
    def dec2hex(self, string_num):
        num = int(string_num)
        mid = []
        while True:
            if num == 0: break
            num,rem = divmod(num, 16)
            mid.append(self.base[rem])
        return ''.join([str(x) for x in mid[::-1]])

    # hex2tobin
    def hex2bin(self, string_num):
        return dec2bin(hex2dec(string_num.upper()))

    # bin2hex
    def bin2hex(self, string_num):
        return dec2hex(bin2dec(string_num))

#############################script start######################
top_dir = os.getcwd()
my_trans = Dig_tran()
#----------------------------define line gene-------------------
def generate_signal_str(line_int, signal_list):
    """ define the signal input vector
    
        return signal vector or False
    """
    if not isinstance(line_int, int):
        print '>>>Error: Wrong input type get for line_int, should be a string.'
        return False
    if not isinstance(signal_list, list):
        print '>>>Error: Wrong input type get for signal_list, should be a list.'
        return False
    line_num = line_int
    signal_width = signal_list[0]
    signal_name  = signal_list[1]
    signal_type  = signal_list[2]
    signal_value = signal_list[3]
    if signal_type not in ['inc', 'dec', 'clk', 'rst', 'cen','rdm']:
        print '>>>Error: Wrong input signal type find'
        return False
    min_bin_str = '0' * signal_width
    max_bin_str = '1' * signal_width
    min_dec_str = my_trans.bin2dec(min_bin_str)
    max_dec_str = my_trans.bin2dec(max_bin_str)
    min_dec_int = int(min_dec_str)
    max_dec_int = int(max_dec_str)
    def_int = int(signal_value)
    if def_int not in range(max_dec_int + 1):
        print '>>>Error: Default start value not in the range of 0..%d' % max_dec_int
        return False
    if signal_type == 'inc':
        if line_num == 0:
            current_value_dec_int = def_int
        elif (line_num % 2) == 0:
            current_value_dec_int = def_int + 1
        else:
            current_value_dec_int = def_int
        if current_value_dec_int > max_dec_int:
            current_value_dec_int = min_dec_int
        current_value_dec_str = str(current_value_dec_int)
        return current_value_dec_str
    if signal_type == 'dec':
        if line_num == 0:
            current_value_dec_int = def_int
        elif(line_num % 2) == 0:
            current_value_dec_int = def_int - 1
        else:
            current_value_dec_int = def_int
        if current_value_dec_int < min_dec_int:
            current_value_dec_int = max_dec_int
        current_value_dec_str = str(current_value_dec_int)
        return current_value_dec_str
    if signal_type == 'rdm':
        if line_num == 0:
            current_value_dec_int = def_int
        elif(line_num % 2) == 0:
            current_value_dec_int = random.randrange(min_dec_int, max_dec_int)
        else:
            current_value_dec_int = def_int
        if current_value_dec_int < min_dec_int:
            current_value_dec_int = max_dec_int
        current_value_dec_str = str(current_value_dec_int)
        return current_value_dec_str
    if signal_type == 'clk':
        if line_num == 0:
            current_value_dec_int = def_int
        else:
            current_value_dec_int = def_int + 1
        if current_value_dec_int > max_dec_int:
            current_value_dec_int = min_dec_int
        current_value_dec_str = str(current_value_dec_int)
        return current_value_dec_str
    if signal_type == 'rst':
        if line_num > 3:
            current_value_dec_int = 0
        else:
            current_value_dec_int = def_int
        current_value_dec_str = str(current_value_dec_int)
        return current_value_dec_str
    if signal_type == 'cen':
        current_value_dec_int = def_int
        current_value_dec_str = str(current_value_dec_int)
        return current_value_dec_str
    return False

max_input_num = 0
for index in range(50):
    input_num = index + 1
    try:
        input_signal = 'in_' + str(input_num)
        signal_name = input_dict[input_signal][1]
    except KeyError:
        print '>>>Total input signal is %d' % index
        break
    max_input_num = input_num

write_file = open(out_file, 'w')
print >>  write_file, '//The Input Vector Order Is:'
signal_list = []
for index in range(max_input_num):
    index += 1
    input_signal = 'in_' + str(index)
    signal_name = input_dict[input_signal][1]
    signal_list.append(signal_name)
signal_str = '//' + ','.join(signal_list)
print >> write_file, signal_str
    
for line in range(total_lines):
    signal_list = []
    for index in range(max_input_num):
        index += 1
        input_signal = 'in_' + str(index)
        current_signal_dec_str = generate_signal_str(line, input_dict[input_signal])
        if not current_signal_dec_str:
            print '>>>Error in generate line:%d' % (line + 1)
            sys.exit()
        input_dict[input_signal][3] = current_signal_dec_str
        current_signal_bin_str = my_trans.dec2bin(current_signal_dec_str)
        current_signal_width = int(input_dict[input_signal][0])
        format_str = r'%%0%dd' % current_signal_width
        format_current_signal_bin_str = format_str % int(current_signal_bin_str)
        signal_list.append(format_current_signal_bin_str)
    line_str = '_'.join(signal_list)
    print >> write_file , line_str
write_file.close()

raw_input('press to leave')