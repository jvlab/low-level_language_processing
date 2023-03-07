%% Default parameters for fdr specification

fdrSpecs = struct;	% initialization

fdrSpecs.rate = 0.05; % FDR rate

fdrSpecs.strategy = 'time';	% 'time', 'space', 'both'
    % 'time' across time points, 'space' across channels
    % 'both' for spatiotemporal (strictest)
