% Nicholas M Schneider
% 26 November 2013
% On latice 2D Diffusion



% Random Initial Distribution with one species
domainSize = [400 400];
domain = zeros(domainSize);
domain(rand(domainSize) < .03) = 1;

figure; imshow(domain)



% Import Domain
domain = imread('./sample_input.png');
domain = domain(:,:,1);
domainSize = size(domain);

figure; imshow(domain)



% Algorithmic Distribution
domainSize = [400 800];
domain = zeros(domainSize);
% Square
domain(150:250,150:250) = 1;
% Circle(s)
domain(50:75:350,450:75:750) = 1; % Define center
circle = fspecial('disk', 20) ~= 0; % This creates a circular shaped filter
domain(:,401:end) = imdilate( domain(:,401:end) , circle ); % This morphological Operator Replaces points with the shape defined in circle

figure; imshow(domain)



% Generate Position Arrays
[particlePosition(:,1), particlePosition(:,2)] = find(domain);
particleIndex = sub2ind( domainSize, particlePosition(:,1), particlePosition(:,2));



% Write image file
mkdir('./results')
imwrite(domain,['./results/_',num2str(0),'.png'])


for step = 1:100
    for i = 1:length(particlePosition)
        
        %Select Direction to Move
        switch ceil(4 * rand)
            case 1
                dR = [-1 0];
            case 2
                dR = [+1 0];
            case 3
                dR = [0 -1];
            case 4
                dR = [0 +1];
        end
        
        %New Particle Location
        tempPosition = particlePosition(i,:) + dR;
        
        %Periodic Boundary Conditions
        if tempPosition(2) < 1 %Left
            tempPosition(2) = tempPosition(2) + domainSize(2);
        elseif tempPosition(2) > domainSize(2) %Right
            tempPosition(2) = tempPosition(2) - domainSize(2);
        elseif tempPosition(1) < 1 %Top
            tempPosition(1) = tempPosition(1) + domainSize(1);
        elseif tempPosition(1) > domainSize(1) %Bottom
            tempPosition(1) = tempPosition(1) - domainSize(1);
        end
        
        
        
        % Move Particle
%         particlePosition(i,:) = tempPosition;
        
        % Convert new location to indicies for speedy search
        tempIndex = sub2ind( domainSize, tempPosition(1), tempPosition(2));
        % If where we want to move is empty, move
        if ~sum(ones(length(particleIndex),1)*tempIndex == particleIndex)
            particlePosition(i,:) = tempPosition;
            particleIndex(i) = tempIndex;
        end
    end
    
    % Comment out for no overlap... Uncomment if running with overlap
%     particleIndex = sub2ind( domainSize, particlePosition(:,1), particlePosition(:,2));
    
    
    
    
    % Write Image File at some rate
    if mod(step,1) == 0
        % Update Domain Image
        domain = zeros(domainSize);
        domain(particleIndex) = 1;
        imwrite(domain,['./results/_',num2str(step),'.png'])
    end
    
    % Print to Screen at some other rate
    if mod(step,1) == 0
        fprintf(1,'Time is %d \n', step )
    end
    
    
end