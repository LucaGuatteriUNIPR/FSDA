function playbackdemoFS(demo_name)
%playbackdemoFS opens FSDA web site and launches playback device
%
%  PLAYBACKDEMOFS(DEMO_NAME) launches a playback demo in "www.riani.it/MATLAB/".
%
% Copyright 2008-2016.
% Written by FSDA team
%
% Last modified 31-05-2016
%
%   Example:
%      playbackdemoFS('fishery')

if nargin <1
    url = 'www.riani.it/MATLAB/index.html';
else
    
    mlroot = 'www.riani.it/MATLAB/';
    
    % Assemble file paths
    url = [mlroot,demo_name,'/index.html'];
end
% Launch browser
web(url,'-browser');

end

