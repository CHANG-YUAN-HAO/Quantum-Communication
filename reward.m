function [ reward_ts ] = reward( state_ts , d2d_ts , D2Dpair , ts )%檢查

reward_TS = zeros( D2Dpair + 1 , 1 );
reward_ts = zeros( D2Dpair + 1 , ts );

% 1:sd、2:su、3:R、4:F、5:I
%D2D reward
for reward_i = 1 : ts
    if( state_ts( : , reward_i ) == 1 && d2d_ts( : , reward_i ) > 0 )
        reward_TS( d2d_ts( : , reward_i ) ) = 1;
    elseif( state_ts( : , reward_i ) == 3 )
        reward_TS( d2d_ts( : , reward_i ) ) = 1;
        reward_TS( D2Dpair + 1 ) = 1 ;
    elseif( state_ts( : , reward_i ) == 2 && d2d_ts( : , reward_i ) == 0 )
        reward_TS( D2Dpair + 1 ) = 1;
    else
        reward_TS = zeros( D2Dpair + 1 , 1 );
    end
    
    reward_ts( : , reward_i ) = reward_TS;
    reward_TS = zeros( D2Dpair + 1 , 1 );

end

end

