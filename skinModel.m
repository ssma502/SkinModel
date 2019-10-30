function [R_total ] = skinModel( melanosomes_melanin,c_hemoglobin,model )
% the data is collected from http://omlc.org/news/jan98/skinoptics.html

wavelength=model.wavelength;
m_oxy = model.m_oxy;
m_deoxy =model.m_deoxy ;
C_he = c_hemoglobin.*0.25;
Ye =  0.75;

abs_baseline = 0.0244 + (8.53.*exp(-(wavelength - 154.0)./66.2));
total_melanin=model.mu_a_melanin;

% the absorption coefficient of the epidermis:

m_a_epidermis=(total_melanin.*melanosomes_melanin)+ ...
             ( C_he.*( (Ye.*m_oxy) + ((1-Ye).* m_deoxy) ))+ ...
         (abs_baseline.*(1.0 - melanosomes_melanin - C_he ));

% Epidermis: Lambert-Beer Law 
 transmittance= exp( -1.0.*m_a_epidermis);
%%
mu_a_blood = model.mu_a_blood;
musp_total=model.musp_total;
d=model.thickness_papillary_dermis;

% the absorption coefficient for the dermis: 
mu_a_dermis = c_hemoglobin.*mu_a_blood + ((1-c_hemoglobin).*abs_baseline); 

% Dermis: Kubelka-Munk Reflection
[R_pderm,T_pderm] = computeSingleLayer(mu_a_dermis,musp_total,d);

% Layered Skin Reflectance Model
 R_total = transmittance.*R_pderm.*transmittance;


