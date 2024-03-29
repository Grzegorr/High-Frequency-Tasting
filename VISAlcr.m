clear

visadevlist
obj1 = visadev("USB0::0x2A8D::0x2F01::MY54412848::0::INSTR")
set(obj1,'Timeout',3);

%type = write(obj1, ':FUNCtion:IMPedance:TYPE?');

write(obj1, ':FUNCtion:IMPedance:TYPE ZTD');%%CPD|CPQ|CPG|CPRP|CSD|CSQ|CSRS|LPD|LPQ|LPG|LPRP|LPRD|LSD|LSQ|LSRS|LS
%%RD|RX|ZTD|ZTR|GB|YTD|YTR|VDID
write(obj1, ':FREQuency:CW 21');
write(obj1, ':VOLTage:LEVel 1');
write(obj1, ':APERture MEDium');%SHORt  MEDium
write(obj1, ':DISPlay:ENABle 1');%disable display
pause(20)




y1_out = []
y2_out = []
for x = logspace(log10(21),log10(300000),300)
    x
    write(obj1, ':FREQuency:CW ' + string(x));
    pause(0.1)
    %readout = writeread(obj1, "FETCh:IMPedance:CORRected?");
    try
        readout = writeread(obj1, ':FETCh:IMPedance:FORMatted?');
    catch
        try
            disp("Error cought.")
            readout = writeread(obj1, ':FETCh:IMPedance:FORMatted?');
        catch
            try
                disp("Error cought twice!")
                readout = writeread(obj1, ':FETCh:IMPedance:FORMatted?');
            catch
                disp("Error cought 3 times!!!!")
                readout = writeread(obj1, ':FETCh:IMPedance:FORMatted?');
            end
            readout = writeread(obj1, ':FETCh:IMPedance:FORMatted?');
        end
    end
    readout = split(readout,",");
    y1 = eval(readout(1))
    y2 = eval(readout(2))
    y1_out = [y1_out;y1];
    y2_out = [y2_out;y2];
end
x = logspace(log10(20),log10(300000),300)
y1_out;
y2_out;


writematrix(x,"x.txt")
writematrix(y1_out,"Z.txt")
writematrix(y2_out,"d.txt")


plot(log10(x),log10(y1_out))
title('Z(w)')
xlabel('log10(f)') 
ylabel('Log Impedence Value')
saveas(gcf, "Z.jpg")
figure;
plot(log10(x),y2_out)
title('d(w)')
xlabel('log10(f)') 
ylabel('Impedence Angle')
saveas(gcf, "d.jpg")

%%%%Nyquist plot done here:
Z = y1_out;
d = y2_out;

real = [];
imaginary = [];

for r = 1:300
    temp_real = Z(r)*cosd(d(r));
    real = [real;temp_real];    
    
    temp_imaginary = Z(r)*sind(d(r));
    imaginary = [imaginary;temp_imaginary];
end

writematrix(real,"real.txt")
writematrix(imaginary,"imaginary.txt")

figure;
scatter(real,imaginary)
title('Nyquist Plot')
xlabel('Re(Z)') 
ylabel('Im(Z)')
saveas(gcf, "Myquist.jpg")




    