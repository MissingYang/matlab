clc
clear
close all

speed = 50.2;
flag_run = 0;
flag_CW = 1;

message.head = 'E9';
message.addr = '01';
message.len = '06';
message.W = '57';
message.J = '4A';
message.speed = dec2hex(speed * 10 , 4);
message.run  = dec2hex(flag_run,2);
message.CW = dec2hex(flag_CW,2);
 
addr = hex2dec('01');
len = hex2dec('06');
W = hex2dec('57');
J = hex2dec('4a');
speed_H = hex2dec(message.speed(1:2));
speed_L = hex2dec(message.speed(3:4));
e = hex2dec(message.run);
f = hex2dec(message.CW );

fcs =  bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(bitxor(addr,len),W),J),speed_H),speed_L),e),f);



obj1 = instrfind('Type', 'serial', 'Port', 'COM5', 'Tag', '');

if isempty(obj1)
    obj1 = serial('COM5');
else
    fclose(obj1);
    obj1 = obj1(1);
end

set(obj1, 'BaudRate', 1200);
set(obj1, 'Parity', 'even');
fopen(obj1);

fwrite(obj1, [hex2dec('E9') addr len W J speed_H speed_L e f fcs], 'uint8');
