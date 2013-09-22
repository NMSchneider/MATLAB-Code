% Nicholas M Schneider
% 21 April 2013
% On latice Diffusion

% Start Timing
tic

% Clear Workspace
clear all; close all; clc;

% Define the "physical" system
dimensions = 2;
boxSize = 400;

domain = zeros(boxSize,boxSize);
domain(180:219,180:219) = 1;

% Write image file
mkdir('./results')
imwrite(domain,['./results/_',num2str(0),'.png'])

% Generate Position Arrays
[particlePosition(:,1), particlePosition(:,2)] = ind2sub([boxSize boxSize],find(domain));
particleIndex = sub2ind( [boxSize boxSize], particlePosition(:,1), particlePosition(:,2));


for time = 1:40000;
    
    for i = 1:length( particlePosition )
        %Select from +/- dir for each spatial dimention   
        switch ceil( 2 * dimensions * rand )
            case 1
                % Displacement Vector
                dR = [-1  0]; % 0];
                % Where we want to move
                tempPosition = particlePosition(i,:) + dR;
                % Periodic Boundary Conditions
                tempPosition(tempPosition>boxSize) = tempPosition(tempPosition>boxSize) - boxSize;
                tempPosition(tempPosition<1) = tempPosition(tempPosition<1) + boxSize;
                % Convert to indicies for speedy search
                moveIndex = sub2ind( [boxSize boxSize], tempPosition(1), tempPosition(2));
                % If where we want to move is empty, move
                if ~sum(ones(length(particleIndex),1)*moveIndex == particleIndex)
                    particlePosition(i,:) = tempPosition;
                    particleIndex(i) = moveIndex;
                end
            case 2
                dR = [+1  0];%  0];
                tempPosition = particlePosition(i,:) + dR;
                tempPosition(tempPosition>boxSize) = tempPosition(tempPosition>boxSize) - boxSize;
                tempPosition(tempPosition<1) = tempPosition(tempPosition<1) + boxSize;
                moveIndex = sub2ind( [boxSize boxSize], tempPosition(1), tempPosition(2));
                if ~sum(ones(length(particleIndex),1)*moveIndex == particleIndex)
                    particlePosition(i,:) = tempPosition;
                    particleIndex(i) = moveIndex;
                end
            case 3
                dR = [ 0 -1];%  0];
                tempPosition = particlePosition(i,:) + dR;
                tempPosition(tempPosition>boxSize) = tempPosition(tempPosition>boxSize) - boxSize;
                tempPosition(tempPosition<1) = tempPosition(tempPosition<1) + boxSize;
                moveIndex = sub2ind( [boxSize boxSize], tempPosition(1), tempPosition(2));
                if ~sum(ones(length(particleIndex),1)*moveIndex == particleIndex)
                    particlePosition(i,:) = tempPosition;
                    particleIndex(i) = moveIndex;
                end
            case 4
                dR = [ 0 +1];%  0];
                tempPosition = particlePosition(i,:) + dR;
                tempPosition(tempPosition>boxSize) = tempPosition(tempPosition>boxSize) - boxSize;
                tempPosition(tempPosition<1) = tempPosition(tempPosition<1) + boxSize;
                moveIndex = sub2ind( [boxSize boxSize], tempPosition(1), tempPosition(2));
                if ~sum(ones(length(particleIndex),1)*moveIndex == particleIndex)
                    particlePosition(i,:) = tempPosition;
                    particleIndex(i) = moveIndex;
                end
        end
        
    end
    
    % Update Domain Image
    domain = zeros(boxSize,boxSize);
    domain(particleIndex) = 1;
    
    % Write Image File at some rate
    if mod(time,1) == 0
        imwrite(domain,['./results/_',num2str(time),'.png'])
    end

    % Print to Screen at some other rate
    if mod(time,10) == 0
        fprintf(1,'Time is %d \n', time )
    end
    
    
end

% Show final image and total time
figure; imshow(domain)
toc
