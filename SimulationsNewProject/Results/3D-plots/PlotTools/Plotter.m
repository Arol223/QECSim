

%% Fidelity error gain
figure(1)

top = MaxCollection(gain_5qubit1,gain_fid_flagSteane,gain_fid_surf17,gainfid_Shor);
bot = 1;
% Steane Shor extraction
ftmp = 1 - fid_EC_shor_Steane;
fid_EC_shor_Steane = 1 - ftmp.^2;
subplot(2,2,1)
pcolor(p_err_tot,ngates,gainfid_Shor)
set(gca, 'xscale','log')
set(gca,'colorscale','log')
shading 'interp'
colormap('turbo')
xlabel('p_{err,SQBG}')
ylabel('n_g')
title('Fidelity error gain, [7,1,3],\\  Shor Extraction')
xticks(logspace(-6,-2,5));
caxis([bot top])

% Steane flag extraction
ftmp = 1 - fid_EC_flag_Steane;
fid_EC_flag_Steane = 1 - ftmp.^2;
subplot(2,2,2)
pcolor(p_err_tot,ngates,gain_fid_flagSteane)
set(gca, 'xscale','log')
set(gca,'colorscale','log')
shading 'interp'
colormap('turbo')
xlabel('p_{err,SQBG}')
ylabel('n_g')
title('Fidelity error gain, [7,1,3],\\  Flag Extraction')
xticks(logspace(-6,-2,5));
caxis([bot top])

% 5qubit
ftmp = 1 - fid_EC_5qubit1;
fid_EC_5qubit1 = 1 - ftmp.^2;
subplot(2,2,3)
pcolor(p_err_tot,ngates,gain_5qubit1)
set(gca, 'xscale','log')
set(gca,'colorscale','log')
shading 'interp'
colormap('turbo')
xlabel('p_{err,SQBG}')
ylabel('n_g')
title('Fidelity error gain, [5,1,3],\\  Flag Extraction')
xticks(logspace(-6,-2,5));
caxis([bot top])

% Surf17
ftmp = 1 - fid_EC_surf17;
fid_EC_surf17 = 1 - ftmp.^2;
subplot(2,2,4)
pcolor(p_err_tot,ngates,gain_fid_surf17)
set(gca, 'xscale','log')
set(gca,'colorscale','log')
shading 'interp'
colormap('turbo')
xlabel('p_{err,SQBG}')
ylabel('n_g')
title('Fidelity error gain, Surface17')
caxis([bot top])
xticks(logspace(-6,-2,5));

%% Logical error gain
bot = 1;
top = MaxCollection(gain_log5qubit2,gain_log_flagSteane,gain_logerr_surf17,gainlog_SteaneShor);figure()
% Steane Shor extraction
subplot(2,2,1)
pcolor(p_err_tot,ngates,gainlog_SteaneShor)
set(gca, 'xscale','log')
set(gca,'colorscale','log')
shading 'interp'
%colormap('turbo')
xlabel('p_{err,SQBG}')
ylabel('n_g')
title('Logical error gain, [7,1,3], Shor Extraction')
colorbar;
caxis([bot top]);
xticks(logspace(-6,-2,5));

% Steane flag extraction
subplot(2,2,2)
pcolor(p_err_tot,ngates,gain_log_flagSteane)
set(gca, 'xscale','log')
set(gca,'colorscale','log')
shading 'interp'
%colormap('turbo')
xlabel('p_{err,SQBG}')
ylabel('n_g')
title('Logical error gain, [7,1,3], Flag Extraction')
colorbar;
caxis([bot top]);
xticks(logspace(-6,-2,5));

% 5qubit
subplot(2,2,3)
pcolor(p_err_tot,ngates,gain_log5qubit2)
set(gca, 'xscale','log')
set(gca,'colorscale','log')
shading 'interp'
%colormap('turbo')
xlabel('p_{err,SQBG}')
ylabel('n_g')
title('Logical error gain, [5,1,3], Flag Extraction')
colorbar;
caxis([bot top]);
xticks(logspace(-6,-2,5));
% Surf17
subplot(2,2,4)
pcolor(p_err_tot,ngates,gain_logerr_surf17)
set(gca, 'xscale','log')
set(gca,'colorscale','log')
shading 'interp'
xlabel('p_{err,SQBG}')
ylabel('n_g')
title('Logical error gain, Surface17')
colorbar;
caxis([bot top]);
colormap('turbo')
xticks(logspace(-6,-2,5));