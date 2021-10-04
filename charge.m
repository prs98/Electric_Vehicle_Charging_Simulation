N = 5000;
rho = [0.1:0.1:3];
Rmax = 50;
total_revenues = zeros(N,size(rho,2));

for rhoo = 1:size(rho,2)
  
  for n = 1:N
   
    R = zeros(24,1);
    x = zeros(24,1);
    P_d = zeros(24,1); P_d(1) = 50;
    P_s = zeros(25,1);
    W   = zeros(25,1);
    revenues = zeros(24,1);
    charge_eff = 0.8;
    discharge_eff = 0.8;
   
    for t = 1:24
        % Commitment
        x(t) = (R(t)*discharge_eff+10)*rho(1,rhoo);
       
        % Wind
        W(t+1) = unifrnd(5,15);
       
        % Spot Price
        P_s(t+1) = P_d(t) + normrnd(3,2);
       
        % Storage
        excess = (max(W(t+1) - x(t),0));
        shortage = max(x(t) - W(t+1),0);
       
        if excess > 0
            R(t+1) = min(R(t)+charge_eff*(excess),Rmax);
            revenues(t) = x(t) * P_d(t);
        else
            if shortage < R(t)
                R(t+1) = R(t) - shortage;
                revenues(t) = x(t) * P_d(t);
            else
                R(t+1) = 0;
                revenues(t) = x(t) * P_d(t) - (shortage - R(t)) * P_s(t+1);
            end
        end
       
       
        % Next Price
        if unifrnd(0,1) < 0.5
            change = 1;
        else
            change = -1;
        end
        P_d(t+1) = P_d(t) + change;
    end
    total_revenues(n,rhoo) = sum(revenues);
  end
end

tr_mean = mean(total_revenues)

plot(rho,tr_mean,'r')
xlabel('Rho')
ylabel('Mean Total Revenue')
title('Rho VS Mean Total Revenue')

max(tr_mean)
[val,idx]=max(tr_mean,[],2)
rho(1,idx)