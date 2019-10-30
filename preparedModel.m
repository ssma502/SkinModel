function [model] = preparedModel(pheomelanin_ext,eumelanin_ext,deoxy_hemo_ext_coeff,oxy_hemo_ext_coeff)

%% Constants

% Epidermis
pheomelanin_concentration= 12.0;
Melanin_concentration=80.0;
thickness_epidermis = 0.02; % Ref: Donner 
wavelength = 400:10:720;
eumelanin_proportion = 0.61;

% Dermis
thickness_papillary_dermis=0.3;% Ref: BioSepc and A Biophysically-BasedModel of theOptical Properties of Skin Aging  
f_oxy=0.75; 
g=66500.0;
c_hemo=150.0;
%% Epidermis

% the absorption coefficient of eumelanin Ma_eumelanin is :
ma_eumelanin=Melanin_concentration.*eumelanin_ext.*thickness_epidermis;

% the absorption coefficient of pheomelanin Ma_pheomelanin is :
ma_pheomelanin=pheomelanin_concentration.*pheomelanin_ext.*thickness_epidermis;

% total absorption coefficient of mlanin expressed by:
 mu_a_melanin=(eumelanin_proportion.*ma_eumelanin)+((1-eumelanin_proportion).*ma_pheomelanin);

%% Dermis
%% absorption in Dermis

%the absorption coefficient of oxy-haemoglobin) can be expressed by: 
m_oxy = f_oxy.*(2.303.*oxy_hemo_ext_coeff.*c_hemo)./g;
%the absorption coefficient of deoxy-haemoglobin can be expressed by: 
m_deoxy = (1-f_oxy).*(2.303.*deoxy_hemo_ext_coeff.*c_hemo)./g;

% the total absorption coefficient of blood mu_a_hemo is :
 mu_a_blood =m_oxy+m_deoxy; % In units of cm^-1

%% Scattering in Dermis
musp_Rayleigh  =  2e12.*(wavelength.^(-4)); %The Rayleigh scattering component observed in the dermis
musp_Mie  = 2e5.*(wavelength.^(-1.5)); %The Mie scattering behaviour in the dermis (and skin) 
musp_total = musp_Mie+musp_Rayleigh; %The reduced scattering coefficient µsp.dermis of skin is a combination of the Mie and Rayleigh scattering terms 

%% Save the parameters of the model
model.wavelength = wavelength;
model.mu_a_melanin=mu_a_melanin;
model.m_oxy = m_oxy;
model.m_deoxy = m_deoxy;
model.musp_total = musp_total;
model.thickness_papillary_dermis = thickness_papillary_dermis;
model.ma_eumelanin=ma_eumelanin;
model.ma_pheomelanin=ma_pheomelanin;
model.mu_a_blood =mu_a_blood;

end

