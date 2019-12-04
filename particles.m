function u=particles(x1, y1, vx, vy)
N = 1024;
global T 
global dt
global m
T=10;
dt= .05;
u = zeros(N,4,T/dt);
m = 10;
u(1, 1, 1) = x1;
u(1, 2, 1) = y1;
u(1, 3, 1) = vx;
u(1, 4, 1) = vy;
rng(331);
for i = 2:sqrt(N)
    for j = 2:sqrt(N)
        n = sqrt(N)*(i-1) + j;
        u(n,1, 1) = 1/(sqrt(N)+1)*i; %x
        u(n,2, 1) = 1/(sqrt(N)+1)*j; %y
        u(n,3, 1) = (rand/5+.2)*(-1).^(randi(2));%vx
        u(n,4, 1) = (rand/5+.2)*(-1).^(randi(2));%vy
    end
end
collided = zeros(N, T/dt);

%approximate size of balls as diameter of 0.02
d=0.005;
axis([0 1 0 1])

for t = 2:T/dt
    for n = 1:N
        if u(n, 1,t-1) < d  %left bounce
            u(n, 3, t) = -u(n, 3, t-1);
            u(n, 1, t-1) = d;
        else
            if  u(n, 1,t-1) > 1-d %right bounce
                u(n, 3, t) = -u(n, 3, t-1);
                u(n, 1, t-1) = 1-d;
            else
                u(n, 3, t) = u(n, 3, t-1);
            end
        end
        if u(n, 2, t-1) < d  %bottom bounce
            u(n, 4, t) = -u(n, 4,t-1);
            u(n, 2, t-1) = d;
        else
            if u(n, 2,t-1) > 1-d %top bounce
                u(n, 4, t) = -u(n, 4,t-1);
                u(n, 2, t-1) = 1-d;
            else
                u(n, 4, t) = u(n, 4, t-1);
            end
        end
        if n == 1
            for i = 2:N
                distance = sqrt((u(1,1,t-1) - u(i,1,t-1)).^2 + ...
                    (u(1,2,t-1) - u(i,2,t-1)).^2);
                if distance <= m*d && collided(i, t-1) == 0
                    %new velocity of heavy particle
                    tempx = (m-1)/(m+1)*u(1, 3, t-1)+2/(m+1)*u(i,3,t-1);
                    tempy = (m-1)/(m+1)*u(1, 4, t-1)+2/(m+1)*u(i,4,t-1);
                    %new velocity of lighter particle
                    u(i, 3, t) = 2/(m+1)*u(1,3,t)+(1-m)/(m+1)*u(i,3,t-1);
                    u(i, 4, t) = 2/(m+1)*u(1,4,t)+(1-m)/(m+1)*u(i,4,t-1);
                    u(i, 3, t-1) = u(i, 3, t);
                    u(i, 4, t-1) = u(i, 4, t);
                    u(1, 3, t) = tempx;
                    u(1, 4, t) = tempy;
                    collided(i, t) = 1;
                    collided(i, t+1)= 1;
                end
            end
        else
            for i = n+1:N
                %nextX = u(i, 1,t-1) + dt * u(i, 3,t-1);
                distance = sqrt((u(n, 1,t-1) - u(i, 1, t-1)).^2 + ...
                    (u(n, 2,t-1) - u(i, 2, t-1)).^2 );
                if distance <= d && i~=n
                    %nextY = u(i, 2,t-1) + dt * u(i, 4,t-1);
                    tempx = u(i, 3, t-1);
                    tempy = u(i, 4, t-1);
                    u(i, 3,t) = u(n, 3,t);
                    u(i, 4,t) = u(n, 4,t);
                    u(i, 3, t-1) = u(i, 3, t);
                    u(i, 4, t-1) = u(i, 4, t);
                    u(n, 3,t) = tempx;
                    u(n, 4,t) = tempy;
                end    
            end
        end
        u(n, 1,t) = u(n, 1,t-1) + dt * u(n, 3,t); %update x position
        u(n, 2,t) = u(n, 2,t-1) + dt * u(n, 4,t); %update y position        
    end
    
end

