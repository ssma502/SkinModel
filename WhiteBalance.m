function [ImwhiteBalanced] = WhiteBalance(rawAppearance,lightcolour)
% Inputs:
%     rawAppearance    : H x W x 3 
%     lightcolour      : 1 x 1 x 3 
%  Output:
%     ImwhiteBalanced  : H x W x 3
%% --------------------------- White Balance ------------------------------
WBrCh = rawAppearance(:,:,1)./lightcolour(1);  
WBgCh = rawAppearance(:,:,2)./lightcolour(2);
WBbCh = rawAppearance(:,:,3)./lightcolour(3);
ImwhiteBalanced = cat(3,WBrCh,WBgCh,WBbCh);
end
