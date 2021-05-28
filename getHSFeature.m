function featureVecter = getHSFeature(Im1, Im2, alpha, N)

Im1 = imresize(Im1,[256,256]);
Im2 = imresize(Im2,[256,256]);
[Ex, Ey, Et] = derivative(Im1, Im2);


[l, c] = size(Im1);
U = zeros(l, c);
V = zeros(l, c);

% Laplacian
K = [1/12 1/6 1/12; 1/6 -1 1/6; 1/12 1/6 1/12]; 
A = alpha^2 + Ex.^2 + Ey.^2;

for i = 1:N
    U_avg = conv2(U, K, 'same');
    V_avg = conv2(V, K, 'same');
    B = (Ex.*U_avg+ Ey.*V_avg + Et);

    U = U_avg - Ex.*B./A;
    V = V_avg - Ey.*B./A;
end

U = imfilter(U,ones(16)/256);
V = imfilter(V,ones(16)/256);

uf = U(8:16:end,8:16:end);
vf = V(8:16:end,8:16:end);

a = sqrt(uf.^2+vf.^2);
uf = uf/max(a(:));
vf = vf/max(a(:));

featureVecter = [uf(:)',vf(:)'];

end


function [Ex, Ey, Et] = derivative(Im1, Im2)

Kx = 0.25 * [-1 1; -1 1];
Ky = 0.25 * [-1 -1; 1 1];
Kt = 0.25 * [-1 -1; -1 -1]; 

Ex = conv2(Im1, Kx, 'same') + conv2(Im2, Kx, 'same');
Ey = conv2(Im1, Ky, 'same') + conv2(Im2, Ky, 'same');
Et = conv2(Im1, Kt, 'same') + conv2(Im2, -Kt, 'same');
end