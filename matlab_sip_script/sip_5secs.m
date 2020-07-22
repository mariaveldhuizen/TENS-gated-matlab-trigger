%Written by Maria G. Veldhuizen 21-07-2020

%script to offset cued sipping of a liquid stimulus (or other
%behavior or perceptual stimulation) from TENS stimuation blocks with a
%duty cycle of 30 seconds on, 30 seconds off, 0.25 ms-duration monophasic
%square wave pulses at 25 Hz

%dependency on Matlab data acquisition toolbox functions,
%nidaq drivers,
%nidaq toolbox for matlab
%see manual for links to products and connection details

%% preparation section
% prepare reading trigger from TENS device
s = daq.createSession('ni');
   try % assign channel and supress warning
        ch = addCounterInputChannel(s,'Dev1','ctr0','EdgeCount');
    catch
    end     
    
%just to be safe, reset the counter
    try % reset counter and suppress error message
        startForeground(s);% seems to reset the counter, unlike resetcounters
    catch
    end

% prepare audiofiles
[r,fs]=audioread('sip.m4a');% load sip cue
pause(.5);
sip = audioplayer(r, fs);
[r2,fs]=audioread('ready.m4a');% load ready cue (to indicate start of sipping block)
pause(.5);
ready = audioplayer(r2, fs);

%pre-allocate variables
TENSblocktime = zeros(1,6);
sipblocktime=zeros(1,6);
siptime = zeros(1,55);
k=1;

% wait for user input
h = warndlg('When you are ready, hit ok','Wait...');
uiwait(h);

%% experiment run section    
timecont=clock;%log start time of run

for j = 1:10
    %% wait for stimulator to start
    disp('waiting for TENS to start');
    start=inputSingleScan(s);%need to have one first to get the counter started right
        while start == 0
            start=inputSingleScan(s);
        end
    display('TENS started');
    TENSblocktime(j) = etime(clock,timecont);% log time
    pause(29); % wait for tVNS block to end
    play(ready);% play sound to signal get ready
    display('sip block started');
    sipblocktime(j) = etime(clock,timecont); % log time
    pause(3);   
        for i = 1:5
                play(sip);%play sound to signal to swallow
                siptime(k) = etime(clock,timecont); % log time
                k=k+1;
                pause(5);% give time to swallow
         end
    try % reset counter and suppress error message
        startForeground(s);
    catch
    end   
end
display('end of experiment');