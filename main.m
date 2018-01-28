% TODO: change RP_* for something that will have a shorter name then RP_max_pos_x_m 
% PARAMETERS :
path         = './output_files/phaseshift/'; % TODO: fix path
zone_number  = 10000;
lambda_m     = 1e-6;
focus_dist_m = 50;
phi_cnt      = 20;
rho_cnt      = 20;
gamma_rad           = 1e-5;
log_filename = 'gamma_0_1e-5.txt';
% end of PARAMETERS
fullpath = [path, log_filename];
Router_m = sqrt(  zone_number*focus_dist_m*lambda_m    +  ( ( zone_number*lambda_m)/2)^2  );  % outer radius
L                = lambda_m*focus_dist_m/(2*Router_m);
pattern_min_x_m  = -20*L/2;
pattern_max_x_m  =  20*L/2;
pattern_min_y_m  = -20*L/2;
pattern_max_y_m  =  20*L/2;
pattern_step_x_m =  5*L/60;
pattern_step_y_m =  5*L/60; 

delete(fullpath);
diary(fullpath);
diary on;
%______________________________________________________
fprintf( '=============================\n'             );
fprintf( '    %s\n'               ,   datetime('now')  );
fprintf( '=============================\n'             );
fprintf( 'lambda_m         = %f\n',   lambda_m         );    
fprintf( 'focus_dist_m     = %f\n',   focus_dist_m     );    
fprintf( 'phi_cnt          = %d\n',   phi_cnt          );    
fprintf( 'rho_cnt          = %d\n',   rho_cnt          );    
fprintf( 'gamma_rad        = %f\n',   gamma_rad        );    
fprintf( '- - - - - - - - - - - - - - -\n'             );
fprintf( 'pattern_min_x_m  = %f\n',   pattern_min_x_m  );  
fprintf( 'pattern_max_x_m  = %f\n',   pattern_max_x_m  );  
fprintf( 'pattern_min_y_m  = %f\n',   pattern_min_y_m  );    
fprintf( 'pattern_max_y_m  = %f\n',   pattern_max_y_m  );    
fprintf( 'pattern_step_x_m = %f\n',   pattern_step_x_m );    
fprintf( 'pattern_step_y_m = %f\n',   pattern_step_y_m );    
fprintf( '=============================\n'             );
RP_fig   = figure();
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
            pattern_step_y_m, ...
            gamma_rad         ...
            );
fprintf( '=============================\n'             );
RP = ( abs(U) ).^2;
toc;
clear U;
X = pattern_min_x_m + (1:size(RP,1))*pattern_step_x_m;
Y = pattern_min_y_m + (1:size(RP,2))*pattern_step_y_m;

% finding parametrs of radiation pattern:
[RP_max, RP_max_i]       = max(RP(:));
[RP_max_row, RP_max_col] = ind2sub(size(RP), RP_max_i); 

RP_max_x_plane = RP(:, RP_max_col);
RP_max_y_plane = RP(RP_max_row,:);

RP_max_x_m = pattern_min_x_m + RP_max_col*pattern_step_x_m; % RP_max_x_m - position of the maximum
RP_max_y_m = pattern_min_y_m + RP_max_row*pattern_step_y_m; % RP_max_y_m - position of the maximum 
RP_width_x_m = fwhm( X, RP_max_x_plane );
RP_width_y_m = fwhm( Y, RP_max_y_plane );

RP_peaks_x   = findpeaks(RP_max_x_plane,'SortStr','descend');
RP_peaks_y   = findpeaks(RP_max_y_plane,'SortStr','descend');

fprintf( 'MAX              = %f\n', RP_max                  );
fprintf( 'MAX_pos_x        = %f\n', RP_max_x_m              );
fprintf( 'MAX_pos_y        = %f\n', RP_max_y_m              );
fprintf( 'FWHM_x           = %f\n', RP_width_x_m            );
fprintf( 'FWHM_y           = %f\n', RP_width_y_m            );
fprintf( 'SLL_x            = %f\n', RP_peaks_x(2)           );
fprintf( 'SLL_y            = %f\n', RP_peaks_y(2)           );
fprintf( 'SLL_x/MAX        = %f\n', RP_peaks_x(2)/RP_max    );
fprintf( 'SLL_y/MAX        = %f\n', RP_peaks_y(2)/RP_max    );
fprintf( '=============================\n'                  );
%___________________________________________________
surfc( X, Y, RP/RP_max );
title(['zone\_number = ', num2str(zone_number)]);
xlabel('x, m');
ylabel('y, m');
% FIXME: anotation delete some spaces, idk what to do with it
str = {
    ['lambda\_m         = ',      num2str( lambda_m                )],         
    ['focus\_dist\_m      = ',    num2str( focus_dist_m            )],         
    ['phi\_cnt              = ',  num2str( phi_cnt                 )],         
    ['rho\_cnt              = ',  num2str( rho_cnt                 )],         
    ['gamma\_rad       = ',       num2str( gamma_rad               )],         
    ['ZONE\_NUMBER  = ',          num2str( zone_number             )],
    ['MAX              = ',       num2str( RP_max                  )],
    ['MAX\_pos_x        =',       num2str( RP_max_x_m              )],
    ['MAX\_pos_y        =',       num2str( RP_max_y_m              )],
    ['FWHM_x           = ',       num2str( RP_width_x_m            )],
    ['FWHM_y           = ',       num2str( RP_width_y_m            )],
    ['SLL_x            = ',       num2str( RP_peaks_x(2)           )],
    ['SLL_y            = ',       num2str( RP_peaks_y(2)           )],
    ['SLL_x/MAX        = ',       num2str( RP_peaks_x(2)/RP_max    )],
    ['SLL_y/MAX        = ',       num2str( RP_peaks_y(2)/RP_max    )],
};
annotation(RP_fig,'textbox',...
[0.70635080504321 0.48205241023283 0.173186629148354 0.487999985933304],...
     'String',str,...
    'FitBoxToText','on');
pause(1); % delay for graphics to be plotted 
saveas(RP_fig, [fullpath(1:(end-4)),'.png']); % TODO: fix that
saveas(RP_fig, [fullpath(1:(end-4)),'.fig']); % TODO: fix that
diary off;
