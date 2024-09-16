
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% setting
N_B = 2; % 基站數
Usernum = 6; % 用戶數
D2Dpair = 4; % D2D對數
Pf_dBm_i = 20 : 5 : 50; % 傳送功率
D2D_dB = 20 : 5 : 50; % D2D功率密度
snr_dB = 20 : 5 : 50; % 雜訊功率密度
d_th = 25 ; %CUE 和 BS 之間的距離存在閾值
r_d = 50 ; %BS覆蓋半徑
PRq_i = 0.8; % 可訪問區概率( 0.5 )
PRp_i = 1; % D2D通信概率
PR_u = 1 ; %user傳輸概率
ts = 30;%時槽
N_t = 100; % 迭代次數
discount_factor = 0.9; %
learning_rate = 0.6; %( -  )
history_lengt_M = 20;%歷史記憶長度
update_frequen_C = 2;%target權重的更新頻率
delta = 1e-4;%梯度下降，改變的大小

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% hiddenlayer setting
input_nodes = 2; % (1)1:sd、2:su、3:R、4:F、5:I (2)action
hl1_nodes = 64;
hl2_nodes = 64;
hl3_nodes = 64;
hl4_nodes = 64;
hl5_nodes = 64;
hl6_nodes = 64;
output_nodes = D2Dpair + 1 ; % L+1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% weight
W_max = 0.5;
W_min = -0.5;
[ rand_W ] = rnd_Weight( W_max , W_min , input_nodes , hl1_nodes , hl2_nodes , hl3_nodes , hl4_nodes , hl5_nodes , hl6_nodes , output_nodes  );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% A S R
d2d_ts = zeros( 1 , ts ); %代表第D2Dpair個D2D對在該時槽上是否傳輸
user_ts = zeros( 1 , ts ); %代表user在該時槽上是否傳輸
state_ts = zeros( 1 , ts ); %每個時槽上state狀態的獎勵
state_ts_next = zeros( 1 , ts );
reward_ts_next = zeros( D2Dpair + 1 , ts ); %每個時槽上state狀態的獎勵
action_ts = zeros( 1 , ts );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% learning
LOSS_t = zeros( 1 , N_t );
LOSS = zeros( length( PRp_i ) , N_t );
rate_d2d = zeros( length( PRp_i ) , N_t );
rate_cue = zeros( length( PRp_i ) , N_t );
rate_sum = zeros( length( PRp_i ) , N_t );
rate_num_cue = zeros( length( PRp_i ) , 1 );
rate_num_sum = zeros( length( PRp_i ) , 1 );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Location
[ user_access ] = location( Usernum , D2Dpair , PRq_i ) ;

for prp_i = 1 : length( PRp_i )
    PR_p = PRp_i( prp_i );
    W = rand_W;
    W_target = rand_W;
    user_num = 1;%cue以逐幀重複的方式在特定TS中傳輸
    for ts_i = 1 : ts
        if( user_num == Usernum + 1)
            user_num = 1;
        end
        [ user_ts( : , ts_i )] = usernumset( PR_u , user_num  );
        [ d2d_ts( : , ts_i ) ] = action( PR_p , D2Dpair );
        [ state_ts( : , ts_i ) ] = state( d2d_ts( : , ts_i ) , user_ts( : , ts_i ) , user_access );
        user_num = user_num + 1;
    end
    for n_t = 1 : N_t
        
        [ action_ts ] = action_next( W , state_ts , D2Dpair , PR_p , ts );
        
        user_num = 1;%cue以逐幀重複的方式在特定TS中傳輸
        for user_ts_i = 1 : ts
            if( user_num == Usernum + 1)
                user_num = 1;
            end
            [ user_ts( : , user_ts_i )] = usernumset( PR_u , user_num  );
            user_num = user_num + 1;
        end
        
        [ state_ts_next ] = state_next( action_ts , user_ts , user_access , ts );
        [ reward_ts_next ] = reward( state_ts_next , action_ts , D2Dpair , ts );
        
        m_t = mod( n_t , history_lengt_M );%歷史記憶長度
        if( m_t == 0 )
            m_t = history_lengt_M;
        end
        
        D( m_t ) = struct( 'state' , state_ts , 'action' , action_ts , 'reward_next' , reward_ts_next , 'state_next' , state_ts_next );%存入D
        H( n_t ) = struct( 'state' , state_ts , 'action' , action_ts , 'reward_next' , reward_ts_next , 'state_next' , state_ts_next );%存入D
        
        %======================== 生成第( 9 ) 的 yt
        [ q_value_target , reward_d , q_value_D , rnd_choose ] = DQNN_target( W, W_target , D , D2Dpair , PR_p , ts );
        
        %======================== 梯度下降 生成loss
        [ grad_loss , loss , Q_value_target ] = gradQNN( W , q_value_D  , D( rnd_choose ).state , D( rnd_choose ).action , q_value_target , reward_d , discount_factor , D2Dpair , delta , ts );
        
        %======================== 更新網路
        [ W_new ] = update_W( W , learning_rate , grad_loss , D2Dpair );%更新網路 ( Q_value ) 估計網路的
        
        W = W_new ;
        
        target_change_f = fix( n_t / update_frequen_C ); %每update_frequen_C次更換target的權重(W_target)
        target_change_c = ceil( n_t / update_frequen_C );
        if( target_change_f == target_change_c )
            W_target = W;%更新網路 ( Q_value_target ) 目標網路的
        end
        
        state_ts = state_ts_next ;
        d2d_ts = action_ts ;
        
        LOSS_t( : , n_t ) = loss;
        
        rate_d2d( prp_i , n_t ) = (sum( sum( reward_ts_next( 1 : 4 , : ) ) ) )/ts;
        rate_cue( prp_i , n_t ) = (sum( sum( reward_ts_next( 5 , : ) ) ) )/ts;
        rate_sum( prp_i , n_t ) = rate_d2d( prp_i , n_t ) + rate_cue( prp_i , n_t ) ;
        
    end
    LOSS( prp_i , : ) = LOSS_t;
    %=============================================== Drawing
    %             figure(10);
    %             bar( user_access );
    %             [ draw_d2d , draw_state ] = Draw( d2d_ts , state_ts , ts );
    %             figure(11);
    %             bar( draw_state );
    %             xlabel('ts');
    %             ylabel('state');
    %             title('1:sd、2:su、3:R、4:F、5:I');
    %===============================================
    
    rate_num_cue( prp_i ) = (sum (rate_cue( prp_i , : )))/N_t;
    rate_num_sum( prp_i ) = (sum (rate_sum( prp_i , : )))/N_t;
    
end

time = datestr(now,'yyyy_mm_dd_HH_MM');
filename = sprintf('%s.mat',time);
save(filename);

figure( 1 );
plot( 1 : N_t  , LOSS( 1 , : ) , 'g' );
hold on
%plot( 1 : N_t  , LOSS( 2 , : ) , 'r' );
%plot( 1 : N_t  , LOSS( 3 , : ) , 'b' );
title('Loss function 綠:1');
ylim( [ 0 1] );
hold off

figure( 2 );
plot( 1 : N_t  , rate_sum( 1 , : ) , 'g' );
hold on
plot( 1 : N_t  , rate_cue( 1 , : ) , 'r' );
plot( 1 : N_t  , rate_d2d( 1 , : ) , 'b' );
title('throughput 綠SUM 紅CUE 藍D2D');
ylim( [ 0 2] );
hold off

figure( 3 );
bar( rate_num_sum );
hold on
bar( rate_num_cue );
hold off
title('throughput');