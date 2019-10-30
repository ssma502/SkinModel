%% ----------------------------- Biophysical, Spectral Skin Model -------------------------------
clear all
addpath('matFiles');
%% load the histological quantities and functional approximations.
load pheomelanin_ext;
load eumelanin_ext;
load deoxy_hemo_ext_coeff;
load oxy_hemo_ext_coeff;
%% save the histological as struct
[model] = preparedModel(pheomelanin_ext,eumelanin_ext,deoxy_hemo_ext_coeff,oxy_hemo_ext_coeff);
%% load camera spectral sensitivity and spectra of Illuminant for the colour transformation pipleline
load XYZspace.mat; % The CIE XYZ color space.
load rgbCMF; % databse for 28 cameras
 [Y] = CameraSensitivity(rgbCMF);
 wavelength = 33;
 Sr = reshape(double(Y(1:wavelength,1)),[1 33]);
 Sg = reshape(double(Y(wavelength+1:wavelength*2,1)),[1 33]);
 Sb = reshape(double(Y(wavelength*2+1:wavelength*3,1)),[1 33]);

load illumA; % spectra of illuminant A
e = reshape(double(illumA),[1 33]);
e = e./sum(e(:));
%%-------------------------- SKIN MODEL --------------------------
%% generate the nonuniform spacing
dim = 256;
minmelanin = 0.013;  
maxmelanin = 0.43; 
minhemoglobin = 0.02; 
maxhemoglobin = 0.07;  
u=linspace(0.01,1,dim);
melaninvalues = u.^3 .* maxmelanin;
hemoglobinvalues= u.^3 .* maxhemoglobin;

 [melanin,hemoglobin] =  meshgrid(melaninvalues, hemoglobinvalues);
 ar_row=size(melanin,1);
 ar_cl=size(melanin,2);
%
a = zeros([1 256]);
SpectralReflectance = zeros(size(melanin,1),size(melanin,2),33);
rgbim = zeros(size(melanin,1),size(melanin,2),3);
 for row = 1:ar_row
     for col = 1:ar_cl
         m = melanin(row,col);
         h = hemoglobin(row,col);
        [R_total] = skinModel(m,h,model); % compute spectral reflectance
         SpectralReflectance(row,col,:) =  R_total;
     end
 end 
% Image Formation
skincolour = SpectralReflectance.*reshape(e.*3,[1 1 33]); 
rCh = sum(skincolour.*reshape(Sr,[1 1 33]),3);
gCh = sum(skincolour.*reshape(Sg,[1 1 33]),3);
bCh = sum(skincolour.*reshape(Sb,[1 1 33]),3);
% raw image
Iraw = cat(3, rCh,gCh,bCh);

%% Colour Transformation pipeline for visiualisation (see our BMVC 2019 paper)
%1. White Balance
[lightcolour] = computelightcolour(e,Sr,Sg,Sb); 
[ImwhiteBalanced] = WhiteBalance(Iraw,lightcolour);
%% 2. Find T matrix from raw to xzy space
S = [Sr;Sg;Sb];  %S : 3 x 33
T = (S'\XYZspace)'; 
T(1,:) = 0.3253.*T(1,:)./sum(T(1,:));
T(2,:) = 0.3425.*T(2,:)./sum(T(2,:));
T(3,:) = 0.3723.*T(3,:)./sum(T(3,:));
T_RAW2XYZ = reshape(T, [1 1 9]);
%% 3.from raw To RGB 
[ RGBim ] = fromRawTosRGB(ImwhiteBalanced,T_RAW2XYZ);
scaleSRGBim = max(0,min(1,RGBim));
%% 4. from RGB to sRGB: Apply gamma
sRGBim = scaleSRGBim.^(1./2.2);
 figure; imshow(sRGBim);