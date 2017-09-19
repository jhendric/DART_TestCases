function gaussian_product
%% GAUSSIAN_PRODUCT demonstrates the product of two gaussian distributions.
%
%    This is fundamental to Kalman filters and to ensemble
%    data assimilation. Change the parameters of the
%    gaussian for the Prior (green) and the Observation (red)
%    and click on 'Plot Posterior'.
%
%    The product (in this case, the 'Posterior') of two gaussians is a gaussian.
%    If the parameters of the two gaussians are known, the parameters of the
%    resulting gaussian can be calculated.
%
% See also: oned_model.m oned_model_inf.m oned_ensemble.m
%           twod_ensemble.m run_lorenz_63.m run_lorenz_96.m run_lorenz_96_inf.m

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: gaussian_product.m 11631 2017-05-11 23:58:18Z thoar@ucar.edu $

atts = stylesheet;  % get the default fonts and colors

% Specify the figure size in pixels. After that, all positions are
% specified as fractions (units=Normalized). That way, the objects
% scale proportionally as the figure gets resized.

figureXmin   = 450; % The horizontal position of the entire figure, in pixels
figureYmin   = 250; % The vertical   position of the entire figure, in pixels
figureWidth  = 670; % The width  of the entire figure, in pixels
figureHeight = 420; % The height of the entire figure, in pixels

handles.figure1 = figure('Position', [figureXmin figureYmin figureWidth figureHeight], ...
    'Units', 'pixels', ...
    'Name','gaussian_product', ...
    'Color', atts.background);

%Position has units of normalized and therefore the components must be
%Fractions of figure. Also, the actual text  has FontUnits which are
%normalized, so the Font Size is a fraction of the text box/ edit box that
%contains it. Making the font size and box size normalized allows the text
%size and box size to change proportionately if the user resizes the
%figure window. This is true for all text/edit boxes and buttons.

%Creates the graph with given dimensions
plotXmin   = 0.07;
plotYmin   = 0.07;
plotWidth  = 0.6;
plotHeight = 1.0 - 2*plotYmin; % center the plot graphic

handles.graph = axes('Position', [plotXmin plotYmin plotWidth plotHeight]);
set(handles.graph, 'FontSize', atts.fontsize);

LabelFontSize = 0.40;  % proportional sizes
EditFontSize  = 0.35;  % proportional sizes

%% Creates the box surrounding the two Prior edit boxes.
%  By specifying this handle in the subsequent uicontrols,
%  the positions are all relative to the uipanel.
handles.PriorPanel = uipanel('BackgroundColor', atts.green, ...
    'BorderType','none', ...
    'Units', 'Normalized', ...
    'Position',[0.695 0.738 0.260 0.200]);

x1 = 0.025;
x2 = 0.750;
dx1 = x2 - x1 - 0.025;

handles.ui_text_prior_mean = uicontrol( handles.PriorPanel, ...
    'Style', 'text', ...
    'Units', 'Normalized', ...
    'Position', [x1 0.440 dx1 0.430], ...
    'String', 'Prior Mean ', ...
    'BackgroundColor', atts.green, ...
    'ForegroundColor', 'White', ...
    'HorizontalAlignment', 'right', ...
    'FontUnits', 'normalized', ...
    'FontWeight', 'Bold', ...
    'FontName', atts.fontname, ...
    'FontSize', LabelFontSize);

handles.ui_edit_prior_mean = uicontrol( handles.PriorPanel, ...
    'Style', 'edit', ...
    'Units', 'Normalized', ...
    'Position', [x2 0.540 0.225 0.420], ...
    'String', '0', ...
    'Callback', @edit_prior_mean_Callback, ...
    'BackgroundColor', 'White', ...
    'FontUnits', 'normalized', ...
    'FontName', atts.fontname, ...
    'FontSize', EditFontSize);

handles.ui_text_prior_sd = uicontrol( handles.PriorPanel, ...
    'Style', 'text', ...
    'Units', 'Normalized', ...
    'Position', [x1 0.000 dx1 0.430], ...
    'String', 'Prior SD ', ...
    'BackgroundColor', atts.green, ...
    'ForegroundColor', 'White', ...
    'HorizontalAlignment', 'right', ...
    'FontUnits', 'normalized', ...
    'FontWeight', 'Bold', ...
    'FontName', atts.fontname, ...
    'FontSize', LabelFontSize);

