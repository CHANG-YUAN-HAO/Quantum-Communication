function [ d2d_ts ] = action_next( W, state_ts , D2Dpair ,PR_p , ts )

x_input( 1 , : ) = state_ts; %輸入初始估計網路的狀態
d2d_action = zeros( 1 , ts );
q_value = zeros( D2Dpair + 1 , ts );

for act_max_i = 1 : D2Dpair + 1 %先輸入所有可能的行動(1~L)和(L+1) L:D2D對數 L+1:CUE(不使用D2D，我將它設0)
    x_input( 2 , : ) = act_max_i ;%a = argmax(log(q_value))
    [ q_value_target_max ] = forwardpropagation( x_input , W );
    q_value( act_max_i  , : ) = sum( log( q_value_target_max ) );
end

for act_i = 1 : ts %找出q_value的最大 
    act_max_value = find( q_value( : , act_i ) == max( q_value( : , act_i ) ) );
    if ( length( find( act_max_value ) ) > 1 )% 若是複數個最大，則是從中挑一個
        action_num_all = find( act_max_value );
        action_num = action_num_all( randi( numel( action_num_all ), 1 , 1 ) );
        d2d_action( 1 , act_i ) = action_num * ( rand(1) <= PR_p ) ;
    else
        d2d_action( 1 , act_i ) = act_max_value * ( rand(1) <= PR_p ) ;
    end
end

d2d_ts = d2d_action;

end

