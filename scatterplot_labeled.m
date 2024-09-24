function varargout = scatterplot_labeled(varargin)
% SCATTERPLOT_LABELED - creates a scatterplot with datacursor labels
%
%	scatterplot_labeled(X,Y) creates a scatter plot of X vs Y
%
%	scatterplot_labeled(X,Y,LabelCellArray) creates a scatter plot of X vs Y
%		with labels from LabelCellArray, a cell array of strings of the
%		same size as X and Y
%
%	scatterplot_labeled(AX, ...) plots AX instead of GCA
%
%	H = scatterplot_labeled(...) returns the line handle created
%
% Author: P. Skelly

%	2015-09-18: created

if nargin < 2
	error('at least 2 inputs are required')
end

% if 1st argument is an axes handle, use it
if length(varargin{1})==1 && ishandle(varargin{1})
	h_ax = varargin{1};
	if ~strcmp(get(h_ax,'Type'), 'axes')
		error('detected first parameter as a handle, but not an axes handle.')
	end
	if nargin < 3
		error('detected first parameter as axes, need at least 2 more inputs to plot.')
	end
	xdata_arg_ind = 2;
else
	h_ax = gca;
	xdata_arg_ind = 1;
end

xdata = varargin{xdata_arg_ind};
ydata = varargin{xdata_arg_ind+1};
labeldata = {};
if nargin >= xdata_arg_ind+2
	labeldata = varargin{xdata_arg_ind+2};
	% 	if ~iscell(labeldata) || ~ischar(labeldata{1})
	% 		error('label data must be a cell array of strings')
	% 	end
end
if nargin >= xdata_arg_ind+3  % look for color array
	colordata = varargin{xdata_arg_ind+3};
	if ~isnumeric(colordata)
		error('color data must be a matrix - each row = rgb color')
	end
end

h_line = plot( h_ax, xdata, ydata, 'o', 'MarkerSize', 12);
set(h_line, 'MarkerFaceColor', get(h_line, 'Color'))

if ~isempty(labeldata)
	set(h_line, 'UserData', labeldata);
	h_fig = get(h_ax, 'Parent');
	% 	h = datacursormode(h_fig);
	h = datacursormode;
	set(h,'UpdateFcn',@myupdatefcn,'SnapToDataVertex','on', 'DisplayStyle', 'window');
	datacursormode on
	% mouse click on plot
end

if nargout > 0
	varargout{1} = h_line;
end

end

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
end