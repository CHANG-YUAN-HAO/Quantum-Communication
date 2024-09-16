function [ user_ts ] = usernumset( PR_u , user_num )

user_ts = user_num * ( rand(1) <= PR_u );
% user_p = rand(1);
% 
% if( user_p <= PR_u )
%     user_ts = user_num;
% else
%     user_ts = 0;
% end%在ts時槽下user
end

