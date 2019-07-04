% Pulse DigOut on Specific Value from Serial
% Author & Date: Hyrum L. Sessions 14 Sept 2009
% Copyright: Blackrock Microsystems
% Workfile: DigInOut.m
% Purpose: Read serial data from the NSP and compare with a
% predefined value. If it is the same, generate a
% pulse on dout4
%
% This script will read data from the NSP for a period of 30 seconds. It
% is waiting for a character 'd' on the Serial I/O port of the NSP. If
% received it will generate a 10ms pulse on Digital Output 4
% initialize
close all;
clear variables;
run_time = 5; % run for time
value = 100; % value to look for (100 = d)
channel_in = 151; % AIN1 = 129; serial port = channel 152; digital = 151
channel_out = 1; % dout 1 = 1, 2 = 2, 3 = 3, 4 = 4
t_col = tic; % collection time
previous_t_test =0;
cbmex('open'); % open library
% for chanNum=33:128
%     cbmex('mask',chanNum , 0);
% end
cbmex('trialconfig',1,'absolute')
% cbmex('trialconfig', 1, 'double', 'noevent', 'continuous', 200000); 
% cbmex( 'trialconfig' , 1 , 'double' , 'continuous' , 35000 , 'event' , 35000 , 'absolute' )
% cbmex('trialconfig',1); % start library collecting data
start = tic();
while (run_time > toc(t_col))
    pause(0.05); % check every 50ms
    t_test = toc(t_col);
%     tic
    [spike_data, ~, continuousData] = cbmex('trialdata', 1); % read data
%     toc
    %% Analog chanel
%     contChan=[continuousData{:, 1}]==channel_in;
%     found = [continuousData{contChan, 3}]>31000;
    %% Serial 
%     found = (value == spike_data{channel_in, 3});
    %% Digital in
    found = ~isempty(spike_data{channel_in, 3});
    if (0 ~= sum(found))
        t_test - previous_t_test
%         cbmex('digitalout', channel_out, 1);
%         pause(0.01);
%         cbmex('digitalout', channel_out, 0);
    end
    previous_t_test=t_test;
end
% close the app
cbmex('close');