% Ryan Lindsay 
% 101038101

R1 = 1;
R2 = 2;
R3 = 10;
R4 = 0.1;
RO = 1000;

G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;
G4 = 1/R4;
GO = 1/RO;

L = 0.2;
Cap = 0.25;
alpha = 100;
 
%Matrix Definitions

C = [0 0 0 0 0 0 0;
   -Cap Cap 0 0 0 0 0;
    0 0 -L 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;];

G = [1 0 0 0 0 0 0;
   -G2 G1+G2 -1 0 0 0 0;
    0 1 0 -1 0 0 0;
    0 0 -1 G3 0 0 0;
    0 0 0 0 -alpha 1 0;
    0 0 0 G3 -1 0 0;
    0 0 0 0 0 -G4 G4+GO];


VDC=zeros(7,1);
VAC=zeros(7,1);
F=zeros(7,1);



for v = -10:0.1:10
    F(1,1)=v;
    VDC=G\F;
    
    figure(1)
    plot (v, VDC(7,1),'b.') 
    plot(v, VDC(4,1), 'g.') 
    hold on
end
    title('DC Sweep')
    xlabel('Vin (V)')
    ylabel('Voltage (V)')
    legend('V3','VO')
    
    hold off

w = logspace(1,2,200);                  
F(1,1) = 1;

for i = 1:length(w)
    VAC = (G+C*1j*w(i))\F;              
    figure(3)
    semilogx(w(i), abs(VAC(7,1)), 'b.')
    hold on
  
    
    
end

    xlabel('log (w)')
    ylabel('VO (V)')
    title('AC Sweep')
    hold off

for i = 1:length(w)
    VAC = (G+C*1j*w(i))\F; 
    gain = 20*log(abs(VAC(7,1))/F(1));   
    
    figure(4)
    plot(i, gain, 'g.')
    hold on
    
end

    title('Gain Vo/Vin per step(dB)')
    xlabel('Step')
    ylabel('Gain (dB)')
    hold off



perb =  Cap + 0.05.*randn(1,1000);
w = pi;
Gain = zeros(1000,1);

for n = 1:length(Gain)
    C(1,1) = perb(n);
    C(1,2) = -perb(n);
    C(2,1) = -perb(n);
    C(2,2) = perb(n);
    VAC = (G+C*1j*w)\F;                 
    Gain(n,1) = abs(VAC(7,1))/F(1);    
end


figure(5)
histogram(Gain,100);
title('Histogram of Gain ')
xlabel('Gain')
ylabel('Number of elements')



