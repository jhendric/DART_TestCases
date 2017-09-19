function dates = nc_read_time(fname,varid)
%% Attempts to interpret the time variable based on any existing 'units'
%  attribute. At present, the calendar is ignored.
%  Returns the time compatible with matlab's 'datenum' base.
%
% cdate = nc_read_time('true_state.nc','time');

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: nc_read_time.m 11545 2017-04-27 18:00:20Z hendric@ucar.edu $

dates     = [];
times     = ncread(fname,varid);
timeunits = nc_read_att(fname,varid,'units');

if (~ isempty(timeunits))
    if strcmp(timeunits,'days')
        dates = times;
    elseif strncmp(timeunits,'days since',numel('days since'))
        timebase   = sscanf(timeunits,'%*s%*s%d%*c%d%*c%d'); % YYYY MM DD
        timeorigin = datenum(timebase(1),timebase(2),timebase(3));
        dates      = times + timeorigin;
    elseif strncmp(timeunits,'seconds since',numel('seconds since'))
        timebase   = sscanf(timeunits,'%*s%*s%d%*c%d%*c%d'); % YYYY MM DD
        timeorigin = datenum(timebase(1),timebase(2),timebase(3));
        dates      = times ./ 86400.0 + timeorigin;
    end
end

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/diagnostics/matlab/private/nc_read_time.m $
% $Revision: 11545 $
% $Date: 2017-04-27 12:00:20 -0600 (Thu, 27 Apr 2017) $
