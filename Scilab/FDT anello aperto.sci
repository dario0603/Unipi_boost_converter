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
    E_max=Vo-s*L*Io_min/(1-D)^2;
    J_max=Io_max/(1-D)^2;
    E_min=Vo-s*L*Io_max/(1-D)^2;
    J_min=Io_min/(1-D)^2;
    M=1/(1-D);
    Leq=L/(1-D)^2;

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
Tu_max=H*Gvd_max*(1/VM);
Tu_min=H*Gvd_min*(1/VM);

// def sistemi lineari
LPF_max_s=syslin('c',LPF_max);
Gvg_max_s=syslin('c',Gvg_max);
Gvd_max_s=syslin('c',Gvd_max);
Zout_max_s=syslin('c',Zout_max);

LPF_min_s=syslin('c',LPF_min);
Gvg_min_s=syslin('c',Gvg_min);
Gvd_min_s=syslin('c',Gvd_min);
Zout_min_s=syslin('c',Zout_min);

scf(1);
clf();
bode([LPF_max_s; LPF_min_s],1e2,1e6,["LPF_max"; "LPF_min"]);
title('Bode plot of LPF')

scf(2);
clf();
bode([Gvg_max_s; Gvg_min_s],1e2,1e6,["Gvg_max"; "Gvg_min"]);
title('Bode plot of Gvg')

scf(3);
clf();
bode([Gvd_max_s; Gvd_min_s],1e2,1e6,["Gvd_max"; "Gvd_min"]);
title('Bode plot of Gvd')

scf(4);
clf();
bode([Zout_max_s; Zout_min_s],1e2,1e6,["Zout_max"; "Zout_min"]);
title('Bode plot of Zout')


