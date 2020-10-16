close all; clear all; clc;

 data1 = load('data1.mat');
%data2 = load('data2.mat');
%data1 = load('data3.mat');

%tracer signal dans le domain temporel
figure()
plot(data1.MICROS.t, data1.MICROS.Signal)
legend(["Micro1","Micro2","Micro3","Micro4"])
pause(5)
%%Partie 1

%analyse: type de signle, amplitude, ephasage frequence...
[t,amp]=ginput(2);
tau=(t(2)-t(1))/3;
theta = acosd(tau*data1.ANTENNE.C/(abs(data1.ANTENNE.Pos(1)-data1.ANTENNE.Pos(2))));

%tracer signal domain frequentiel
freq = data1.MICROS.Fe/length(data1.MICROS.Signal) * (0:length(data1.MICROS.Signal)-1);
figure()
plot(freq,abs(fft(data1.MICROS.Signal)));

%frequence maximale
nMax = 2;
max_freq = maxFreq(data1.MICROS.Signal(:,1),data1.MICROS.Fe,nMax);

%% prtie 2
K = 512; % longueur de la trame

nb_trames = floor(length(data1.MICROS.Signal)/K); %nb trames

[val,idx] = maxFreq(data1.MICROS.Signal(K+1:K*2,1),data1.MICROS.Fe,nMax);

Y = zeros(data1.ANTENNE.N,nb_trames);
for i = 1:length(idx)
    for n = 1:data1.ANTENNE.N
        temp = zeros(1,nb_trames);
        for trame = 1:nb_trames
            tmp = fft(data1.MICROS.Signal(K*(trame-1)+1:K*trame,n));
            temp(trame) = tmp(idx(i));
        end
        Y(n,:) = temp;
    end

    Gamma_M = (1/nb_trames)*(Y*Y');
    assert(isequal(Gamma_M,Gamma_M'))

    [eigenvectors, eigenvalues_mat] = eig(Gamma_M);
    eigenvalues = diag(eigenvalues_mat);
    
    %nombre de sources, les valeurs propres positif superieur a la variance du bruit
    eigenvalues_source=eigenvalues(4);
    eigenvectors_source=eigenvectors(:,4);
    
    %nombre de micros - monbre de sources
    eigenvectors_bruit = eigenvectors(:,1:3);
    projecteur_bruit = eigenvectors_bruit*eigenvectors_bruit';
    %%
    r_vec = 0.1:0.5:5;
    theta_vec = 0:180;
    pseudo_spectre = zeros(length(r_vec),length(theta_vec));
    for r = 1:length(r_vec)
        for theta = 1:length(theta_vec)
            V = steering_vector(r_vec(r),theta_vec(theta),val(i),data1.ANTENNE);
            amp = 1/(V'*projecteur_bruit*V);
            pseudo_spectre(r,theta) = 20*log10(abs(amp));
        end
    end
    figure(3)
    surf(theta_vec,r_vec,pseudo_spectre);
    hold on;
end