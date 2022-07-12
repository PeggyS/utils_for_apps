function [numports,portname] = findUSBserial(verbose)

% findUSBserial: Check OS for available USB-Serial ports:
%   Mac: look in /dev for cu. serial ports.
%   PC:  do some Windows shit.
% Usage: [numports,portnames]=findUSBserial(verbose) [verbose default=0]
% Note: if no physical ports are found, will return numports=-1.

% Written by: Jonathan Jacobs
% October 2018 - September 2020  (last mod: 24 Sep 2020)

% Mar 2020: added Mac "dummy" port /dev/cu.Bluetooth-Incoming-Port. Use
%           when you want to assign a task and there is no available port.
% Sep 2020: disabled Mac "dummy" port because it's not that good an idea.
% Oct 2020: what about ttyp/ptyp pairs? (Nope,not yet...)

if nargin==0,  verbose=0; end
if nargout==0 && nargin==0, verbose=1; end

numports=0;
portname=[];

if ismac
   olddir=pwd;
   cd('/dev')   
   try     temp1=ls('cu*usbserial*');
   catch,  temp1=[]; end
   try     temp2=ls('cu*usbmodem*');
   catch,  temp2=[]; end
   try     temp3=ls('ptyp*');
   catch,  temp3=[]; end
   try     temp4=ls('ttyp*');
   catch,  temp4=[]; end
   try     temp5=ls('cu*virtual*');
   catch,  temp5=[]; end
   cd(olddir)
   
   %if verbose==1, disp( 'Ports found:' ); end
   if isempty(temp1) && isempty(temp2)
      if verbose
         disp('findUSBserial: No physical USB-to-Serial adapter found.')      
      end
      if ~isempty(temp5)
   	     if verbose==1
		    disp(['               Found ' temp5])
	     end
      end
      if ~isempty(temp3) && ~isempty(temp4)
   	     if verbose==1
		    %disp('               ptyp*/ttyp* ports available.')
	     end
      end
      numports=-1;
      portname=[];
      if nargout==0, clear numports portname; end
      return
   end
   phys_ports=[temp1 temp2];
   
   C = textscan(phys_ports, '%s');
   [rows,~]=size(C{1});
   portname=cell(1,rows); %initialise list of available ports
   for i=1:rows
      name=C{1}{i};
      if contains(name,'cu.') && ~strcmpi(name,'cu.serial1')
         numports=numports+1;
         [~,name]=strtok(name,'.'); %#ok<STTOK>
         name=name(2:end);
         %portname{numports}=name;
         portname{numports}=['/dev/cu.' name];
         if verbose==1, disp(['  ' name]); end
      else
         portname{numports}=['/dev/cu.' name];
      end
   end %for

   
elseif ispc
   if verbose
      [err,modeinfo]=system('mode','echo');
   else
      [err,modeinfo]=system('mode');
   end
   if err~= 0
      if verbose==1
         disp('findUSBserial: No USB-Serial adapter found')
      end
      portname=[];
      numports=0;
      return
   end
   
   portsStr=regexp(modeinfo, 'COM\d+:','match');
   np=0;
   portname=cell(1,10);
   for p=portsStr
      np=np+1;
      temp=regexp(p{1},'COM\d+','match');
      portname{np}=temp{1}; 
      if verbose, fprintf('Found USB-Serial adapter on: %s\n',portname{np}); end
   end   
   numports=np;
end

%if use_virt,numports=-1;end

if nargout==0
   clear numports portname
end

end % function findUSBserial