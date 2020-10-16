% *************************************************************
% Calcul du vecteur d'antenne
%
% *************************************************************

function V = steering_vector(r,theta,f,ARRAY)

% Nombre d'onde
k = 2*pi*f/ARRAY.C;

pos = ARRAY.Pos.';

for nb_r=1:length(r)
 for nb_theta=1:length(theta)
  for nb_f=1:length(f)
    
      if (r(nb_r) == Inf) % champ lointain
    
      V(:,nb_f) = exp(j*2*pi*f(nb_f)/ARRAY.C*pos*cos(theta(nb_theta)*pi/180));
          
      else 
      
      d = sqrt(r(nb_r)*r(nb_r) + pos.*pos - 2*r(nb_r).*pos.*cos(theta(nb_theta)*pi/180));
      tau = d./ARRAY.C;      
      V(:,nb_f) = r(nb_r)./d.*exp(j*2*pi*f(nb_f)/ARRAY.C*r(nb_r)).*exp(-j*2*pi*f(nb_f).*tau);
      
      end
      
  end
 end
end
              