u = particles(0.5, 0.5, 0.1, 0);
figure
global T
global dt
global m
for t=1:T/dt
    
    plot(reshape(u(1, 1, 1:t),[1,t]), reshape(u(1, 2, 1:t),[1,t]))
    hold on
    plot(u(:,1,t), u(:,2,t), '.')
    plot(u(1,1,t), u(1,2,t), '.', 'MarkerSize',5*m)
    hold off
    %scatter(u(:,1,t), u(:,2,t), 3, 'filled')
    axis([0 1 0 1])
    pause(.1);
end