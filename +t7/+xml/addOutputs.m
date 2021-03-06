% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

function addOutputs(sim, gridXML, doc, mode)

%directory = sim.outputDirectoryString;

for oo = 1:length(sim.Grid.Outputs)
    output = sim.Grid.Outputs{oo};
    
    if ~isempty(output.mode) && ~strcmpi(output.mode, mode)
        continue;
    end
    
    t7.xml.addOutput(output, sim, gridXML, doc);
end
