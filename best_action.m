function [ action_next ] = best_action( W , state_ts , d2d_ts , D2Dpair , PR_p , ts )

x_input( 1 , : ) = state_ts; %輸入初始估計網路的狀態
x_input( 2 , : ) = d2d_ts;
act_max_num = zeros( D2Dpair + 1 , ts );

for act_max_i = 1 : D2Dpair + 1 %先輸入所有可能的行動(1~L)和(L+1) L:D2D對數 L+1:CUE(不使用D2D，我將它設0)
    x_input( 2 , : ) = act_max_i ;%a = argmax(log(q_value))
    if( act_max_i == D2Dpair + 1 )
        x_input( 2 , : ) = 0 ;%不使用D2D對，設為0
    end
    [ q_value_target_max ] = forwardpropagation( x_input , W );
    act_max_num( act_max_i  , : ) = sum( log( q_value_target_max ) );
end

for act_i = 1 : ts %找出a的最大 a = argmax(log(q_value))
    act_max_value = find( act_max_num( : , act_i ) == max( act_max_num( : , act_i ) ) );
    if( act_max_value == D2Dpair + 1 )
        x_input( 2 , act_i ) = 0;%若是D2Dpair+1的話，會因為沒有D2D對，所以為0
    elseif ( length( find( act_max_value ) ) > 1 )% 若是複數個最大，則是從中挑一個
        action_num_all = find( act_max_value );
        action_num = action_num_all( randi( numel( action_num_all ), 1 , 1 ) );
        x_input( 2 , act_i ) = action_num * ( rand(1) <= PR_p ) ;
    else
        x_input( 2 , act_i ) = act_max_value * ( rand(1) <= PR_p );
    end
end

 action_next = x_input( 2 , : );

end

