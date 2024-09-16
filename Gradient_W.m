function [ grad_W ] = Gradient_W( W , delta_theta , grad_i , D2Dpair )

hl1 = size( W.hl1(:) , 1 );
hl2 = size( W.hl2(:) , 1 ) + hl1;
hl3 = size( W.hl3(:) , 1 ) + hl2;
hl4 = size( W.hl4(:) , 1 ) + hl3;
hl5 = size( W.hl5(:) , 1 ) + hl4;
hl6 = size( W.hl6(:) , 1 ) + hl5;
out = size( W.out(:) , 1 ) + hl6;

grad_W.hl1 = reshape( delta_theta( 1 : hl1 , grad_i ) , 64 , 2 );
grad_W.hl2 = reshape( delta_theta( 1 + hl1 : hl2 , grad_i ) , 64 , 64 );
grad_W.hl3 = reshape( delta_theta( 1 + hl2 : hl3 , grad_i ) , 64 , 64 );
grad_W.hl4 = reshape( delta_theta( 1 + hl3 : hl4 , grad_i ) , 64 , 64 );
grad_W.hl5 = reshape( delta_theta( 1 + hl4 : hl5 , grad_i ) , 64 , 64 );
grad_W.hl6 = reshape( delta_theta( 1 + hl5 : hl6 , grad_i ) , 64 , 64 );
grad_W.out = reshape( delta_theta( 1 + hl6 : out, grad_i ) , D2Dpair + 1 , 64 );

end

