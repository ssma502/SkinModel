function [R,T] = computeSingleLayer(mu_a,mu_s,d)

if isempty(mu_a) 
	disp(['ERROR: K is empty.']);
	return
end

if isempty(mu_s) 
	disp(['ERROR: S is empty.']);
	return
end
K=sqrt(mu_a.*(mu_a+2.*mu_s));
beta=sqrt(mu_a./(mu_a+2.*mu_s));

R=((1-beta.^2).*(exp(K.*d)-exp(-K.*d)))./((((1+beta).^2).*(exp(K.*d)))-(((1-beta).^2).*(exp(-K.*d))));
 
T=(4.*beta)./((((1+beta).^2).*exp(K.*d))-(((1-beta).^2).*exp(-K.*d)));
end
