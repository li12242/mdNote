Globals1D; 

figure; hold on
for L = 5:8

    N = 2^L; Np = N+1; M = N +2;
    [r,w] = JacobiGQ(0,0,M);

    u_p = zeros(N+1, 1);
    u = -((r>0)*2 - 1);

    for i = 1:N+1
        Pi = JacobiP(r, 0, 0, i-1);
        u_p(i) = sum(w.*Pi.*u);
    end

    x = linspace(-1, 1, 15)';
    y = zeros(size(x));
    for j = 1:N+1
        P = JacobiP(x, 0, 0, j-1);
        y = y+ u_p(j)*P;
    end

    plot(x,y)
end
grid on