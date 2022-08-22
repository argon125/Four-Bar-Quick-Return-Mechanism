clc;clear all;close all;
l1=input("Enter length of link 1\n");
l2=input("Enter length of link 2\n");
l4=input("Enter length of link 4\n");
lengths=sort([l1 l2 l4]);
r2=lengths(1);r1=lengths(2);r4=lengths(3);
grLim=max([r1 r2 r4])+10;
if(r2<=r1 && r2+r1<=r4)
    w2=input("Enter angular velocity of link r2\n");
    rev=input("Enter no. of revolutions to demonstrate\n");
    delt=0.01;
    theta(1)=0;phi=0;t(1)=0;
    totalTime=2*pi*rev/w2;
    for k=1:totalTime/delt+1
        t(k+1)=t(k)+delt;
        theta(k+1)=theta(k)+w2*delt;
        phi(k)=atan(r2*sin(theta(k))/(r1+r2*cos(theta(k))));
        r3(k)=sqrt(r1^2+r2^2+2*r1*r2*cos(theta(k)));
        velA=[-r3(k)*sin(phi(k)) cos(phi(k));r3(k)*cos(phi(k)) sin(phi(k))];
        velB=[-r2*sin(theta(k))*w2;r2*cos(theta(k))*w2];
        velX=velA\velB;
        r3dot(k)=velX(1);w3(k)=velX(2);
        accA=velA;
        accB=[-r2*sin(phi(k))*w2^2+r3(k)*sin(phi(k))*w3(k)^2+2*r3(k)*cos(phi(k))*w3(k);-r2*cos(phi(k))*w2^2+r3(k)*cos(phi(k))*w3(k)^2+2*r3(k)*sin(phi(k))*w3(k)];
        accX=accA\accB;
        alpha3(k)=accX(1);r3ddot(k)=accX(2);
    end
    phiMin=min(phi);phiMax=max(phi);
    stroke=2*r4*sin(phiMax);
    disp("Stroke Length of the tool is "+stroke);
    phiTR=asin(r2/r1);
    TR_th=(pi+2*phiTR)/(pi-2*phiTR);
    TR_pr=(pi+2*phiMax)/(pi-2*phiMax);
    disp("Timing Ratio of the Mechanism is "+TR_pr);

    %simulation begins
    r3dotMin=min(r3dot);r3dotMax=max(r3dot);
    w3Min=min(w3);w3Max=max(w3);
    alpha3Min=min(alpha3);alpha3Max=max(alpha3);
    figure
    for i=1:length(t)-1
        drawnow()
        subplot(2,3,1)
        grid on;
        plot(t(i),r3dot(i),'.');
        xlabel('time(s)');
        ylabel('r3dot(units/s)');
        title("Time Vs Velocity of r3");
        axis([0 length(t)*delt r3dotMin r3dotMax ]);
        hold on

        subplot(2,3,2)
        grid on;
        plot(t(i),w3(i),'.');
        xlabel('time(s)');
        ylabel('w3(rad/s)');
        title("Time Vs omega3");
        axis([0 length(t)*delt w3Min w3Max]);
        hold on

        subplot(2,3,3)
        grid on;
        plot(t(i),alpha3(i),'.');
        xlabel('time(s)');
        ylabel('alpha3(rad/s^2)');
        title("Time Vs alpha3");
        axis([0 length(t)*delt alpha3Min alpha3Max]);
        hold on

        subplot(2,3,5)
        th=theta(i);ph=phi(i);
        grid on;
        plot([0 0],[0 r1],'LineWidth',2)
        axis([-grLim grLim -grLim grLim])
        hold on;
        plot([0 r2*sin(th)],[r1 r1+r2*cos(th)],'LineWidth',2)
        hold on;
        plot([0 r4*sin(ph)],[0 r4*cos(ph)],'LineWidth',2)
        hold off;
        pause(0.01);
    end
else
    disp("Invalid Link lengths to build a Quick return Mechanism");
end