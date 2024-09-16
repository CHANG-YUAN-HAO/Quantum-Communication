function [ user_access ] = location( Usernum , D2Dpair , PRq_i )


user_access = zeros( Usernum , 1 );

PRq_centers = [ 50 50 ];
PRq_radii = 50 * PRq_i ;

centers = [ 50 50 ];
radii = 50;

D2D_deta = 360 .* rand( D2Dpair , 1 );
D2D_r = 50 .* rand( D2Dpair , 1 );
D2D_X = D2D_r .* cosd( D2D_deta );
D2D_Y = D2D_r .* sind( D2D_deta );

USER_deta = 360 .* rand( Usernum, 1 );
USER_r = 50 .* rand( Usernum, 1 );
USER_X = USER_r .* cosd( USER_deta );
USER_Y = USER_r .* sind( USER_deta );


% figure%創立一個窗口
% cla%清理軸
% xlim([0 100])
% ylim([0 100])
% axis square %將軸縱橫比設置為 1:1
% title('location');
% 
% viscircles( centers , radii , 'Color' , 'b' );
% hold on
% viscircles( PRq_centers , PRq_radii , 'Color' , 'r' );
% hold on
% plot( USER_X + 50 , USER_Y + 50, 'gs' );
% hold on
% plot( D2D_X + 50 , D2D_Y + 50 , 'k^' );
% hold on
% plot( 50 ,50 , 'mp' );
% legend( 'CUE' , 'D2Dpair' , 'BS'); 
% hold off
% pause(1)

for user_i = 1 : Usernum
    if(USER_r( user_i , 1 ) < PRq_radii )
        user_access( user_i ) = 1 ;
    else
        user_access( user_i ) = 0 ;
    end    
end

end

