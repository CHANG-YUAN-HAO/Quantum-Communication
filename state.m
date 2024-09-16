function [ state_ts ] = state( d2d_ts , user_ts , user_access ) 

%輸出狀態
%先做出 5 種可能狀態的空集合 (原先)
%可訪問區分類
% 1:sd、2:su、3:R、4:F、5:I

%%state = zeros( 1 , 1 );
d2d = ~isempty( find( d2d_ts, 1 ) );%計算該時槽下D2D有無傳輸

if ( d2d >= 1 && user_ts == 0 )
    state = 1;%只有D2D對傳輸
elseif ( d2d == 0 && user_ts >= 1 )
    state = 2;%只有user和基站傳輸 
elseif( d2d >= 1 && user_ts >= 1 && user_access( user_ts ) == 1 )
    state = 3;%在可訪問區，同時D2D對和CUE
elseif( d2d >= 1 && user_ts >= 1 && user_access( user_ts ) == 0 )
    state = 4;%在不可訪問區，同時D2D對和CUE
else
    state = 5;%沒有任何傳輸的情況
end
state_ts = state;
end

