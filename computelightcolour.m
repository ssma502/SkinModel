function [lightcolour] = computelightcolour(e,Sr,Sg,Sb)
% Inputs:
%     Sr,Sg,Sb         : 1 x 33 
%     e                : 1 x 33 
%  Output:
%     lightcolour        : 1 x 1 x 3 
%% ------------------------ lightcolour -----------------------------------
lightcolour = [sum(Sr.*e,2) sum(Sg.*e,2) sum(Sb.*e,2)];
 %lightcolour = reshape(lightcolour,[1 1 3]);
 
 
end