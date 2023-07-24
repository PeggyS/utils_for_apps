function data = read_eeg_data()
% read in Brainvision data
% output: data is a struct of the eeg data, channels, events

% data structure:
%   comments: 'Original file: 20120517_inv_wrist_flexors_active_rc_epochs_450ms.seg' (or .eeg)
%       srate: 5000				sampling rate in Hz
%      nbchan: 8				number of channels recorded
%    chanlocs: [1x8 struct]		array of the channel names (strings)
%        pnts: 2250				number of data points in a trial
%        data: [8x90000 single]	data matrix (1 row for each data collection channel)
%      trials: 40				number of trials
%        xmin: -0.0500
%        xmax: 17.9998
%       event: [1x80 struct]	struct array with fields: 
%									latency			starting data point number for the event
%									type			'R128' events are the start of trials we want
%									code
%									duration
%									urevent
%									epoch
%     urevent: [1x120 struct]
%         ref: 'common'

disp('Choose a BrainVision .vhdr file')
[fname, pname] = uigetfile('*.vhdr', 'Choose a BrainVision .vhdr file');
if isequal(fname, 0) || isequal(pname,0)
	disp('User pressed cancel')
	return
else
	filename = fullfile(pname, fname);
	disp(['Processing ', filename])
end

% read in the data
[pname, fname, ext] = fileparts(filename);
[data, ~] = pop_loadbv(pname, [fname ext]);