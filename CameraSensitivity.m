function [Y]=CameraSensitivity(rgbCMF)
% rgbCMF : database fo 28 cameras Reference: What is the Space of Spectral Sensitivity Functions for Digital Color Cameras?
Y = zeros(99,28);

redS =rgbCMF{1,1};
greenS= rgbCMF{1,2};
blueS =rgbCMF{1,3};
for i=1:28 %normalise 
    Y(1:33,i)=redS(:,i)./sum(redS(:,i));
    Y(34:66,i)=greenS(:,i)./sum(greenS(:,i));
    Y(67:99,i)=blueS(:,i)./sum(blueS(:,i));
end

end

