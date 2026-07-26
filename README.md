# 🎫 Ticket Machine — LIC

Projeto académico desenvolvido no âmbito da unidade curricular de
**Laboratório de Informática e Computadores (LIC)** da Licenciatura em
Engenharia Informática e de Computadores do ISEL.

## 📌 Sobre o projeto

O objetivo deste projeto foi desenvolver uma **máquina de venda de bilhetes
de comboio**, combinando hardware digital implementado numa FPGA com uma
aplicação de controlo desenvolvida em Kotlin.

A máquina permite ao utilizador selecionar uma estação de destino, escolher
entre um bilhete de ida ou ida e volta, introduzir moedas e realizar a compra.
O sistema controla a interação através de um teclado matricial e LCD, processa
o pagamento e envia a informação necessária para o mecanismo de emissão do
bilhete.

Além do funcionamento normal de venda, foi desenvolvido um **modo de
manutenção**, através do qual é possível testar o sistema, consultar os
contadores de moedas e bilhetes vendidos, reiniciar estatísticas e guardar
informação de forma persistente.

## ⚙️ Arquitetura

Uma das principais características do projeto é a utilização de uma
arquitetura híbrida **hardware/software**.

### Hardware — VHDL / FPGA

A componente de hardware foi desenvolvida em **VHDL** e implementada numa
placa **DE10-Lite**, baseada numa FPGA MAX 10.

Entre os principais módulos desenvolvidos encontram-se:

- Keyboard Reader para leitura do teclado matricial 4x4;
- Key Decode e lógica de varrimento do teclado;
- máquinas de estados para controlo dos diferentes módulos;
- Ring Buffer com disciplina FIFO;
- comunicação e transmissão série;
- Coin Acceptor;
- Port Expander LCD;
- Port Expander Ticket Dispenser;
- Shift Registers e Hold Registers.

### Software — Kotlin

O módulo de controlo da máquina foi desenvolvido em **Kotlin** e executado
num computador ligado ao sistema de hardware.

O software é responsável pela lógica de funcionamento da aplicação, incluindo:

- seleção das estações;
- cálculo do preço dos bilhetes;
- escolha entre ida e ida/volta;
- processamento das moedas introduzidas;
- controlo do LCD;
- comunicação com o mecanismo de emissão de bilhetes;
- modo de manutenção;
- estatísticas de moedas e bilhetes vendidos;
- persistência de dados em ficheiros;
- abstração do acesso ao hardware através de uma HAL.

## 🔄 Integração Hardware/Software

Um dos maiores desafios do projeto foi fazer com que componentes desenvolvidos
em tecnologias diferentes funcionassem como um único sistema.

O software comunica com os periféricos implementados na FPGA através de
protocolos definidos para transferência de dados, incluindo comunicação série
e mecanismos de sincronização/handshake.

Isto permitiu separar a lógica de alto nível da aplicação dos detalhes de
baixo nível relacionados com o funcionamento do hardware.

## 🧪 Testes e validação

Os módulos de hardware foram testados individualmente através de
**testbenches e simulações no ModelSim**, permitindo analisar máquinas de
estados, sinais de controlo, comunicação entre módulos e armazenamento de
dados.

A aplicação Kotlin foi também testada utilizando um simulador dos periféricos
antes da integração com a FPGA.

Por fim, o sistema completo foi testado na **DE10-Lite**, permitindo validar
a integração entre o software e o hardware e corrigir problemas encontrados
durante o desenvolvimento.

## 🧠 Competências desenvolvidas

Este projeto permitiu-me aprofundar conhecimentos em:

- desenvolvimento de sistemas digitais;
- programação em VHDL;
- programação em Kotlin;
- desenvolvimento e análise de máquinas de estados;
- FPGA e lógica programável;
- comunicação série;
- protocolos de comunicação e handshake;
- buffers FIFO e gestão de memória;
- interfaces com periféricos;
- abstração de hardware;
- arquitetura modular de software e hardware;
- criação de testbenches e simulação de circuitos digitais;
- debugging de sistemas hardware/software;
- integração de diferentes componentes num sistema completo;
- leitura de datasheets e documentação técnica;
- trabalho em equipa e documentação técnica.

Mais do que implementar uma máquina de venda de bilhetes, este projeto foi uma
introdução prática ao desenvolvimento de **sistemas computacionais completos**,
desde a lógica digital que interage diretamente com os periféricos até ao
software responsável pela lógica da aplicação.

## 🛠️ Tecnologias e ferramentas

- **Kotlin**
- **VHDL**
- **Intel Quartus Prime**
- **ModelSim**
- **FPGA DE10-Lite / MAX 10**
- **LCD 16x2**
- **Teclado matricial 4x4**
- Git / GitHub

## 🎓 Contexto académico

**Instituição:** Instituto Superior de Engenharia de Lisboa (ISEL)  
**Curso:** Licenciatura em Engenharia Informática e de Computadores  
**Unidade Curricular:** Laboratório de Informática e Computadores (LIC)  
**Ano letivo:** 2025/2026
