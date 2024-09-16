function [ draw_d2d , draw_state ] = Draw(  d2d_ts , state_ts ,ts )

draw_d2d = zeros( 1 , ts );
draw_state = zeros( 1 , ts );

for ts_i = 1 : ts
    draw_state( : , ts_i ) = find( state_ts( : , ts_i ) );
    %draw_d2d( : , ts_i ) = find( d2d_ts( : , ts_i ) );
end

