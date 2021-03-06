% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

classdef TrogdorGrid % < handle
    
    properties
        Name = '';
        Meshes = [];
        NodeGroup = t7.model.Group;
        Background = [];
        PML = [0 0 0 0 0 0];
        PMLParams = struct('alpha', '', 'kappa', '', 'sigma', '');
        
        Measurements = {};
        Outputs = {};
        HardSources = {};
        SoftSources = {};
        CurrentSources = {};
        TFSFSources = {};
        CustomTFSFSources = {};
        Links = {};
        YeeCells = [0 0 0 0 0 0]; % one cell
        Origin = [0 0 0];
    end
    
    methods
        function obj = TrogdorGrid
            obj.NodeGroup = t7.model.Group();
        end
        
        function nc = numCells(obj, varargin)
            if numel(varargin) == 0
                nc = obj.YeeCells([4:6]) - obj.YeeCells([1:3]) + 1;
            else
                nc = obj.numCells();
                nc = nc(varargin{1});
            end
        end
    end
end