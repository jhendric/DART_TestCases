function [y] = norm_pdf(x, mu, sigma)
%  computes a gaussian (normal) PDF
%  for the points of X with a given mean (mu) and standard deviation (sigma)
%
% normal plot, y given x:
%  y = (1 / (sigma * sqrt(2*pi))) * e ^ ((-1/2 * ((x-mu) / sigma)^2)
% or
%  g(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{ -\frac{1}{2}\left(\frac{x-\mu}{\sigma}\right)^2 }.
%
% see: https://en.wikipedia.org/wiki/Probability_density_function

%% DART software - Copyright UCAR. This open source software is provided
% by UCAR, "as is", without charge, subject to all terms of use at
% http://www.image.ucar.edu/DAReS/DART/DART_download
%
% DART $Id: norm_pdf.m 10990 2017-02-02 23:39:18Z thoar@ucar.edu $

e = exp(1);

basen = (1.0 / (sigma * sqrt(2*pi)));
expon = -0.5 * (((x-mu) / sigma).^2 );

y = basen * (e .^ expon);

end

% <next few lines under version control, do not edit>
% $URL: https://svn-dares-dart.cgd.ucar.edu/DART/branches/rma_trunk/documentation/DART_LAB/matlab/private/norm_pdf.m $
% $Revision: 10990 $
% $Date: 2017-02-02 16:39:18 -0700 (Thu, 02 Feb 2017) $
