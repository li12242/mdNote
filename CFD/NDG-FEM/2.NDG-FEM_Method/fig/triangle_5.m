N = 5; EToV = [1,2,3];
VX = [0, 1, 0.3]; VY = [0, -0.5, 0.4];

Nfp = N+1; Np = (N+1)*(N+2)/2; Nfaces=3; NODETOL = 1e-12;

% Compute nodal set
[x,y] = Nodes2D(N); [r,s] = xytors(x,y);

% Build reference element matrices
V = Vandermonde2D(N,r,s); invV = inv(V);
MassMatrix = invV'*invV;
[Dr,Ds] = Dmatrices2D(N, r, s, V);

% build coordinates of all the nodes
va = EToV(:,1)'; vb = EToV(:,2)'; vc = EToV(:,3)';
x = 0.5*(-(r+s)*VX(va)+(1+r)*VX(vb)+(1+s)*VX(vc));
y = 0.5*(-(r+s)*VY(va)+(1+r)*VY(vb)+(1+s)*VY(vc));

% find all the nodes that lie on each edge
fmask1   = find( abs(s+1) < NODETOL)'; 
fmask2   = find( abs(r+s) < NODETOL)';
fmask3   = find( abs(r+1) < NODETOL)';
Fmask  = [fmask1;fmask2;fmask3]';
Fx = x(Fmask(:), :); Fy = y(Fmask(:), :);

plot(x(:), y(:), 'o', Fx(:), Fy(:))

for i = 1:Np
    str = num2str(i);
    text(x(i)+0.02, y(i), ['\fontsize{12}{', str, '}'])
end