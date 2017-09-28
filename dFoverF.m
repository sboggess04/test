function [dF_F  dF z zz] = dFoverF(y)
%Uses a LSF to get an approximate dFoverF for a bleaching trace

% Estimate baseline with asymmetric least squares
%%Variable inputs
lambda = 10^7 ;
p = 0.001 ;
delta = 10^7 ;
q = 0.9999 ;

m = length(y);
n = length(y);
D = diff(speye(m), 2);
E = diff(speye(n), 2);
w = ones(m, 1);
x = ones(n, 1);
%%Estimate basline of the bottom of the trace in 20 iterations
for it = 1:20
    W = spdiags(w, 0, m, m);
    C = chol(W + lambda * D' * D);
    z = C \ (C' \ (w .* y));
    w = p * (y > z) + (1 - p) * (y < z);
end

%%Estimate top of the trace in 20 iterations
for it = 1:20
    X = spdiags(x, 0, n, n);
    B = chol(X + delta * E' * E);
    zz = B \ (B' \ (x .* y));
    x = q * (y > zz) + (1 - q) * (y < zz);
end

%%calcuate mean of each alsm trace 
top = mean(zz);
bot = mean(z);
dF =(top-bot);
dF_F = ((top-bot))/bot ;


end