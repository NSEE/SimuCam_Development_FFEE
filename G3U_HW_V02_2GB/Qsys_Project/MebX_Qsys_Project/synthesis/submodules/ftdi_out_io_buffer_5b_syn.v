// megafunction wizard: %ALTIOBUF%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: altiobuf_out 

// ============================================================
// File Name: ftdi_out_io_buffer_5b.v
// Megafunction Name(s):
// 			altiobuf_out
//
// Simulation Library Files(s):
// 			stratixiv
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 18.1.0 Build 625 09/12/2018 SJ Standard Edition
// ************************************************************


//Copyright (C) 2018  Intel Corporation. All rights reserved.
//Your use of Intel Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Intel Program License 
//Subscription Agreement, the Intel Quartus Prime License Agreement,
//the Intel FPGA IP License Agreement, or other applicable license
//agreement, including, without limitation, that your use is for
//the sole purpose of programming logic devices manufactured by
//Intel and sold by Intel or its authorized distributors.  Please
//refer to the applicable agreement for further details.


//altiobuf_out DEVICE_FAMILY="Stratix IV" ENABLE_BUS_HOLD="FALSE" LEFT_SHIFT_SERIES_TERMINATION_CONTROL="FALSE" NUMBER_OF_CHANNELS=5 OPEN_DRAIN_OUTPUT="FALSE" PSEUDO_DIFFERENTIAL_MODE="FALSE" USE_DIFFERENTIAL_MODE="FALSE" USE_OE="FALSE" USE_TERMINATION_CONTROL="FALSE" datain dataout
//VERSION_BEGIN 18.1 cbx_altiobuf_out 2018:09:12:13:04:24:SJ cbx_mgl 2018:09:12:13:10:36:SJ cbx_stratixiii 2018:09:12:13:04:24:SJ cbx_stratixv 2018:09:12:13:04:24:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463


