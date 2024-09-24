function [txt] = myupdatefcn(~,event_obj)
% Display 'Time' and 'Amplitude'
pos = get(event_obj,'Position');
hLine = get(event_obj, 'Target');
xdata = get(hLine, 'XData');
ydata = get(hLine, 'YData');
labeldata = get(hLine, 'UserData');
a = abs(xdata-pos(1))< eps & abs(ydata-pos(2))< eps; % returns a vector with 1 in the position of the datapoint in the data vector

index = find(a);

if iscell(labeldata)
	txt = {[labeldata{index}],	['X: ',num2str(pos(1))],['Y: ',num2str(pos(2))]};
end
if iscategorical(labeldata)
	txt = {[string(labeldata(index))],	['X: ',num2str(pos(1))],['Y: ',num2str(pos(2))]};
end