handles.ui_edit_prior_sd = uicontrol( handles.PriorPanel, ...
    'Style', 'edit', ...
    'Units', 'Normalized', ...
    'Position', [x2 0.040 0.225 0.420], ...
    'String', '1', ...
    'Callback', @edit_prior_sd_Callback, ...
    'BackgroundColor', 'White', ...
    'FontUnits', 'normalized', ...
    'FontName', atts.fontname, ...
    'FontSize', EditFontSize);

%% Creates the box surrounding the two Observation edit boxes.
handles.ObservationPanel = uipanel('BackgroundColor', atts.red, ...
    'BorderType','none', ...
    'Units', 'Normalized', ...
    'Position',[0.695 0.524 0.260 0.200]);

handles.text_observation = uicontrol(handles.ObservationPanel, ...
    'Style', 'text', ...
    'Units', 'Normalized', ...
    'Position', [x1 0.440 dx1 0.430], ...
    'String', 'Observation ', ...
    'BackgroundColor', atts.red, ...
    'ForegroundColor', 'White', ...
    'HorizontalAlignment', 'right', ...
    'FontUnits', 'normalized', ...
    'FontWeight', 'Bold', ...
    'FontName', atts.fontname, ...
    'FontSize', LabelFontSize);

handles.ui_edit_observation = uicontrol(handles.ObservationPanel, ...
    'Style', 'edit', ...
    'Units', 'Normalized', ...
    'Position', [x2 0.540 0.225 0.420], ...
    'String', '1', ...
    'Callback', @edit_observation_Callback, ...
    'BackgroundColor', 'White', ...
    'FontUnits', 'normalized', ...
    'FontName', atts.fontname, ...
    'FontSize', EditFontSize);

handles.text_obs_error_sd = uicontrol(handles.ObservationPanel, ...
    'Style', 'text', ...
    'Units', 'Normalized', ...
    'Position', [x1 0.000 dx1 0.430], ...
    'String', 'Obs. Error SD ', ...
    'BackgroundColor', atts.red, ...
    'ForegroundColor', 'White', ...
    'HorizontalAlignment', 'right', ...
    'FontUnits', 'normalized', ...
    'FontWeight', 'Bold', ...
    'FontName', atts.fontname, ...
    'FontSize', LabelFontSize);

handles.ui_edit_obs_error_sd = uicontrol(handles.ObservationPanel, ...
    'Style', 'edit', ...
    'Units', 'Normalized', ....
    'Position', [x2 0.040 0.225 0.420], ...
    'String', '1', ...
    'Callback', @edit_obs_error_sd_Callback, ...
    'BackgroundColor', 'White', ...
    'FontUnits', 'normalized', ...
    'FontName', atts.fontname, ...
    'FontSize', EditFontSize);

%% Creates a Button that when pressed, plots the Posterior.
handles.ui_button_Plot = uicontrol('Style', 'pushbutton', ...
    'Units', 'Normalized', ...
    'Position', [0.725 0.400 0.175 0.102], ...
    'String', 'Plot Posterior', ...
    'Callback', @plotGraph_Callback, ...
    'BackgroundColor','White', ...
    'FontUnits', 'normalized', ...
    'FontName', atts.fontname, ...
    'FontSize', 0.4);

%% Create panel for reporting the Posterior values (the product of the two gaussians).
handles.PosteriorPanel = uipanel( ...
    'Position',[0.695 0.100 0.260 0.281], ...
    'Units', 'Normalized', ...
    'BorderType', 'none', ...
    'BackgroundColor', atts.blue, ...
    'ForegroundColor', 'White', ...
    'Title', 'Posterior', ...
    'FontUnits', 'normalized', ...
    'FontName', atts.fontname, ...
    'FontSize', 0.2);

text_xstart = 0.01;
text_dy     = 0.25;
text_y      = 0.925 - text_dy - 0.05;

handles.ui_text_posterior_mean = uicontrol(handles.PosteriorPanel, ...
    'Style', 'text', ...
    'Units', 'Normalized', ...
    'Position', [text_xstart text_y 0.98 text_dy], ...
    'String', 'Mean =', ...
    'BackgroundColor', atts.blue, ...
    'ForegroundColor', 'White', ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.7, ...
    'FontWeight', 'Bold', ...
    'FontName', atts.fontname, ...
    'HorizontalAlignment', 'right');

