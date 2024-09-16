function [ action_ts ] = action_set( state_ts , d2d_ts )

 % 1:sd、2:su、3:R、4:F、5:I
if( state_ts == 1 )
  action_ts = d2d_ts;
elseif( state_ts == 2 )
  action_ts = 0;
elseif( state_ts == 3 )
  action_ts = d2d_ts;
elseif( state_ts == 4 )
  action_ts = d2d_ts;
else
  action_ts = 0;
end

