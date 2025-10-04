%homework 2 AMS 595
%Ramona Tobey id:117607747
%In this homework we are approximating borders of the Mandelbrot set
%using a polynomial
%need to create: 
% function it = fractal(c) 
%which takes complex c and returns the number of iterations 
% till divergence
% function m = bisection(fn_f, s, e) 
% which takes a function fn_f, 
% bounds s and e on the initial guess and
%returns a point where the point sign of f changes
%Then I need to fit a polynomial to these points and measure its length
%%
%My first step will be to create the function which tests if a 
% point belongs to a set. The input will be the complex number c,
% written in the form r+i

function it = fractal(c)
    it = 0;
    z = 0;
    while (it < 100 && abs(z) <2)
        z = z^2 + c; 
        it = it + 1;
    end
end
%%
%our indicator function should take in a point x and create an indicator
%function along that line
function fn = indicator_fn_at_x(x)
    fn = @(y) (fractal(x + 1i * y) < 100) * 2 - 1; %note: this is different than what was given 
end
%%
%defining the bisection function
function m = bisection(fn_f, s, e)
    m = (s+e)/2;
    if abs(s-e) > .0001
        if fn_f(m) == 1
            m = bisection(fn_f, s, m);
        else
            m = bisection(fn_f, m, e);
        end
    end
end
%%
%now I need to define an array with at least 1000 points between -2 and 1
%then evaluate each of those with my bisection function and store the
%corresponding m value in another array.

%creating the arrays
xValues = linspace(-2, 1, 2000);
yValues = zeros(size(xValues));
for i = 1:length(xValues)
    fn_f = indicator_fn_at_x(xValues(i));
    yValues(i) = bisection(fn_f, 0, 2);
end
% Now that we have the yValues, we can visualize the results using a plot
figure; 
plot(xValues, yValues); 
xlabel('X, real'); 
ylabel('Y, imaginary'); 
title('Mandelbrot Set Approximation'); 
axis([-2 1 0 2]); 


% The next step is to inspect this graph and discard all the zero value
% before I fit a polynomial to the points
% it seems like it's between -1.78 and 0.4. If I have 2000 values in my
% matrix, (2-1.78)/3 = .07333 = 146th entry and (2.4/3) = 1600th entry
%Important Note! Although there is a bump out by x=-1.78, my polyfit
%function seemed to be less accurate when I included that in the domain, so
%I changed my lower bound to be from x=-1.4 instead, the 400th entry
nonZeroX = xValues(400:1600);
nonZeroy = yValues(400:1600);
%%
%Now, I want to fit a degree 15 polynomial to these new points
p = polyfit(nonZeroX, nonZeroy, 15);
%I want to graph this polynomial on my mandelbrot set to see if it is a
%good match
y = polyval(p, nonZeroX);
hold on; % Keep the current plot 
plot(nonZeroX, y, 'r--'); 
hold off;  
%This seems to be a good fit for my fractal so now I will estimate its
%length
%%
%This is where I will create my poly_len function
%We are also supposed to create an anonymous function ds that only takes in
%one argument
ds = @(x) sqrt(1 + (polyval(polyder(p),x)).^2); 
lengthEstimate = integral(ds, -1.39, .39); 
%Now my last step is to display the output.
disp(['Border Length: ', num2str(lengthEstimate)]); 


