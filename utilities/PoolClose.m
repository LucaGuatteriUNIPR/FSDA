function [tend] = PoolClose(cleanpool, tstart, progbar, usePCT,  usematlabpool)
%PoolClose closes the pool of MATLAB instances opened with PoolPrepare to execute code in parallel 
%
%<a href="matlab: docsearchFS('PoolClose')">Link to the help function</a>
%
% PoolPrepare and PoolClose are used respectively to open and close a
% prespecified number of parallel MATLAB sessions, which need to be
% distributed over the physical cores where MATLAB is running.
%
%  Required input arguments:
%
%      cleanpool:   Function name. Scalar {0,1}. Indicated if the open pool
%                   must be closed or not. It is useful to leave it open if
%                   there are subsequent parallel sessions to execute, so
%                   that to save the time required to open a new pool.
%                   Data Types - integer | logical
%
%        tstart:    Time stamp produced by PoolPrepare. Double. Contains 
%                   the internal computer time at the end of the execution
%                   of the PoolPrepare function, so that to monitor the
%                   overall execution time of the statements embedded
%                   between PoolPrepare and PoolClose.
%                   Data Types - double
%
%       progbar:    Status of the progress bar generated by PoolPrepare. 
%                   Structure or integer. Contains the status of the
%                   progress bar used to monitor the progression of the
%                   parallel execution.
%                   Data Types - struct | double
%
%
% Optional Input arguments:
%
%        usePCT:    Boolean indicating if the parallel computing toolbox is
%                   installed. Scalar {0,1}. Parpool checks for the
%                   existence of the parallel computing toolbox. 'usePCT'
%                   returns the result of the check to PoolClose, to avoid
%                   additional unnecessary checks.
%                   Data Types - integer | logical
%
% usematlabpool:    Boolean indicating the use of 'usematlabpool' or 'parpool'.
%                   Scalar {0,1}. Boolean indicating if the pool of MATLAB
%                   instances is created using 'matlabpool' or 'parpool',
%                   depending on the MATLAB version installed. From R2013b
%                   'parpool' is used. Earlier releases use 'usematlabpool'.
%                   Data Types - integer | logical
%
% Optional input arguments:
%
% Output:
%
%        tend:      Time execution of the parallel instances. Scalar.
%                   Contains the execution time of the statements between
%                   PoolPrepare and PoolClose.
%                   Data Types - double
%
%
% See also: PoolPrepare, parfor
%
% References:
%
% Copyright 2008-2016.
% Written by FSDA team
%
%<a href="matlab: docsearchFS('PoolClose')">Link to the help page for this function</a>
%
% Last modified 31-05-2016

% Examples:
%{

%}
%

%% Beginning of code
% This is to make 'PoolClose' independent from the specification of usePCT
% and usematlabpool returned by 'PoolPrepare', i.e. if not provided in input.
if nargin < 4 || (isempty(usePCT) && isempty(usematlabpool))
    % If the Parallel Computing Toolbox is installed, then either 'matlabpool'
    % or (from R2013b) 'parpool' must exist, and 'usematlabpool' is set to 1 or
    % 0 accordingly. Otherwise (i.e. if the Parallel Computing Toolbox is not
    % installed) 'usematlabpool' is set to NaN.
    if isfunction('parpool')
        usematlabpool = 0;
    elseif isfunction('matlabpool')
        usematlabpool = 1;
    else
        usematlabpool = nan;
    end
    if numpool > 1 && ~isnan(usematlabpool)
        usePCT = 1;
    else
        usePCT = 0;
    end
end

% PoolPrepare and PoolClose monitor the overall execution time of the code
% (parallel and not) between the two instances, without counting the
% opening/close of the parpool
tend = toc(tstart);

if progbar ~= 9999
    if usePCT == 1
        progbar.stop;
    end
    disp(['Total time required: ' num2str(tend) ' seconds']);
end

% close parallel jobs if necessary
if usePCT == 1 && cleanpool == true
    if usematlabpool
        matlabpool('close'); %#ok<DPOOL>
    else
        delete(gcp);
    end
end
end
%FScategory:UTIGEN