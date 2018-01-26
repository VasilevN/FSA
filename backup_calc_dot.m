% TODO: rename it  
function Uxy_o  = calc_dot( ...
        x_m,                ...
        y_m,                ...
        zone_number,        ...     
        lambda_m,           ...
        focus_dist_m,       ...
        rho_min_m,          ...
        phi_step_rad,       ...  % angle step of  cur zone TODO: make a better comment
        rho_step_m,         ...     % radius_step_m,
        phi_cnt,            ...
        rho_cnt             ...
        );

    Uxy = 0;
    const_A = 1/(lambda_m*focus_dist_m);
    const_B = -1i*2*pi/lambda_m;
   
    

    %for (rho_i = 1:rho_cnt)
    %    rho_m = rho_min_m + (rho_i-1)*rho_step_m;
    %    for (phi_i = 1:(phi_cnt))
    %        phi_rad = (phi_i-1)*phi_step_rad;
    %        r01 = sqrt( focus_dist_m^2 + ( x_m - rho_m.*cos(phi_rad) ).^2 + ( y_m - rho_m.*sin(phi_rad) ).^2 );
    %        Uxy = Uxy + const_A*exp(const_B*r01)*rho_m*rho_step_m*phi_step_rad;
    %    end
    %end
    %Uxy_o = Uxy/(rho_cnt*phi_cnt);


    r01 = @( phi_rad, rho_m ) sqrt( focus_dist_m^2 + ( x_m - rho_m.*cos(phi_rad) ).^2 + ( y_m - rho_m.*sin(phi_rad) ).^2 );
    Uxy = @( phi_rad, rho_m ) const_A*exp(const_B.*r01(phi_rad, rho_m)).*rho_m;
    Uxy_o = integral2( Uxy, 0, 2*pi, rho_min_m, rho_min_m + (phi_cnt-1)*phi_step_rad ,'Method','iterated' );
end
