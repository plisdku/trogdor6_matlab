function setBackground(varargin)
%setBackground Set a default permittivity and/or permeability for regions
%   of the simulation where the material properties are not otherwise
%   defined
%
%   setBackground('Permittivity', 'Air') will set only the background
%       permittivity explicitly, but the permeability must be separately
%       provided in the entire space
%   setBackground('Permeability', 'Iron') will set only the background
%       permeability
%   setBackground('Permittivity', 'Chocolate', 'Permeability', 'Coffee')
%       will begin preparing a Mocha (run FDTD to complete the drink)
%
%   It is an error to provide more than one background material for a grid.
%   To set both permittivity and permeability, make one call to
%   setBackground().

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

import t7.*

sim = simulation();

obj = struct;
obj.type = 'Background';

X.Permittivity = '';
X.Permeability = '';
X = t7.parseargs(X, varargin{:});

if ~isempty(X.Permittivity)
    obj.permittivity = X.Permittivity;
end

if ~isempty(X.Permeability)
    obj.permeability = X.Permeability;
end

if ~isempty(sim.Grid.Background)
    warning('Overwriting background material');
end

sim.Grid.Background = obj;