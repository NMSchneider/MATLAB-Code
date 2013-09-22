% Nicholas M Schneider
% 21 April 2013
% On latice Diffusion
% Updated 20 June 2013 to take non-square image inputs. Also fixed bug
%   where dimension was never defined.


% Start Timing
tic

% Clear Workspace
clear all; close all; clc;

%Setup
dimensions = 2;

% Import Domain
%  Read in file as domain
domain = imread('./sample_input.png');
domain = domain(:,:,1);
boxSize = size(domain);

% Write image file
mkdir('./results')
imwrite(domain,['./results/_',num2str(0),'.png'])

% Generate Position Arrays
[particlePosition(:,1), particlePosition(:,2)] = ind2sub([boxSize(1) boxSize(2)],find(domain));
particleIndex = sub2ind( [boxSize(1) boxSize(2)], particlePosition(:,1), particlePosition(:,2));



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
                if tempPosition(1)>boxSize(1)
                    tempPosition(1) = tempPosition(1) - boxSize(1);
                elseif tempPosition(1)<1
                    tempPosition(1) = tempPosition(1) + boxSize(1);
                end
                % Convert to indicies for speedy search
                moveIndex = sub2ind( [boxSize(1) boxSize(2)], tempPosition(1), tempPosition(2));
                % If where we want to move is empty, move
                if ~sum(ones(length(particleIndex),1)*moveIndex == particleIndex)
                    particlePosition(i,:) = tempPosition;
                    particleIndex(i) = moveIndex;
                end
            case 2
                dR = [+1  0];%  0];
                % Where we want to move
                tempPosition = particlePosition(i,:) + dR;
                % Periodic Boundary Conditions
                if tempPosition(1)>boxSize(1)
                    tempPosition(1) = tempPosition(1) - boxSize(1);
                elseif tempPosition(1)<1
                    tempPosition(1) = tempPosition(1) + boxSize(1);
                end
                % Convert to indicies for speedy search
                moveIndex = sub2ind( [boxSize(1) boxSize(2)], tempPosition(1), tempPosition(2));
                % If where we want to move is empty, move
                if ~sum(ones(length(particleIndex),1)*moveIndex == particleIndex)
                    particlePosition(i,:) = tempPosition;
                    particleIndex(i) = moveIndex;
                end
            case 3
                dR = [ 0 -1];%  0];
                % Where we want to move
                tempPosition = particlePosition(i,:) + dR;
                % Periodic Boundary Conditions
                if tempPosition(2)> boxSize(2)
                    tempPosition(2) = tempPosition(2) - boxSize(2);
                elseif tempPosition(2)<1
                    tempPosition(2) = tempPosition(2) + boxSize(2);
                end
                % Convert to indicies for speedy search
                moveIndex = sub2ind( [boxSize(1) boxSize(2)], tempPosition(1), tempPosition(2));
                % If where we want to move is empty, move
                if ~sum(ones(length(particleIndex),1)*moveIndex == particleIndex)
                    particlePosition(i,:) = tempPosition;
                    particleIndex(i) = moveIndex;
                end
            case 4
                dR = [ 0 +1];%  0];
                % Where we want to move
                tempPosition = particlePosition(i,:) + dR;
                % Periodic Boundary Conditions
                if tempPosition(2)> boxSize(2)
                    tempPosition(2) = tempPosition(2) - boxSize(2);
                elseif tempPosition(2)<1
                    tempPosition(2) = tempPosition(2) + boxSize(2);
                end
                % Convert to indicies for speedy search
                moveIndex = sub2ind( [boxSize(1) boxSize(2)], tempPosition(1), tempPosition(2));
                % If where we want to move is empty, move
                if ~sum(ones(length(particleIndex),1)*moveIndex == particleIndex)
                    particlePosition(i,:) = tempPosition;
                    particleIndex(i) = moveIndex;
                end
        end
        
    end
    
    % Update Domain Image
    domain = zeros(boxSize(1),boxSize(2));
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
