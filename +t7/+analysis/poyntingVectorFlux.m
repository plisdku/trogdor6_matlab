function [flux, timeOrFreq, faceFluxes] = poyntingVectorFlux(fileName, varargin)
%poyntingVectorFlux Calculate the flux of the Poynting vector
%   [flux, freq] = poyntingVectorFlux('poynting') will return the
%   frequency-dependent complex Poynting vector flux through a 2D surface
%   using the E and H fields saved in a binary file called 'poynting'.
%   Without further arguments this uses spectrum() to calculate the field
%   phasors and fft frequencies.  The integral will read dx, dy and dz from
%   the output file.
%
%   [flux, times] = poyntingVectorFlux(filename, 'Time') will calculate the
%   flux as a function of time and return the timestamp of each sample as
%   well.
%   
%   [flux, freq] = poyntingVectorFlux(filename, 'Frequency', freqs) uses
%   spectrum() to obtain the E and H fields only at desired frequencies.
%
%   [flux, freq] = poyntingVectorFlux(filename, 'SteadyStateFrequency')
%   uses spectrum() to obtain the E and H fields in steady state.
%
%   [flux, timeOrFreq, faceFluxes] = poyntingVectorFlux( . . . ) provides
%   the flux through each face of the output volume separately.
%
%   Additional parameters:
%       Normal          Normal vector to use for flux integral, e.g. [1 0 0]
%
%   ORIENTATION OF FACES
%
%   When the output file saves a single 1D region, the normal vector must
%   be specified by the caller!
%
%   When the output file saves a single 2D region, the normal vector will
%   be assumed to point in the positive direction along the axis
%   perpendicular to the surface unless otherwise specified.
%
%   When the output file contains two points (e.g. the beginning and end of
%   an interval in a 1D simulation), the outward-facing normal vector will
%   be inferred.  Thus the power flow LEAVING the interval will be
%   returned.
%
%   When the output file contains several 1D regions (e.g. a closed loop
%   around a square in a 2D simulation), the outward-facing normal vector
%   will be inferred if possible.  Thus the power flow LEAVING the square
%   will be returned.
%
%   When the output file contains several 2D regions (e.g. a closed
%   surface of a box), the outward-facing normal vector will be inferred if
%   possible.  Thus the power flow LEAVING the box will be returned.
%
%   A "surface integral" in 2D is a line integral.  The out-of-plane
%   direction will not be integrated over; thus the power flow out of a
%   square in the XY plane in 2D will not be multiplied by the "height" dz.
%

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

if nargin == 2
    varargin{3} = 1;
end

X.Frequency = [];
X.SteadyStateFrequency = [];
X.Time = [];
X.Normal = [];
X = t7.parseargs(X, varargin{:});

if ~isempty(X.Time)
    [pv, timeOrFreq, positions] = t7.analysis.poyntingVector(fileName, 'Time');
elseif ~isempty(X.Frequency)
    [pv, timeOrFreq, positions] = t7.analysis.poyntingVector(fileName, ...
        'Frequency', X.Frequency);
elseif ~isempty(X.SteadyStateFrequency)
    [pv, timeOrFreq, positions] = t7.analysis.poyntingVector(fileName, ...
        'SteadyStateFrequency', X.SteadyStateFrequency);
else
    [pv, timeOrFreq, positions] = t7.analysis.poyntingVector(fileName);
end

[flux, faceFluxes] = sumFluxes(pv, positions, X.Normal);

end


function [flux, fluxes] = sumFluxes(pv, positions, normal)

if iscell(pv)
    if ~isempty(normal)
        warning('Ignoring normal vector for multi-region output');
    end
    
    numRegions = numel(pv);
    
    for rr = 1:numRegions
        normal = inferNormal(positions, rr);
        fluxes(rr) = fluxIntegral(pv{rr}, positions(rr,:), normal);
    end
else
    fluxes = fluxIntegral(pv, positions, normal);
end

flux = sum(fluxes);

end


