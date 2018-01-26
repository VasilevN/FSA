% TODO: rename pattern_s*
% TODO: make description of input variables
% rp_o - output array of radiation pattern U(x,y)
function RP_o = calc_radiation_pattern( ...
        zone_number,         ...
        lambda_m,            ...
        focus_dist_m,        ...
        phi_cnt,             ...
        rho_cnt,             ...
        pattern_min_x_m,     ...
        pattern_max_x_m,     ...
        pattern_min_y_m,     ...
        pattern_max_y_m,     ...
        pattern_step_x_m,    ...
        pattern_step_y_m     ...
        )
    if ( (pattern_min_x_m > pattern_max_x_m) || (pattern_min_y_m > pattern_max_y_m) )
        RP_o = -1;
        error('wrong input pattern parameters');
    end
    Rzone_m      = @(n) sqrt( n*focus_dist_m*lambda_m + (n*lambda_m/2)^2 );
    Router_m     = Rzone_m(zone_number);
    Rinner_m     = Rzone_m(zone_number-1);
    phi_step_rad = 2*pi/phi_cnt;
    rho_step_m   = (Router_m-Rinner_m)/rho_cnt;
    size_x       = floor( (  pattern_max_x_m - pattern_min_x_m )/pattern_step_x_m ); 
    size_y       = floor( (  pattern_max_y_m - pattern_min_y_m )/pattern_step_y_m ); 
    RP = zeros(size_y, size_x);
    fprintf( '____________________________\n'               );
    fprintf( 'zone_number      = %d\n',         zone_number      );    
    fprintf( 'Router_m         = %f\n',         Router_m         );    
    fprintf( 'Rinner_m         = %f\n',         Rinner_m         );    
    fprintf( 'phi_step_rad     = %f\n',         phi_step_rad     );   
    fprintf( 'rho_step_m       = %f\n',         rho_step_m       );   
    fprintf( 'size_x           = %d\n',         size_x           );    
    fprintf( 'size_y           = %d\n',         size_y           );    
    rho_min_m = Rinner_m;
    rho_max_m = Router_m;
    for x_i = 1:size_x
            x_m = pattern_min_x_m + (x_i)*pattern_step_x_m;
        for y_i = 1:size_y
            y_m = pattern_min_y_m + (y_i)*pattern_step_y_m;
            RP(y_i, x_i) = calc_dot( x_m, y_m, zone_number, lambda_m, focus_dist_m, rho_min_m, rho_max_m, phi_step_rad, rho_step_m, phi_cnt, rho_cnt);
        end
    end
    RP_o = RP;
end
