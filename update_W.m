function [ W_new ] = update_W( W , learning_rate , grad_loss , D2Dpair )

hl1 = size( W.hl1(:) , 1 );
hl2 = size( W.hl2(:) , 1 ) + hl1;
hl3 = size( W.hl3(:) , 1 ) + hl2;
hl4 = size( W.hl4(:) , 1 ) + hl3;
hl5 = size( W.hl5(:) , 1 ) + hl4;
hl6 = size( W.hl6(:) , 1 ) + hl5;
out = size( W.out(:) , 1 ) + hl6;


grad_1 = reshape( grad_loss( 1 : hl1 , 1 ) , 64 , 2 );
grad_2 = reshape( grad_loss( 1 + hl1 : hl2 , 1 ) , 64 , 64 );
grad_3 = reshape( grad_loss( 1 + hl2 : hl3 , 1 ) , 64 , 64 );
grad_4 = reshape( grad_loss( 1 + hl3 : hl4 , 1 ) , 64 , 64 );
grad_5 = reshape( grad_loss( 1 + hl4 : hl5 , 1 ) , 64 , 64 );
grad_6 = reshape( grad_loss( 1 + hl5 : hl6 , 1 ) , 64 , 64 );
grad_out = reshape( grad_loss( 1 + hl6 : out, 1 ) , D2Dpair + 1 , 64 );

W_new.hl1 = learning_rate * W.hl1 + ( 1 - learning_rate ) * grad_1; %(10)
W_new.hl2 = learning_rate * W.hl2 + ( 1 - learning_rate ) * grad_2; %(10)
W_new.hl3 = learning_rate * W.hl3 + ( 1 - learning_rate ) * grad_3; %(10)
W_new.hl4 = learning_rate * W.hl4 + ( 1 - learning_rate ) * grad_4; %(10)
W_new.hl5 = learning_rate * W.hl5 + ( 1 - learning_rate ) * grad_5; %(10)
W_new.hl6 = learning_rate * W.hl6 + ( 1 - learning_rate ) * grad_6; %(10)
W_new.out = learning_rate * W.out + ( 1 - learning_rate ) * grad_out;%(10)

end 