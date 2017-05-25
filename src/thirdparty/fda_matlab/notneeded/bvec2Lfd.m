function [Lfdobj, bfdcell, afdcell] = ...
    bvec2Lfd(bvec, bwtcell, awtcell, ufdcell)
%BVEC2LFD sets up linear differential operator object from a
%  super-vector of coefficients for expansions of coefficient functions
%  to be estimated.  The first coefficient vector in BVEC is for the
%  first homogeneous coefficient to be estimated, and so on, 
%  progressing through remaining homogeneous coefficients, and then
%  moving to the first forcing function to be estimated, and so on.

%  Last modified 15 Sept 2003

%  calculate order

norder = size(bwtcell,length(size(bwtcell)));

%  calculate number of forcing functions

if isempty(awtcell) | isempty(ufdcell)
    nforce = 0;
    afdcell = {};
else
    nforce = size(ufdcell,2);
end

%  loop through derivatives

m2 = 0;
for ideriv=1:norder
    fdobji = getfd(bwtcell{ideriv});
    if getestimate(bwtcell{ideriv})
        psi_basis  = getbasis(fdobji);
        npsi_basis = getnbasis(psi_basis);
        m1 = m2 + 1;
        m2 = m2 + npsi_basis;
        fdobji = putcoef(fdobji, bvec(m1:m2));
    end
    bfdcell{ideriv} = fdobji;
end

%  loop through forcing functions

for iforce=1:nforce
    fdobji = getfd(awtcell{iforce});
    if getestimate(awtcell{iforce})
        basisa  = getbasis(fdobji);
        nbasisa = getnbasis(basisa);
        m1 = m2 + 1;
        m2 = m2 + nbasisa;
        fdobji = putcoef(fdobji, bvec(m1:m2));
    end
    afdcell{iforce} = fdobji;
end
    
%  compute differential operator that defines the penalty

if isempty(awtcell) | isempty(ufdcell)
    Lfdobj = Lfd(norder, bfdcell);
else
    Lfdobj = Lfd(norder, bfdcell, afdcell, ufdcell);
end
