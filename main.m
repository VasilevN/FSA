
log_filename     = './output_files/distributions/out_n_40000.txt';
zone_number      = 40000;
lambda_m         = 1e-6;
focus_dist_m     = 50;
phi_cnt          = 20;
rho_cnt          = 20;

Router_m         = sqrt(  zone_number*focus_dist_m*lambda_m    +  ( ( zone_number*lambda_m)/2)^2  );  % outer radius
L                = lambda_m*focus_dist_m/(2*Router_m);
pattern_min_x_m  = -5*L/2;
pattern_max_x_m  =  5*L/2;
pattern_min_y_m  = -5*L/2;
pattern_max_y_m  =  5*L/2;
pattern_step_x_m =  5*L/60;
pattern_step_y_m =  5*L/60; 

delete(log_filename);
diary(log_filename);
diary on;
%______________________________________________________
fprintf( '=============================\n'             );
fprintf( '    %s\n'               ,   datetime('now')  );
fprintf( '=============================\n'             );
fprintf( 'lambda_m         = %f\n',   lambda_m         );    
fprintf( 'focus_dist_m     = %f\n',   focus_dist_m     );    
fprintf( 'phi_cnt          = %d\n',   phi_cnt          );    
fprintf( 'rho_cnt          = %d\n',   rho_cnt          );    
fprintf( 'pattern_min_x_m  = %f\n',   pattern_min_x_m  );  
fprintf( 'pattern_max_x_m  = %f\n',   pattern_max_x_m  );  
fprintf( 'pattern_min_y_m  = %f\n',   pattern_min_y_m  );    
fprintf( 'pattern_max_y_m  = %f\n',   pattern_max_y_m  );    
fprintf( 'pattern_step_x_m = %f\n',   pattern_step_x_m );    
fprintf( 'pattern_step_y_m = %f\n',   pattern_step_y_m );    
fprintf( '=============================\n'             );
tic %!!
U = calc_radiation_pattern( ...
            zone_number,      ... 
            lambda_m,         ...
            focus_dist_m,     ...
            phi_cnt,          ...
            rho_cnt,          ...
            pattern_min_x_m,  ...
            pattern_max_x_m,  ...
            pattern_min_y_m,  ...
            pattern_max_y_m,  ...
            pattern_step_x_m, ...
            pattern_step_y_m  ...
            );
fprintf( '=============================\n'             );
RP = ( abs(U) ).^2;
X = pattern_min_x_m + (1:size(RP,1))*pattern_step_x_m;
Y = pattern_min_y_m + (1:size(RP,2))*pattern_step_y_m;
%______________________________________________________

RP_mid   = RP(ceil(size(RP,2)/2),1:end);
RP_width = fwhm(X, RP_mid);
RP_peaks = findpeaks(RP_mid,'SortStr','descend');
RP_max   = max(RP(:));
RP_fig   = figure();
%___________________________________________________
surfc( X, Y, RP/RP_max );
title(['zone\_number = ', num2str(zone_number)]);
xlabel('x, m');
ylabel('y, m');
fprintf( 'MAX              = %f\n', RP_max                     );
fprintf( 'FWHM             = %f\n', RP_width                   );
fprintf( 'SLL              = %f\n', RP_peaks(2)                );
fprintf( 'SLL/MAX          = %f\n', RP_peaks(2)/RP_max         );
fprintf( 'SUM              = %f\n', ( abs( sum(U(:)) ) ).^2    );
fprintf( '=============================\n'                  );
toc;
% FIXME: anotation delete some spaces, idk what to do with it
str = {
    ['ZONE\_NUMBER  = ',            num2str( zone_number             )],
    ['MAX                  = ',     num2str( RP_max                  )],
    ['FWHM               = ',       num2str( RP_width                )],
    ['SLL                    = ',   num2str( RP_peaks(2)             )],
    ['SLL/MAX            = ',       num2str( RP_peaks(2)/RP_max      )],
    ['SUM                 = ',      num2str( ( abs( sum(U(:)) ) ).^2 )],
};
annotation(RP_fig,'textbox',...
    [0.701460829493088 0.389776357827476 0.283178187403994 0.327476038338658],...
    'String',str,...
    'FitBoxToText','on');
diary off;
