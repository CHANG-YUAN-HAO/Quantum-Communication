function [ q_value ] = DQNN( W , state_ts , d2d_ts )

x_input( 1 , : ) = state_ts; %輸入初始估計網路的狀態
x_input( 2 , : ) = d2d_ts;

%======================== 估計網路
[ q_value ] = forwardpropagation( x_input , W );

end

