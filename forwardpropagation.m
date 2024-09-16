function [ v ] = forwardpropagation( x , W )

hl1 = max( 0 , W.hl1 * x ); % ReLU
hl2 = max( 0 , W.hl2 * hl1 );
hl3 = max( 0 , W.hl3 * hl2 );
hl4 = max( 0 , W.hl4 * hl3 );
hl5 = max( 0 , W.hl5 * hl4 );
hl6 = max( 0 , W.hl6 * hl5 );
y = max( 0 , W.out * hl6 );
v = softmax( y ); %使得每一個元素的範圍都在(0,1)之間，並且所有元素的和為1

end

