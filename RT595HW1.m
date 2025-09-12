%%Homework One AMS595
%%Ramona Tobey 
%%id: 117607747
%{Assignment:The value of π can be estimated using a Monte Carlo algorithm by leveraging the
%relationship between the probability that randomly chosen points in the x − y plane
%fall within a specific region and the area of that region. Specifically, if we randomly
%select (x, y) ∈ [0, 1] × [0, 1] , these points will always lie within a unit square. Some
%of these points may also lie within a quarter of a circle with radius 1, centered at the
%origin. The area of this quarter circle is π/4, which represents the probability that a
%given random point will fall inside the circle. We can use this approach to compute
%π by generating a large number of random points and counting how many fall inside
%the circle compared to the total number of points generated (i.e., those that fall
%within the square). The ratio of these two quantities will approximate π/4. As the
%number of random points increases, the precision of our approximation improves


%Note about my code: for parts A, B, and C I assume that the code of the
%parts not being run will be commented out/run by section to not get three results all at
%once, or copied and pasted sperately to be run. Because of this, I reused
%some variable names through the different parts but it also should be fine
%if it's all ran at once since they are redefined before being used again
%% 

%Part A - for loop:

fixedPoints = [10^3,10^4,10^5,10^6,10^7]; %to set for different amount of fixed points

runTimes = zeros(5); %to store toc output for each number of fixed points

for j=1:5
    tic
    circlePts = 0; %to count how many fall in the circle
    piApproximations = zeros(1,fixedPoints(j)); %store the value corresponding to each i
    %where I run the approximations by creating fixedPoints number of
    %points and counting the ones in the circle
    for i=1:fixedPoints(j)
        x=rand;
        y=rand;
            if x^2+y^2<=1
                circlePts=circlePts+1;
            end
        piApproximations(1,i)=(4*circlePts/i);
    end

    %where I graph how accurate my approximation becomes
    formatSpec = "Approximations for %d Fixed Points";
    titleNumber = fixedPoints(j);
    figureTitle = sprintf(formatSpec, titleNumber);
    figure
        plot(piApproximations)
        title(figureTitle)
        yline(pi)
    runTimes(j)=toc;
end

%where I graph the time it took for each amount of points
figure
plot(fixedPoints,runTimes)
title('Time vs Fixed Points')
ylabel('Time in seconds')
xlabel('number of points')

%% 


% part B: using a while loop to approximate pi to a certain degree of
% precision without using the actual value of pi
% The user can set the sigFig and the max of the confirmationValue to determine the amount
% of accuracy they want and the computing cost they are willing to take up

sigFig=6; %to set a value beforehand
confirmationValue = 0; %what I will use to determine if while loop is done
loopRuns = 0; %to see how long it takes to get there
circlePts = 0; %to count how many fall in the circle
piTryLast = 3; %what will be used to store what approximation I got
format long
while confirmationValue < 30
    loopRuns=loopRuns+1;
    x = rand;
    y = rand;
    if x^2+y^2<=1
        circlePts=circlePts+1;
    end
    piTryNew = round(4 * circlePts / loopRuns,sigFig,'significant');
    if piTryNew == piTryLast
        confirmationValue = confirmationValue+1;
    else
        piTryLast = piTryNew; % Update the last approximation
    end
end
piTryNew
loopRuns

%% 

%Part three: making part two into a function that also plots the points

piSpec(4)

function piApprox = piSpec(s)
    confirmationValue = 0; %what I will use to determine if while loop is done
    loopRuns = 0; %to see how long it takes to get there
    circlePts = 0; %to count how many fall in the circle
    piTryLast = 3; %what will be used to store what approximation I got
    format long
    figure;
    hold on;
    x1 = linspace(0,1);
    y1 = sqrt(1-x1.^2);
    plot (x1,y1);
    title('plotted points')
    xRandomsCircle = [];
    yRandomsCircle = [];
    xRandomsNoCircle = [];
    yRandomsNoCircle = [];
    while confirmationValue < 20
        loopRuns=loopRuns+1;
        x = rand;
        y = rand;
        if x^2+y^2<=1
            circlePts=circlePts+1;
            xRandomsCircle = [xRandomsCircle,x];
            yRandomsCircle = [yRandomsCircle,y];
          
        else
            xRandomsNoCircle = [xRandomsNoCircle,x];
            yRandomsNoCircle = [yRandomsNoCircle,y];
        end
        piApprox = round(4 * circlePts / loopRuns,s,'significant');
        if piApprox == piTryLast
            confirmationValue = confirmationValue+1;
        else
            piTryLast = piApprox; % Update the last approximation
        end
    end
    %graph all the points I stored
    scatter (xRandomsCircle,yRandomsCircle,'.','b')
    hold on;
    scatter(xRandomsNoCircle, yRandomsNoCircle, '.', 'r')
    textOnGraph = ["Pi Approximation: " , num2str(piApprox)];
    text(0.5, 0.5, textOnGraph, 'HorizontalAlignment', 'center', 'FontSize', 12, 'Color', 'k')
    hold off;
end
%% 

