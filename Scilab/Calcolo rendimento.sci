clear;
clc;
close(winsid());


//SPEC "OPEN LOOP"
    Vi=3.3;  //[V]
    Vo=12;   //[V]
    Ro_min=100;     //[Ohm]
    Ro_max=1000;     //[Ohm]
    fsw=600e3;  //[Hz]
    Tsw=1/fsw;  //[s]
    Vo_rip_spec = 0.001*Vo;  //[V]

// 0) calcolo D (duty cycle) "ideale" e corrente Io
    D=1-Vi/Vo;   //adimensionale
    Io_min=Vo/Ro_max;  //[A]
    Io_max=Vo/Ro_min  //[A]


// trovo il delta iL massimo affinchè lavori in CCM e calcolo L_min
    delta_iL = Io_min/(1-D)*0.5;  //[A]
    L_min=(Vi*D)/(delta_iL*fsw);  //[H]

//L'induttore scelto ha una induttanza e una ESR pari a
    L=330E-6; //[H]
    RLESR=0.286;  //[Ohm]

//Ripple di vout, valutato
//a) su C (assumendo RCESR nulla) 
//b) su RCESR (assumendo C infinita)
    C_min = (Vo/(Vo_rip_spec))*((D*Tsw)/Ro_min)

    C=18E-6;  //[F]
    RCESR=0.030; //[Ohm]

//E' stato scelto un diodo schottcky con una Vgamma massima di 0.5V e
//La Ron è stata stimata dal grafico Vf If del diodo presente nel datasheet
    Vgamma=0.5;
    Ron_D=0.267;

//Le caratteristiche del MOS scelto sono
    Ron_Mos= 0.0085; //[Ohm]
    Vgs_on=3;  //[V]
    Ciss_Mos = 1210e-12;  //[F]
    Coss_Mos = 240e-12;  //[F]
    Crss_Mos = 120e-12;  //[F]
    
    Cgd=Crss_Mos;
    Cds=Coss_Mos-Cgd;
    Cgs=Ciss_Mos-Cgd;   
    
Iload = Io_max  //il rendimento sarà calcolato in corrispondenza della corrente Iload
//Stima Ploss
    //switching losses
Ploss_M_sw= fsw * (Cgs*Vgs_on^2 + Cds*Vi^2 + Cgd*(Vi+Vgs_on)^2)

//conduction losses
Ploss_M = D*Ron_Mos*(Iload/(1-D))^2     //[W]
Ploss_D = (1-D)*Vgamma*Iload + (1-D)*Ron_D*Iload^2    //[W]
Ploss_L = RLESR*(Iload/(1-D))^2         //[W]
Ploss_C = (Vo_rip_spec^2)/RCESR  //[W] approssimato

Ploss_tot = Ploss_M_sw + Ploss_M + Ploss_D + Ploss_L + Ploss_C  //[W]
Pout= Vo*Iload;  //[W]
Pin=Ploss_tot+Pout; // [W]
Efficiency= Pout/Pin  //adimensionale

//grafico a torta
loss_contribution=[Ploss_L,Ploss_C,Ploss_D,Ploss_M_sw,Ploss_M]./Ploss_tot;
pie(loss_contribution);
legend(['Inductor','Capacitor','Diode','MOSFET switching','MOSFET conduction'],4)