text_y = text_y - text_dy - 0.05;
handles.ui_text_posterior_sd = uicontrol(handles.PosteriorPanel, ...
    'Style', 'text', ...
    'Units', 'Normalized', ...
    'Position', [text_xstart text_y 0.98 text_dy], ...
    'String', 'SD =', ...
    'BackgroundColor', atts.blue, ...
    'ForegroundColor', 'White', ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.7, ...
    'FontWeight', 'Bold', ...
    'FontName', atts.fontname, ...
    'HorizontalAlignment', 'right');

text_y = text_y - text_dy - 0.05;
handles.ui_text_posterior_weight = uicontrol(handles.PosteriorPanel, ...
    'Style', 'text', ...
    'Units', 'Normalized', ...
    'Position', [text_xstart text_y 0.98 text_dy], ...
    'String', 'Weight =', ...
    'BackgroundColor', atts.blue, ...
    'ForegroundColor', 'White', ...
    'FontUnits', 'normalized', ...
    'FontSize', 0.7, ...
    'FontWeight', 'Bold', ...
    'FontName', atts.fontname, ...
    'HorizontalAlignment', 'right');

align([handles.ui_text_posterior_mean, ...
       handles.ui_text_posterior_sd, ...
       handles.ui_text_posterior_weight], ...
      'Distribute','None');
reset_Posterior();

hlist = [handles.PriorPanel, handles.ObservationPanel, handles.ui_button_Plot, handles.PosteriorPanel];

align(hlist,'Center','Distribute')

%%Plots an initial graph with the default values
g_prod_plot(handles);

%% ---------------------------------------------------------------------

    function plotGraph_Callback(~,~)
        %This function plots the graph using the inputs in the 4 edit boxes. It
        %makes changes to handles, so the function must return an update to
        %handles. This is done through the function definition.

        [prior_mean, prior_sd, obs_mean, obs_err_sd, is_err] = g_prod_plot(handles);

        % If there is an error, zero out the posterior text values
        % don't try to do posterior computation
        if(is_err)
            reset_Posterior();
            return;
        end

        % Compute the posterior mean, sd and weight
        [post_mean, post_sd, weight] = ...
            product_of_gaussians(prior_mean, prior_sd, obs_mean, obs_err_sd);
        post_handle = plot_gaussian(post_mean, post_sd, 1);
        set(post_handle, 'Color', atts.blue, 'LineWidth', 2);

        %Round post_mean, post_sd and weight to 4 decimal places
        post_mean = round(post_mean * 10000);
        post_mean = post_mean/10000;
        post_sd = round(post_sd * 10000);
        post_sd = post_sd/10000;
        weight = round(weight * 10000);
        weight = weight/10000;

        % Print values
        str1 = sprintf('Mean = %.4f',post_mean);
        set(handles.ui_text_posterior_mean, 'String', str1);
        str1 = sprintf('SD = %.4f',post_sd);
        set(handles.ui_text_posterior_sd, 'String', str1);

        % Also plot the weighted posterior as dashed
        post_handle = plot_gaussian(post_mean, post_sd, weight);
        set(post_handle, 'Color', atts.blue, 'LineStyle', '--');
        str1 = sprintf('Weight = %.4f',weight);
        set(handles.ui_text_posterior_weight, 'String', str1);

        h = legend('Prior', 'Obs. Likelihood', 'Posterior', 'Weighted Posterior');
        set(h, 'box', 'on', 'Location', 'NorthWest')

    end

    % These functions plot the graph immediately after the user edits a text box

    function edit_prior_mean_Callback(~, ~)
        g_prod_plot(handles);
        reset_Posterior();
    end

    function edit_prior_sd_Callback(~, ~)
        g_prod_plot(handles);
        reset_Posterior();
    end

    function edit_observation_Callback(~, ~)
        g_prod_plot(handles);
        reset_Posterior();
    end

    function edit_obs_error_sd_Callback(~, ~)
        g_prod_plot(handles);
        reset_Posterior();
    end

    function reset_Posterior()
        set(handles.ui_text_posterior_mean,   'String',   'Mean =         ');
        set(handles.ui_text_posterior_sd,     'String',     'SD =         ');
        set(handles.ui_text_posterior_weight, 'String', 'Weight =         ');
    end

end

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/documentation/DART_LAB/matlab/gaussian_product.m $
% $Revision: 11631 $
% $Date: 2017-05-11 17:58:18 -0600 (Thu, 11 May 2017) $
