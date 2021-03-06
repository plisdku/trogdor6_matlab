function trogdor_end(varargin)
%trogdor_end End Trogdor simulation description and write parameter file
%   trogdor_end should be the last function called in describing a Trogdor
%   simulation.  It will write the parameter file params.xml and all other
%   data files necessary to run the given simulation.
%
%   trogdor_end('XML', paramFileName) permits customization of the
%   parameter file name.
%
%   trogdor_end('Directory', 'dat', 'OutputDirectory', 'outputs') will put all
%   the auxiliary files into the directory "dat" and all the field outputs
%   into the directory "outputs".

% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential


import com.mathworks.xml.XMLUtils.*;

X.XML = 'params.xml';
X.Directory = 'sim';
X.OutputDirectory = 'output';
X.Parameters = [];
X = t7.parseargs(X, varargin{:});

if ~isstr(X.XML); error('Invalid filename'); end
if ~isstr(X.Directory); error('Invalid directory name'); end
if ~isstr(X.OutputDirectory); error('Invalid output directory name'); end

if ~isempty(X.Directory) && ~exist([pwd filesep X.Directory], 'dir')
    try mkdir([pwd filesep X.Directory])
    catch exception
        error('Could not create helper directory!');
    end
end

%{
if ~isempty(X.OutputDirectory) && ~exist([pwd filesep X.OutputDirectory], 'dir')
    try mkdir([pwd filesep X.OutputDirectory])
    catch exception
        error('Could not create output directory!');
    end
end
%}

% Last things:
%   store the extent of source grids in links

sim = t7.simulation();
sim.Directory = X.Directory;
sim.OutputDirectory = X.OutputDirectory;

% Make meshes if we're asked to
if ~isempty(sim.Grid.NodeGroup)
    sim.Grid.Meshes = sim.Grid.NodeGroup.meshes(X.Parameters);
end

doc = t7.xml.generateXML(sim);
xmlwrite([sim().directoryString, X.XML], doc);

delete(sim);

%t7.TrogdorSimulation.clear();
