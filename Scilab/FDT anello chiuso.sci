
clear;
clc;
close(winsid());

s=%s;
pi=%pi;

//SPEC "OPEN LOOP"
    Vi=3.3;  //[V]
    Vo=12;   //[V]
    Ro_min=100;     //[Ohm]
    Ro_max=1000;     //[Ohm]
    fsw=600e3;  //[Hz]
    Tsw=1/fsw;  //[s]
    Vo_rip_spec = 0.001*Vo;  //[V]

//PWM e Sensore
    VM=1;   //[V]
    Vref=3.3;   //[V]
    H=Vref/Vo;
    
//Componenti circuitali
    C=18E-6;  //[F]
    L=330E-6; //[H]
    
//calcolo D (duty cycle) "ideale" e corrente Io
    D=1-Vi/Vo;   //adimensionale
    Io_min=Vo/Ro_max;  //[A]
    Io_max=Vo/Ro_min  //[A]
    
//Parametri forma canonica (Buck)
    E_max=Vo-(s*L*Io_min/((1-D)^2));
    J_max=Io_max/((1-D)^2);
    E_min=Vo-(s*L*Io_max/((1-D)^2));
    J_min=Io_min/((1-D)^2);
    M=1/(1-D);
    Leq=L/((1-D)^2);

//parametri del filtro LPF
LPF_max=(1-D)^2/((1/Ro_max +s*C)*s*L+(1-D)^2);
LPF_min=(1-D)^2/((1/Ro_min +s*C)*s*L+(1-D)^2);

//Gvg
Gvg_max=M*LPF_max;
Gvg_min=M*LPF_min;
//Gvd
Gvd_max=E_max*M*LPF_max;
Gvd_min=E_min*M*LPF_min;
//Zout
Zout_max=Leq*s*LPF_max;
Zout_min=Leq*s*LPF_min;
//Tu (uncompensated T)
Tu_max=H*Gvd_max/VM;
Tu_min=H*Gvd_min/VM;

//Compensatore
Gc = ((1+s/(2*pi*0.25))*(1+s/(2*pi*1000)))/(s*(1+s/(2*pi*60000))*(1+s/(2*pi*600000)));
//Compensatore PI senza la specifica di Er(50Hz) < 10%
//Gc = (4*(1+s/(2*pi*6000)))/s

//FDT controllata ad anello chiuso
T_max=Tu_max*Gc;
T_min=Tu_min*Gc;
//FDT errore
E_max=1/(1+T_max);
E_min=1/(1+T_min);

// def sistemi lineari
LPF_max_s=syslin('c',LPF_max);
Gvg_max_s=syslin('c',Gvg_max);
Gvd_max_s=syslin('c',Gvd_max);
Zout_max_s=syslin('c',Zout_max);
Tu_max_s=syslin('c',Tu_max);
T_max_s=syslin('c',T_max);
E_max_s=syslin('c',E_max);

LPF_min_s=syslin('c',LPF_min);
Gvg_min_s=syslin('c',Gvg_min);
Gvd_min_s=syslin('c',Gvd_min);
Zout_min_s=syslin('c',Zout_min);
Tu_min_s=syslin('c',Tu_min);
T_min_s=syslin('c',T_min);
E_min_s=syslin('c',E_min);

Gc_s=syslin('c',Gc);

[pm1, fr_p1] = p_margin(T_max_s)
[gm1, fr_g1] = g_margin(T_max_s)
[pm2, fr_p2] = p_margin(T_min_s)
[gm2, fr_g2] = g_margin(T_min_s)

scf(1);
clf();
bode([Tu_max_s; Tu_min_s],1e-2,1e6,["Tu_max"; "Tu_min"]);
title('Bode plot of Tu')

scf(2);
clf();
bode([T_max_s; T_min_s],1e-2,1e12,["T_max"; "T_min"]);
title('Bode plot of T')

scf(3);
clf();
bode([E_max_s; E_min_s],1e-2,1e6,["E_max"; "E_min"]);
title('Bode plot of E')

scf(4);
bode(Gc_s,1e-2,1e6,"Gc");
title('Bode plot of Gc')



