% Copyright 2018 Paul Hansen
% Unauthorized copying of this file is strictly prohibited
% Proprietary and confidential

function addTimeHarmonic(doc, sim)

root = doc.getDocumentElement;

if isempty(sim.TimeHarmonic)
    return;
end

thXML = doc.createElement('TimeHarmonic');
thXML.setAttribute('omegaCenter', sprintf('%0.10f', sim.TimeHarmonic.center));
thXML.setAttribute('sigma', sprintf('%0.10f', sim.TimeHarmonic.sigma));

root.appendChild(thXML);
