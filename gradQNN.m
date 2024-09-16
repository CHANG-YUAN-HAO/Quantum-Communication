function [ grad_loss , Loss , Q_value_target ] = gradQNN( W , q_value , state_ts , d2d_ts , q_value_target , D_REWARD_t , discount_factor , D2Dpair , delta , ts )

x( 1 , : ) = state_ts;
x( 2 , : ) = d2d_ts;

Q_value_target = discount_factor * D_REWARD_t + ( 1 - discount_factor ) * q_value_target ; %(9)目標Q值
Loss = ( sum( sum( ( Q_value_target - q_value ).^2 )  / ( D2Dpair + 1 ) ) ) ./ ts;%(8) Loss function 先得到10個Loss
%對 10 個loss取期望值，每個機率都是10分之1

%======================== 計算 第(10)的 gradient QNN
theta = [W.hl1(:) ; W.hl2(:) ; W.hl3(:) ; W.hl4(:) ; W.hl5(:) ; W.hl6(:) ; W.out(:) ] ;
delta_theta = ( theta .* ones( size( theta , 1 ) ) ) - ( delta .* diag( ones( size( theta , 1 ) , 1 ) ) );
grad_loss = zeros( size( theta , 1 ) , 1 );

for grad_i = 1 : size( theta , 1 )
    [ grad_W ] = Gradient_W( W , delta_theta , grad_i , D2Dpair );
    [ grad_v ] = forwardpropagation( x , grad_W );
    grad_q = ( q_value - grad_v ) ./ delta ;
    grad_loss( grad_i , : ) = ( sum( sum( ( Q_value_target - q_value ) .* grad_q )  ./ ( D2Dpair + 1 ) ) ) ./ ts;
end%公式(10)

end
