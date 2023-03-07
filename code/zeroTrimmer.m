function trimmedY = zeroTrimmer(y)
    trimmedY = cellfun(@(x) strrep(x, '0.', '.'), y, ...
        'UniformOutput', false);
end
