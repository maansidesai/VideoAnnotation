%addpath(genpath('/Users/maansi/Desktop/matlab_scripts/Pain_Correlations'))
function [X,Y] = calculateEllipseNoRotate(x, y, a, b, steps)
    %# This functions returns points to draw an ellipse
    %#
    %#  @param x     X coordinate
    %#  @param y     Y coordinate
    %#  @param a     Semimajor axis
    %#  @param b     Semiminor axis
    %#  
    %#

    narginchk(4, 5);
    if nargin<5, steps = 36; end

   

    alpha = linspace(0, 360, steps)' .* (pi / 180);
    sinalpha = sin(alpha);
    cosalpha = cos(alpha);

    X = x + (a * cosalpha  );
    Y = y + ( b * sinalpha );

    if nargout==1, X = [X Y]; end
end
