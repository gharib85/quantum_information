function [ MUBs ] = stabilizers( n )
%this code spits out the stabilizer states for the input number of qubits

%be warned: the primitive rotation thing still has to be hand tuned, this
%is unfortunate :-(
%but I'm 90% sure everything will work once this is done!

%%%GHW Mubs%%%
V=eye(2^n);

num_mubs=1;
for i=1:n-1
    num_mubs=num_mubs*(2^i+1);
end

%these are the GHW mubs
%indices are read as (vector entries, basis vector, basis within MUB, MUB)
MUBs=zeros(2^n,2^n,2^n+1,num_mubs);

%primitive rotation which cycles through mubs
rot=prim_rots(n);

%disj_rots are a set of unitaries {U} such that the mubs
%{R^i}U_j*comp_basis are all disjoint
disj_rots=disjoint_rots(n);

for i=1:num_mubs
    %for a fixed full MUB these loops cycle through the vectors
    for m=1:2^n+1
        for r=1:2^n
            MUBs(:,r,m,i)=rot^(m-1)*disj_rots(:,:,i)*V(:,r);
        end
    end
end

%standardize global phase
for i=size(MUBs,4)
    for j=1:2^n+1
        for k=1:2^n
            for l=1:2^n
                if MUBs(l,k,j,i)~=0
                    MUBs(:,k,j,i)=abs(MUBs(l,k,j,i))/MUBs(l,k,j,i)*MUBs(:,k,j,i);
                    break;
                end
            end
        end
    end
end
