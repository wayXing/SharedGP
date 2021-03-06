%Demo_scigplvm
% 
% Author: Wei Xing 
% email address: wayne.xingle@gmail.com
% Last revision: 02-Feb-2021

clear
addpath(genpath('./library'))
addpath(genpath('./codes'))
addpath(genpath('./util'))

%% data generate
nTr = 100;
nTe = 100;

zTr = rand(nTr,1) * 10;
zTe = linspace(0.01,10,nTe)';

zTr = zTr + randn(nTr,1)*1;
zTe = zTe;

yTr = [cos(zTr).*zTr, sin(zTr).*zTr, rand(nTr,1)*0.1];   %swiss roll 
figure(1)
scatter3(cos(zTr).*zTr, sin(zTr).*zTr, rand(nTr,1),10,zTr,'filled');

figure(2)
yTe = [cos(zTe).*zTe, sin(zTe).*zTe, rand(nTe,1)*0.1];   %swiss roll 
scatter3(yTe(:,1),yTe(:,2),yTe(:,3),10,zTe,'filled');

%% train model
Y{1} = yTr + randn(size(yTr))*0.1;      %add N noise
Y{2} = zTr + randn(size(zTr))*0.1;
rank = 2;   %dimension for the latent space

% model1 = train_cigplvm(yTr,2,'ard');
% model1 = train_scigplvm_dpp_v2(Y,rank,'ard');
model1 = train_scigplvm_v2(Y, rank, 'ard');

figure(3)
scatter(model1.U(:,1),model1.U(:,2),20,zTr,'filled');

%% predict new y given a location in the latent space: zstar
zstar = rand(5,rank);  %generate random sample in the latent space
model2 = sgplvm_pred(model1,zstar);
model2.yNew{1}          %predictions for y{1} space.

%% inference across spaces
% model2 = scigplvm_fix_infere_v1(model1,1,yTe);      
model4 = scigplvm_infere_v3(model1,1,yTe);

% model4 = train_scigplvm_dpp_infere_v4(model1,1,yTe);

% model3 = train_scigplvm_dpp_infere_v4(model1,1,yTe);
% model2 = sgplvm_invGp_v1(model1,1,yTe);
% model3 = train_scigplvm_dpp_infere_v4(model1,1,yTe);  %for dpp model

%%
figure(5)
% plot(zTe,model2.yNew{1},'r-')
plot(zTe,yTe,'k-')

hold on 
% plot(zTe,model3.y_star{1},'b-')
plot(zTe,model4.y_star{1},'r-')
% plot(zTe,model4.y_star_invGP{1},'c-')
hold off

figure(6)
plot(zTe,yTe,'k-.')
plot(zTr,yTr,'k+')
hold off

figure(7)
% plot(model2.y_star{2},'r-')
% hold on 
% plot(model3.y_star{2},'b-')
% plot(model4.y_star{2},'g-')
% plot(xTe,'k-')
% plot(zTr,'k+')
% hold off

% plot(zTe,model2.y_star{2},'r-')
hold on 
% plot(zTe,model3.y_star{2},'b-')
plot(zTe,model4.y_star{2},'b-')
% plot(zTe,model4.y_star_invGP{2},'c-')
plot(zTe,zTe,'k-.')
plot(zTr,zTr,'k+')
hold off