function [ W ] = rnd_Weight( W_max , W_min , input_nodes , hl1_nodes , hl2_nodes , hl3_nodes , hl4_nodes , hl5_nodes , hl6_nodes , output_nodes )

W.hl1 = rand( hl1_nodes , input_nodes ) .* ( W_max - W_min ) + W_min;
W.hl2 = rand( hl2_nodes , hl1_nodes ) .* ( W_max - W_min ) + W_min;
W.hl3 = rand( hl3_nodes , hl2_nodes ) .* ( W_max - W_min ) + W_min;
W.hl4 = rand( hl4_nodes , hl3_nodes ) .* ( W_max - W_min ) + W_min;
W.hl5 = rand( hl5_nodes , hl4_nodes ) .* ( W_max - W_min ) + W_min;
W.hl6 = rand( hl6_nodes , hl5_nodes ) .* ( W_max - W_min ) + W_min;
W.out = rand( output_nodes , hl6_nodes ) .* ( W_max - W_min ) + W_min;

end % function