//synthesis_resources = stratixiv_io_obuf 5 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  ftdi_out_io_buffer_5b_iobuf_out
	( 
	datain,
	dataout) /* synthesis synthesis_clearbox=1 */;
	input   [4:0]  datain;
	output   [4:0]  dataout;

	wire  [4:0]   wire_obufa_i;
	wire  [4:0]   wire_obufa_o;
	wire  [4:0]   wire_obufa_oe;
	wire  [4:0]  oe_w;

	stratixiv_io_obuf   obufa_0
	( 
	.i(wire_obufa_i[0:0]),
	.o(wire_obufa_o[0:0]),
	.obar(),
	.oe(wire_obufa_oe[0:0])
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.dynamicterminationcontrol(1'b0),
	.parallelterminationcontrol({14{1'b0}}),
	.seriesterminationcontrol({14{1'b0}})
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devoe(1'b1)
	// synopsys translate_on
	);
	defparam
		obufa_0.bus_hold = "false",
		obufa_0.open_drain_output = "false",
		obufa_0.shift_series_termination_control = "false",
		obufa_0.lpm_type = "stratixiv_io_obuf";
	stratixiv_io_obuf   obufa_1
	( 
	.i(wire_obufa_i[1:1]),
	.o(wire_obufa_o[1:1]),
	.obar(),
	.oe(wire_obufa_oe[1:1])
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.dynamicterminationcontrol(1'b0),
	.parallelterminationcontrol({14{1'b0}}),
	.seriesterminationcontrol({14{1'b0}})
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devoe(1'b1)
	// synopsys translate_on
	);
	defparam
		obufa_1.bus_hold = "false",
		obufa_1.open_drain_output = "false",
		obufa_1.shift_series_termination_control = "false",
		obufa_1.lpm_type = "stratixiv_io_obuf";
	stratixiv_io_obuf   obufa_2
	( 
	.i(wire_obufa_i[2:2]),
	.o(wire_obufa_o[2:2]),
	.obar(),
	.oe(wire_obufa_oe[2:2])
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.dynamicterminationcontrol(1'b0),
	.parallelterminationcontrol({14{1'b0}}),
	.seriesterminationcontrol({14{1'b0}})
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devoe(1'b1)
	// synopsys translate_on
	);
	defparam
		obufa_2.bus_hold = "false",
		obufa_2.open_drain_output = "false",
		obufa_2.shift_series_termination_control = "false",
		obufa_2.lpm_type = "stratixiv_io_obuf";
	stratixiv_io_obuf   obufa_3
	( 
	.i(wire_obufa_i[3:3]),
	.o(wire_obufa_o[3:3]),
	.obar(),
	.oe(wire_obufa_oe[3:3])
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.dynamicterminationcontrol(1'b0),
	.parallelterminationcontrol({14{1'b0}}),
	.seriesterminationcontrol({14{1'b0}})
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devoe(1'b1)
	// synopsys translate_on
	);
	defparam
		obufa_3.bus_hold = "false",
		obufa_3.open_drain_output = "false",
		obufa_3.shift_series_termination_control = "false",
		obufa_3.lpm_type = "stratixiv_io_obuf";
	stratixiv_io_obuf   obufa_4
	( 
	.i(wire_obufa_i[4:4]),
	.o(wire_obufa_o[4:4]),
	.obar(),
	.oe(wire_obufa_oe[4:4])
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.dynamicterminationcontrol(1'b0),
	.parallelterminationcontrol({14{1'b0}}),
	.seriesterminationcontrol({14{1'b0}})
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	// synopsys translate_off
	,
	.devoe(1'b1)
	// synopsys translate_on
	);
	defparam
		obufa_4.bus_hold = "false",
		obufa_4.open_drain_output = "false",
		obufa_4.shift_series_termination_control = "false",
		obufa_4.lpm_type = "stratixiv_io_obuf";
	assign
		wire_obufa_i = datain,
		wire_obufa_oe = oe_w;
	assign
		dataout = wire_obufa_o,
		oe_w = {5{1'b1}};
endmodule //ftdi_out_io_buffer_5b_iobuf_out
//VALID FILE


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module ftdi_out_io_buffer_5b (
	datain,
	dataout)/* synthesis synthesis_clearbox = 1 */;

	input	[4:0]  datain;
	output	[4:0]  dataout;

	wire [4:0] sub_wire0;
	wire [4:0] dataout = sub_wire0[4:0];

	ftdi_out_io_buffer_5b_iobuf_out	ftdi_out_io_buffer_5b_iobuf_out_component (
				.datain (datain),
				.dataout (sub_wire0));

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Stratix IV"
// Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "1"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Stratix IV"
// Retrieval info: CONSTANT: enable_bus_hold STRING "FALSE"
// Retrieval info: CONSTANT: left_shift_series_termination_control STRING "FALSE"
// Retrieval info: CONSTANT: number_of_channels NUMERIC "5"
// Retrieval info: CONSTANT: open_drain_output STRING "FALSE"
// Retrieval info: CONSTANT: pseudo_differential_mode STRING "FALSE"
// Retrieval info: CONSTANT: use_differential_mode STRING "FALSE"
// Retrieval info: CONSTANT: use_oe STRING "FALSE"
// Retrieval info: CONSTANT: use_termination_control STRING "FALSE"
// Retrieval info: USED_PORT: datain 0 0 5 0 INPUT NODEFVAL "datain[4..0]"
// Retrieval info: USED_PORT: dataout 0 0 5 0 OUTPUT NODEFVAL "dataout[4..0]"
// Retrieval info: CONNECT: @datain 0 0 5 0 datain 0 0 5 0
// Retrieval info: CONNECT: dataout 0 0 5 0 @dataout 0 0 5 0
// Retrieval info: GEN_FILE: TYPE_NORMAL ftdi_out_io_buffer_5b.vhd TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ftdi_out_io_buffer_5b.inc TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ftdi_out_io_buffer_5b.cmp TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ftdi_out_io_buffer_5b.bsf TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ftdi_out_io_buffer_5b_inst.vhd TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ftdi_out_io_buffer_5b_syn.v TRUE
// Retrieval info: LIB_FILE: stratixiv
