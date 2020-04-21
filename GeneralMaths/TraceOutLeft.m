function res = TraceOutLeft(dims,rho)
%Trace out the 'left' subsystem of a tensor product. dims are the
%dimensions of the subsystems and rho is the density matrix. Since density
%matrices are symmetric, dims is a 1x2 vector.

res = spalloc(dims(2), dims(2), nnz(rho));

ind = dims(2);
for i = 1:dims(1)
   tmp = rho((i-1)*ind+1:i*ind,(i-1)*ind+1:i*ind);
   if isempty(tmp)
       continue
   end
   res = res + tmp;
end

end