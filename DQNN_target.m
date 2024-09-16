function [ q_value_target , reward_d , q_value_D , rnd_choose ] = DQNN_target( W,  W_target , D , D2Dpair , PR_p , ts )

x_target_input = zeros( 2 , ts ); %輸入目標網路的狀態
% reward_d = zeros( 5 , 10 );

rnd_choose = randi(  size( D , 2 ) , 1 );%從D中取隨機

[ q_value_D ] = DQNN( W , D( rnd_choose ).state , D( rnd_choose ).action );

state_ts_next = D( rnd_choose ).state_next ;
action_ts = D( rnd_choose ).action ;
reward_d = D( rnd_choose ).reward_next ;

[ action_next ] = best_action( W , state_ts_next , action_ts , D2Dpair , PR_p , ts );

x_target_input( 1 , : ) = state_ts_next;
x_target_input( 2 , : ) = action_next;

%======================== Target 目標網路
[ q_value_target ] = forwardpropagation( x_target_input , W_target );

end

