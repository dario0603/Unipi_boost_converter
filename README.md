# DC-DC Boost Converter with Closed-Loop Control

<p align="left">
  <a href="#"><img src="https://img.shields.io/badge/Simulator-LTspice-003366?style=flat" alt="LTspice"></a>
  <a href="#"><img src="https://img.shields.io/badge/Modeling-Scilab%20%2F%20Xcos-00599C?style=flat" alt="Scilab/Xcos"></a>
  <a href="#"><img src="https://img.shields.io/badge/Status-Completed-success?style=flat" alt="Status"></a>
  <a href="./Relazione/Boost_converter.pdf"><img src="https://img.shields.io/badge/Report-PDF-red?style=flat&logo=adobe-acrobat-reader&logoColor=white" alt="Report PDF"></a>
</p>

Academic project developed for the **University of Pisa** focused on the design, loss analysis, small-signal dynamic modeling, and closed-loop control of a high-efficiency **DC-DC Boost Converter**.

---

## Project Specifications

* **Input Voltage ($V_{\text{in}}$):** 3.3 V
* **Output Voltage ($V_{\text{out}}$):** 12.0 V
* **Switching Frequency ($f_{\text{sw}}$):** 600 kHz
* **Load Resistance Range ($R_o$):** $100\,\Omega$ to $1000\,\Omega$
* **Operation Mode:** Continuous Conduction Mode (CCM)
* **Output Voltage Ripple:** $< 0.1 \cdot V_{\text{out}} = 12\text{ mV}$
* **Target Efficiency:** $>70$% (Achieved: $87.5$% to $94.3$%)

---

## Power Stage Design & Component Selection

The power stage was dimensioned in worst-case operating conditions to counteract component derating and parasitic effects:

* **Inductor ($L_1$):** Coilcraft RFS1317-334KL ($330\,\mu\text{H}$, $\text{DCR} = 286\text{ m}\Omega$), guaranteeing CCM operation up to $7.2\text{ k}\Omega$ load.
* **Capacitor ($C_1$):** Panasonic 100SXE18M ($18\,\mu\text{F}$, $\text{ESR} = 30\text{ m}\Omega$, $100\text{ V}$) to meet the output ripple constraint.
* **Transistor ($M_1$):** Infineon IRFH7921 N-Channel MOSFET ($V_{\text{DS,max}} = 30\text{ V}$, $R_{\text{DS(on)}} = 8.5\text{ m}\Omega$).
* **Diode ($D_1$):** Infineon BAS3005A-02V Schottky Diode ($I_{\text{max}} = 500\text{ mA}$, $V_{\gamma} \approx 0.5\text{ V}$, $R_D = 267\text{ m}\Omega$).

| Ideal Converter Schematic | Lossy Converter Schematic |
| :---: | :---: |
| <img src="./Relazione/img/Boost%20conv.png" width="100%" alt="Ideal Boost Schematic"> | <img src="./Relazione/img/Boost%20conv%20losses%20LTSpice.png" width="100%" alt="Lossy Boost Schematic"> |

---

## Small-Signal Modeling & Control Loop Design

To ensure closed-loop stability across full load variation, small-signal state-space averaging was applied to derive the control-to-output transfer function $G_{vd}(s)$, line-to-output $G_{vg}(s)$, and output impedance $Z_{\text{out}}(s)$.

Because the uncompensated loop $T_u(s)$ exhibits a negative phase margin ($\phi_{m} \in [-28.6^{\circ}, -2.95^{\circ}]$), an analog **Type-III Compensator** (2 zeros, 3 poles) was synthesized:

$$G_c(s) = \frac{\left(1 + \frac{s}{2\pi \cdot 0.25}\right)\left(1 + \frac{s}{2\pi \cdot 1000}\right)}{s \left(1 + \frac{s}{2\pi \cdot 60000}\right)\left(1 + \frac{s}{2\pi \cdot 600000}\right)}$$

* **Phase Margin ($\phi_m$):** $26.9^{\circ}$ (worst-case) to $63.0^{\circ}$
* **Gain Margin ($M_g$):** $3.2\text{ dB}$ (worst-case) to $23.2\text{ dB}$
* **Steady-State Error ($\epsilon_r$):** $0\%$ DC error, $<10\%$ at $50\text{ Hz}$

| Type-III Op-Amp Circuit Architecture | Open-Loop vs Compensated Bode Response |
| :---: | :---: |
| <img src="./Relazione/img/Laplace compensatore opamp.png" width="100%" alt="Type-III Compensator Circuit"> | <img src="./Relazione/img/bode%20diagrams%20CL.png" width="100%" alt="Compensated Bode Diagrams"> |

---

## Dynamic Simulations & Transient Response

Closed-loop stability and reference step tracking were validated using both **Scilab/Xcos** numerical block diagrams and full transient **LTspice** simulations.

### 1. Xcos Dynamic Models & Step Response

| System Model | Step Response Output |
| :---: | :---: |
| **Open-Loop Model**<br><img src="./Relazione/img/XCOS%20modello%20open%20loop.png" width="100%" alt="Xcos Open Loop Model"> | **Open-Loop Response**<br><img src="./Relazione/img/XCOS%20risposta%20open%20loop.png" width="100%" alt="Xcos Open Loop Response"> |
| **Closed-Loop Model**<br><img src="./Relazione/img/XCOS%20modello%20closed%20loop.png" width="100%" alt="Xcos Closed Loop Model"> | **Closed-Loop Response**<br><img src="./Relazione/img/XCOS%20risposta%20closed%20loop.png" width="100%" alt="Xcos Closed Loop Response"> |

---

### 2. Full Circuit LTspice Closed-Loop Transient Response

| LTspice Closed-Loop Transient Simulation |
| :---: |
| <img src="./Relazione/img/simulazione%20anello%20chiuso.png" width="100%" alt="LTspice Closed Loop Transient"> |

---

## Repository Structure

```text
.
├── LTSpice/                                 # LTspice simulations (.asc, .raw)
├── Relazione/                               # Documentation & figures
│   ├── Boost_converter.pdf                  # PDF report
│   ├── main.tex                             # LaTeX source
│   └── img/                                 # Circuit schematics & plots
├── Scilab/                                  # Scilab scripts & Xcos models (.sci, .zcos)
└── README.md
