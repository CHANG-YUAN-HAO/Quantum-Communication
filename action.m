function [ d2d_ts  ] = action( PR_p , D2Dpair  )

d2d_ts = randi(D2Dpair) * ( rand(1) <= PR_p );

% action_TS = zeros( D2Dpair , 1);
% 
% for d2dpair = 1 : D2Dpair
%     d2d_p = rand( 1 );
%     if ( d2d_p <= PR_p )
%         a_t = 1;
%     else
%         a_t = 0;
%     end
%     action_TS( d2dpair , 1 ) = a_t ;
% end
% 
% if ( length( find( action_TS ) ) > 1 )
%     d2dpair_num_all = find( action_TS );%找出重複的位置 例如;[1 1 0 0]
%     d2dpair_num = d2dpair_num_all( randi( numel( d2dpair_num_all ), 1 , 1 ) );%從重複的位置中，隨機挑出一組
%     d2d_ts = d2dpair_num;
%     %action_TS = zeros( D2Dpair , 1);
%     %action_TS( d2dpair_num ) = 1 ;
% elseif( ~isempty( find( action_TS, 1 ) ) > 0 )
%     d2d_ts = find( action_TS == 1 );
% else
%     d2d_ts = 0;
% end

%d2d_ts = action_TS ;%在ts時槽下d2d

end

