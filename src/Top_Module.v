`timescale 1ns / 1ps

// Lets add beq,shift left,sub and mul instructions to our processor.
// MUL instruction has format {6 bits of Opcode,5 bits for Source Register1,5 bits for Source Register2,5 bits for Destination Register,5 bits for Shamt,6 bits for func} 
// Lets R type Instructions' opcode be 111111
// Say for sub func is 010101
// Say for mul func is 100001
// Say for shift func is 101010
// BEQ instruction has format (6 bits of opcode,5 bits for source register 1,5 bits for Source Register2,16 bits for jump address)
// Let BEQ instruction opcode be 011110
// BEQ address is caluclated by adding the 32 bit PC+4 to signed extended 16 bit immediate data which was left shifted by 2 bits
// Order first update control signals, then ALU, then add the extra MUXES, then the pipeline registers, then flush

module Top_Module(
    input clk,
    input reset
    );

reg [73:0] IF_ID;
reg [147:0] ID_EX;
reg [73:0] EX_MEM;
reg [70:0] MEM_WB;
reg [31:0] PC;
wire [31:0] Instruction_Code;
wire [31:0] Read_Data_1;
wire [31:0] Read_Data_2;
wire [31:0] Sign_Extended_Data;
reg [31:0] J_Address;
wire [31:0] ALU_Result;
wire Zero_Flag;
wire [31:0] Read_Data;
wire [31:0] WB_Address;
wire [31:0] WB_Data;
wire [9:0] Control_Signal;
wire [1:0] ALU_MUX1;
wire [1:0] ALU_MUX2;
reg [31:0] ALU_MUXout1;
reg [31:0] ALU_MUXout2;
wire stall;
reg [1:0] PC_MUX;
wire [31:0] shiftamt;
reg [4:0] Destregister;
reg [31:0] ALU_In2;
reg [31:0] Beq_Address;


//always@(posedge clk or posedge reset) begin
//    if(reset) PC_MUX <=2'b00;
//    else PC_MUX<= {ID_EX[8]&&Zero_Flag,Control_Signal[8]};
//end
    always@(posedge clk or posedge reset) begin
        if(reset) begin
            PC<=0;
            IF_ID<=0;
            ID_EX<=0;
            EX_MEM<=0;
            MEM_WB<=0;
            J_Address <=0; 
            Beq_Address <= 0;

        end
        else begin
            case({EX_MEM[73]&&Zero_Flag,0}) 
                2'b00:begin
                        if(stall) PC<=PC;
                        else PC<= PC+4;
                    end
                2'b01: PC<= J_Address;
                2'b10: PC<=Beq_Address;
                2'b11: PC<=Beq_Address;
            endcase
        end
    end
    
    
    
    Instruction_Memory Imem( 
    .PC(PC), 
    .reset(reset), 
    .Instruction_Code(Instruction_Code)
    ); 
    
    always@(*) begin
        J_Address = {PC[31:28], Instruction_Code[25:0], 2'b00}; //{Last 4 bits of PC,25:16 bit of IC,15:0 bits of IC, appended with two zeroes}
    end
    
    Stall_Unit stallunit(
    .ID_EX_MemRead(ID_EX[9]),
    .ID_EX_RegRt(ID_EX[42:38]),
    .IF_ID_RegRt(IF_ID[27:23]),
    .IF_ID_RegRs(IF_ID[32:28]),
    .Control_MemRead(IF_ID[9]),
    .Control_WE_Datamem(IF_ID[3]),
    .stall(stall)
    );

    Control_Unit controlunit(
    .Opcode(Instruction_Code[31:26]),   
    .func(Instruction_Code[5:0]),                   
    .Control_Signal(Control_Signal)  //Control Signal Format {MEM_READ,PC_MUX,WE_REGFILE,WE_DATAMEM,ALU_CONTROL 2 BITS,WB_MUX}
    );
    
    always@(posedge clk) begin
        if(stall) begin
            IF_ID <= IF_ID; 
        end
        else begin
            IF_ID <= {PC[31:0],Instruction_Code,Control_Signal[9:0]}; //32 bits Instruction Code + 10 bits of Control_Signals
        end
        
    end

    
    Register_file regfile(
    .Write_Enable(MEM_WB[1]),           //WE_REGFILE
    .clk(clk),
    .reset(reset),
    .Read_Reg_Num_1(IF_ID[35:31]),      // Rs(Source Reg)
    .Read_Reg_Num_2(IF_ID[30:26]),      // Rt(Destination Reg/Source Reg2)
    .Write_Reg_Num(MEM_WB[6:2]),        // Write Reg Num from MEM/WB stage
    .Write_Data(WB_Data),               // Write Data from MEM/WB stage
    .Read_Data_1(Read_Data_1),
    .Read_Data_2(Read_Data_2)
    );
    
    Sign_Extend16 signextend(
    .Signed_Data(IF_ID[25:10]),          //Imm(offset)
    .out(Sign_Extended_Data)
    );
    
    Extend5 extendshiftamount(
    .shamt(IF_ID[20:16]),
    .out(shiftamt)
    );
    
    always@(*) begin
         case(IF_ID[1])
            1'b0: Destregister = IF_ID[30:26];
            1'b1: Destregister = IF_ID[25:21];
         endcase 
    end

    always@(posedge clk) begin
        if(stall) ID_EX <= {IF_ID[73:42],shiftamt,Read_Data_1, Read_Data_2, IF_ID[35:26],IF_ID[25:21],Sign_Extended_Data, 10'b0};
        //{Read Data 1(32 bits),Read Data 2 (32 bits), Rs,Rt registers for Forwarding unit,32 bits of sign extended data,MEM_READ,PC_MUX,WE_REGFILE,WE_DATAMEM,ALU_CONTROL,WB_MUX,RegWriteALUSrc,Shift}
        else ID_EX <= {IF_ID[73:42],shiftamt,Read_Data_1, Read_Data_2, IF_ID[35:31],Destregister,Sign_Extended_Data, IF_ID[9:0]};
    end    
    
    Forwarding_Unit forwardingunit(
        .EX_MEM_RegWrite(EX_MEM[2]),
        .EX_MEM_RegRd(EX_MEM[7:3]),
        .MEM_WB_RegWrite(MEM_WB[1]),
        .MEM_WB_RegRd(WB_Reg),
        .ID_EX_RegRs(ID_EX[51:47]),
        .ID_EX_RegRt(ID_EX[46:42]),
        .ALU_MUX1(ALU_MUX1),
        .ALU_MUX2(ALU_MUX2)
    );
    
    
    always@(*) begin
        case(ALU_MUX1) 
        2'b00:ALU_MUXout1 = ID_EX[115:84];
        2'b01:ALU_MUXout1 = EX_MEM[71:40];
        2'b10:ALU_MUXout1 = MEM_WB[0]?MEM_WB[38:7]:MEM_WB[70:39];
        default:ALU_MUXout1 = ID_EX[111:80];
        endcase
    end
    
    ALU alu(
        .reset(reset),
        .A(ALU_MUXout1), 
        .B(ALU_In2),
        .Control_Input(ID_EX[5:3]), //ALU_Control
        .ALU_Result(ALU_Result),
        .Zero_Flag(Zero_Flag)
    );
    
    always@(*) begin
        case(ALU_MUX2) 
        2'b00:ALU_MUXout2 = ID_EX[83:52];
        2'b01:ALU_MUXout2 = EX_MEM[71:40];
        2'b10:ALU_MUXout2 = MEM_WB[0]?MEM_WB[38:7]:MEM_WB[70:39];
        default:ALU_MUXout2 = ID_EX[83:52];
        endcase
    end
    
    always@(*) begin
        case({ID_EX[1],ID_EX[0]}) 
        2'b00:ALU_In2 = ID_EX[41:10];
        2'b10:ALU_In2 = ALU_MUXout2;
        2'b11:ALU_In2 = ID_EX[147:116];
        default:ALU_In2 = ID_EX[41:10];
        endcase
    end
    
    always@(*) begin
        Beq_Address = ID_EX[147:116]+(ID_EX[41:10]<<2);
    end
    
    always@(posedge clk) begin
        EX_MEM <= {ID_EX[8],Zero_Flag,ALU_Result,ALU_MUXout2,ID_EX[46:42],ID_EX[7],ID_EX[6],ID_EX[2]}; 
        //{Zero Flag,32 bits ALU result(will also act as the address for lw and sw,Read Data 2 of 32 bits(Corresponds to the data in the source reg 1 for the sw), Write Reg,WE_Regfile,WE_Datamem,WB_MUX}
    end
    
    Data_Memory datamem(
    .Write_Enable(EX_MEM[1]),
    .clk(clk),
    .reset(reset),
    .Address(EX_MEM[71:40]),
    .Write_Data(EX_MEM[39:8]),
    .Read_Data(Read_Data)
    );
    
    always@(posedge clk) begin
        MEM_WB <= {Read_Data,EX_MEM[71:40],EX_MEM[7:3],EX_MEM[2],EX_MEM[0]}; //{Read data from datamem,ALU Result,Write Reg address,WE_Regfile,WB_MUX}
    end 
    
     assign WB_Data = MEM_WB[0]?MEM_WB[38:7]:MEM_WB[70:39];
     assign wbdata = WB_Data;

endmodule
