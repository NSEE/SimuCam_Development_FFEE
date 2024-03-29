	MebX_Qsys_Project u0 (
		.button_export                                               (<connected-to-button_export>),                                               //                               button.export
		.clk50_clk                                                   (<connected-to-clk50_clk>),                                                   //                                clk50.clk
		.comm_a_measurements_conduit_end_measurements_channel_signal (<connected-to-comm_a_measurements_conduit_end_measurements_channel_signal>), //      comm_a_measurements_conduit_end.measurements_channel_signal
		.comm_a_sync_end_sync_channel_signal                         (<connected-to-comm_a_sync_end_sync_channel_signal>),                         //                      comm_a_sync_end.sync_channel_signal
		.comm_b_measurements_conduit_end_measurements_channel_signal (<connected-to-comm_b_measurements_conduit_end_measurements_channel_signal>), //      comm_b_measurements_conduit_end.measurements_channel_signal
		.comm_b_sync_end_sync_channel_signal                         (<connected-to-comm_b_sync_end_sync_channel_signal>),                         //                      comm_b_sync_end.sync_channel_signal
		.comm_c_measurements_conduit_end_measurements_channel_signal (<connected-to-comm_c_measurements_conduit_end_measurements_channel_signal>), //      comm_c_measurements_conduit_end.measurements_channel_signal
		.comm_c_sync_end_sync_channel_signal                         (<connected-to-comm_c_sync_end_sync_channel_signal>),                         //                      comm_c_sync_end.sync_channel_signal
		.comm_d_measurements_conduit_end_measurements_channel_signal (<connected-to-comm_d_measurements_conduit_end_measurements_channel_signal>), //      comm_d_measurements_conduit_end.measurements_channel_signal
		.comm_d_sync_end_sync_channel_signal                         (<connected-to-comm_d_sync_end_sync_channel_signal>),                         //                      comm_d_sync_end.sync_channel_signal
		.comm_e_measurements_conduit_end_measurements_channel_signal (<connected-to-comm_e_measurements_conduit_end_measurements_channel_signal>), //      comm_e_measurements_conduit_end.measurements_channel_signal
		.comm_e_sync_end_sync_channel_signal                         (<connected-to-comm_e_sync_end_sync_channel_signal>),                         //                      comm_e_sync_end.sync_channel_signal
		.comm_f_measurements_conduit_end_measurements_channel_signal (<connected-to-comm_f_measurements_conduit_end_measurements_channel_signal>), //      comm_f_measurements_conduit_end.measurements_channel_signal
		.comm_f_sync_end_sync_channel_signal                         (<connected-to-comm_f_sync_end_sync_channel_signal>),                         //                      comm_f_sync_end.sync_channel_signal
		.csense_adc_fo_export                                        (<connected-to-csense_adc_fo_export>),                                        //                        csense_adc_fo.export
		.csense_cs_n_export                                          (<connected-to-csense_cs_n_export>),                                          //                          csense_cs_n.export
		.csense_sck_export                                           (<connected-to-csense_sck_export>),                                           //                           csense_sck.export
		.csense_sdi_export                                           (<connected-to-csense_sdi_export>),                                           //                           csense_sdi.export
		.csense_sdo_export                                           (<connected-to-csense_sdo_export>),                                           //                           csense_sdo.export
		.ctrl_io_lvds_export                                         (<connected-to-ctrl_io_lvds_export>),                                         //                         ctrl_io_lvds.export
		.dip_export                                                  (<connected-to-dip_export>),                                                  //                                  dip.export
		.ext_export                                                  (<connected-to-ext_export>),                                                  //                                  ext.export
		.ftdi_clk_clk                                                (<connected-to-ftdi_clk_clk>),                                                //                             ftdi_clk.clk
		.led_de4_export                                              (<connected-to-led_de4_export>),                                              //                              led_de4.export
		.led_painel_export                                           (<connected-to-led_painel_export>),                                           //                           led_painel.export
		.m1_ddr2_i2c_scl_export                                      (<connected-to-m1_ddr2_i2c_scl_export>),                                      //                      m1_ddr2_i2c_scl.export
		.m1_ddr2_i2c_sda_export                                      (<connected-to-m1_ddr2_i2c_sda_export>),                                      //                      m1_ddr2_i2c_sda.export
		.m1_ddr2_memory_mem_a                                        (<connected-to-m1_ddr2_memory_mem_a>),                                        //                       m1_ddr2_memory.mem_a
		.m1_ddr2_memory_mem_ba                                       (<connected-to-m1_ddr2_memory_mem_ba>),                                       //                                     .mem_ba
		.m1_ddr2_memory_mem_ck                                       (<connected-to-m1_ddr2_memory_mem_ck>),                                       //                                     .mem_ck
		.m1_ddr2_memory_mem_ck_n                                     (<connected-to-m1_ddr2_memory_mem_ck_n>),                                     //                                     .mem_ck_n
		.m1_ddr2_memory_mem_cke                                      (<connected-to-m1_ddr2_memory_mem_cke>),                                      //                                     .mem_cke
		.m1_ddr2_memory_mem_cs_n                                     (<connected-to-m1_ddr2_memory_mem_cs_n>),                                     //                                     .mem_cs_n
		.m1_ddr2_memory_mem_dm                                       (<connected-to-m1_ddr2_memory_mem_dm>),                                       //                                     .mem_dm
		.m1_ddr2_memory_mem_ras_n                                    (<connected-to-m1_ddr2_memory_mem_ras_n>),                                    //                                     .mem_ras_n
		.m1_ddr2_memory_mem_cas_n                                    (<connected-to-m1_ddr2_memory_mem_cas_n>),                                    //                                     .mem_cas_n
		.m1_ddr2_memory_mem_we_n                                     (<connected-to-m1_ddr2_memory_mem_we_n>),                                     //                                     .mem_we_n
		.m1_ddr2_memory_mem_dq                                       (<connected-to-m1_ddr2_memory_mem_dq>),                                       //                                     .mem_dq
		.m1_ddr2_memory_mem_dqs                                      (<connected-to-m1_ddr2_memory_mem_dqs>),                                      //                                     .mem_dqs
		.m1_ddr2_memory_mem_dqs_n                                    (<connected-to-m1_ddr2_memory_mem_dqs_n>),                                    //                                     .mem_dqs_n
		.m1_ddr2_memory_mem_odt                                      (<connected-to-m1_ddr2_memory_mem_odt>),                                      //                                     .mem_odt
		.m1_ddr2_memory_pll_ref_clk_clk                              (<connected-to-m1_ddr2_memory_pll_ref_clk_clk>),                              //           m1_ddr2_memory_pll_ref_clk.clk
		.m1_ddr2_memory_status_local_init_done                       (<connected-to-m1_ddr2_memory_status_local_init_done>),                       //                m1_ddr2_memory_status.local_init_done
		.m1_ddr2_memory_status_local_cal_success                     (<connected-to-m1_ddr2_memory_status_local_cal_success>),                     //                                     .local_cal_success
		.m1_ddr2_memory_status_local_cal_fail                        (<connected-to-m1_ddr2_memory_status_local_cal_fail>),                        //                                     .local_cal_fail
		.m1_ddr2_oct_rdn                                             (<connected-to-m1_ddr2_oct_rdn>),                                             //                          m1_ddr2_oct.rdn
		.m1_ddr2_oct_rup                                             (<connected-to-m1_ddr2_oct_rup>),                                             //                                     .rup
		.m2_ddr2_i2c_scl_export                                      (<connected-to-m2_ddr2_i2c_scl_export>),                                      //                      m2_ddr2_i2c_scl.export
		.m2_ddr2_i2c_sda_export                                      (<connected-to-m2_ddr2_i2c_sda_export>),                                      //                      m2_ddr2_i2c_sda.export
		.m2_ddr2_memory_mem_a                                        (<connected-to-m2_ddr2_memory_mem_a>),                                        //                       m2_ddr2_memory.mem_a
		.m2_ddr2_memory_mem_ba                                       (<connected-to-m2_ddr2_memory_mem_ba>),                                       //                                     .mem_ba
		.m2_ddr2_memory_mem_ck                                       (<connected-to-m2_ddr2_memory_mem_ck>),                                       //                                     .mem_ck
		.m2_ddr2_memory_mem_ck_n                                     (<connected-to-m2_ddr2_memory_mem_ck_n>),                                     //                                     .mem_ck_n
		.m2_ddr2_memory_mem_cke                                      (<connected-to-m2_ddr2_memory_mem_cke>),                                      //                                     .mem_cke
		.m2_ddr2_memory_mem_cs_n                                     (<connected-to-m2_ddr2_memory_mem_cs_n>),                                     //                                     .mem_cs_n
		.m2_ddr2_memory_mem_dm                                       (<connected-to-m2_ddr2_memory_mem_dm>),                                       //                                     .mem_dm
		.m2_ddr2_memory_mem_ras_n                                    (<connected-to-m2_ddr2_memory_mem_ras_n>),                                    //                                     .mem_ras_n
		.m2_ddr2_memory_mem_cas_n                                    (<connected-to-m2_ddr2_memory_mem_cas_n>),                                    //                                     .mem_cas_n
		.m2_ddr2_memory_mem_we_n                                     (<connected-to-m2_ddr2_memory_mem_we_n>),                                     //                                     .mem_we_n
		.m2_ddr2_memory_mem_dq                                       (<connected-to-m2_ddr2_memory_mem_dq>),                                       //                                     .mem_dq
		.m2_ddr2_memory_mem_dqs                                      (<connected-to-m2_ddr2_memory_mem_dqs>),                                      //                                     .mem_dqs
		.m2_ddr2_memory_mem_dqs_n                                    (<connected-to-m2_ddr2_memory_mem_dqs_n>),                                    //                                     .mem_dqs_n
		.m2_ddr2_memory_mem_odt                                      (<connected-to-m2_ddr2_memory_mem_odt>),                                      //                                     .mem_odt
		.m2_ddr2_memory_dll_sharing_dll_pll_locked                   (<connected-to-m2_ddr2_memory_dll_sharing_dll_pll_locked>),                   //           m2_ddr2_memory_dll_sharing.dll_pll_locked
		.m2_ddr2_memory_dll_sharing_dll_delayctrl                    (<connected-to-m2_ddr2_memory_dll_sharing_dll_delayctrl>),                    //                                     .dll_delayctrl
		.m2_ddr2_memory_pll_sharing_pll_mem_clk                      (<connected-to-m2_ddr2_memory_pll_sharing_pll_mem_clk>),                      //           m2_ddr2_memory_pll_sharing.pll_mem_clk
		.m2_ddr2_memory_pll_sharing_pll_write_clk                    (<connected-to-m2_ddr2_memory_pll_sharing_pll_write_clk>),                    //                                     .pll_write_clk
		.m2_ddr2_memory_pll_sharing_pll_locked                       (<connected-to-m2_ddr2_memory_pll_sharing_pll_locked>),                       //                                     .pll_locked
		.m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk        (<connected-to-m2_ddr2_memory_pll_sharing_pll_write_clk_pre_phy_clk>),        //                                     .pll_write_clk_pre_phy_clk
		.m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk                 (<connected-to-m2_ddr2_memory_pll_sharing_pll_addr_cmd_clk>),                 //                                     .pll_addr_cmd_clk
		.m2_ddr2_memory_pll_sharing_pll_avl_clk                      (<connected-to-m2_ddr2_memory_pll_sharing_pll_avl_clk>),                      //                                     .pll_avl_clk
		.m2_ddr2_memory_pll_sharing_pll_config_clk                   (<connected-to-m2_ddr2_memory_pll_sharing_pll_config_clk>),                   //                                     .pll_config_clk
		.m2_ddr2_memory_status_local_init_done                       (<connected-to-m2_ddr2_memory_status_local_init_done>),                       //                m2_ddr2_memory_status.local_init_done
		.m2_ddr2_memory_status_local_cal_success                     (<connected-to-m2_ddr2_memory_status_local_cal_success>),                     //                                     .local_cal_success
		.m2_ddr2_memory_status_local_cal_fail                        (<connected-to-m2_ddr2_memory_status_local_cal_fail>),                        //                                     .local_cal_fail
		.m2_ddr2_oct_rdn                                             (<connected-to-m2_ddr2_oct_rdn>),                                             //                          m2_ddr2_oct.rdn
		.m2_ddr2_oct_rup                                             (<connected-to-m2_ddr2_oct_rup>),                                             //                                     .rup
		.rs232_uart_rxd                                              (<connected-to-rs232_uart_rxd>),                                              //                           rs232_uart.rxd
		.rs232_uart_txd                                              (<connected-to-rs232_uart_txd>),                                              //                                     .txd
		.rst_reset_n                                                 (<connected-to-rst_reset_n>),                                                 //                                  rst.reset_n
		.rst_controller_conduit_reset_input_t_reset_input_signal     (<connected-to-rst_controller_conduit_reset_input_t_reset_input_signal>),     //   rst_controller_conduit_reset_input.t_reset_input_signal
		.rst_controller_conduit_simucam_reset_t_simucam_reset_signal (<connected-to-rst_controller_conduit_simucam_reset_t_simucam_reset_signal>), // rst_controller_conduit_simucam_reset.t_simucam_reset_signal
		.rtcc_alarm_export                                           (<connected-to-rtcc_alarm_export>),                                           //                           rtcc_alarm.export
		.rtcc_cs_n_export                                            (<connected-to-rtcc_cs_n_export>),                                            //                            rtcc_cs_n.export
		.rtcc_sck_export                                             (<connected-to-rtcc_sck_export>),                                             //                             rtcc_sck.export
		.rtcc_sdi_export                                             (<connected-to-rtcc_sdi_export>),                                             //                             rtcc_sdi.export
		.rtcc_sdo_export                                             (<connected-to-rtcc_sdo_export>),                                             //                             rtcc_sdo.export
		.sd_card_ip_b_SD_cmd                                         (<connected-to-sd_card_ip_b_SD_cmd>),                                         //                           sd_card_ip.b_SD_cmd
		.sd_card_ip_b_SD_dat                                         (<connected-to-sd_card_ip_b_SD_dat>),                                         //                                     .b_SD_dat
		.sd_card_ip_b_SD_dat3                                        (<connected-to-sd_card_ip_b_SD_dat3>),                                        //                                     .b_SD_dat3
		.sd_card_ip_o_SD_clock                                       (<connected-to-sd_card_ip_o_SD_clock>),                                       //                                     .o_SD_clock
		.sd_card_wp_n_io_export                                      (<connected-to-sd_card_wp_n_io_export>),                                      //                      sd_card_wp_n_io.export
		.spwc_a_leds_spw_red_status_led_signal                       (<connected-to-spwc_a_leds_spw_red_status_led_signal>),                       //                          spwc_a_leds.spw_red_status_led_signal
		.spwc_a_leds_spw_green_status_led_signal                     (<connected-to-spwc_a_leds_spw_green_status_led_signal>),                     //                                     .spw_green_status_led_signal
		.spwc_a_lvds_spw_data_in_signal                              (<connected-to-spwc_a_lvds_spw_data_in_signal>),                              //                          spwc_a_lvds.spw_data_in_signal
		.spwc_a_lvds_spw_data_out_signal                             (<connected-to-spwc_a_lvds_spw_data_out_signal>),                             //                                     .spw_data_out_signal
		.spwc_a_lvds_spw_strobe_out_signal                           (<connected-to-spwc_a_lvds_spw_strobe_out_signal>),                           //                                     .spw_strobe_out_signal
		.spwc_a_lvds_spw_strobe_in_signal                            (<connected-to-spwc_a_lvds_spw_strobe_in_signal>),                            //                                     .spw_strobe_in_signal
		.spwc_b_leds_spw_red_status_led_signal                       (<connected-to-spwc_b_leds_spw_red_status_led_signal>),                       //                          spwc_b_leds.spw_red_status_led_signal
		.spwc_b_leds_spw_green_status_led_signal                     (<connected-to-spwc_b_leds_spw_green_status_led_signal>),                     //                                     .spw_green_status_led_signal
		.spwc_b_lvds_spw_data_in_signal                              (<connected-to-spwc_b_lvds_spw_data_in_signal>),                              //                          spwc_b_lvds.spw_data_in_signal
		.spwc_b_lvds_spw_data_out_signal                             (<connected-to-spwc_b_lvds_spw_data_out_signal>),                             //                                     .spw_data_out_signal
		.spwc_b_lvds_spw_strobe_out_signal                           (<connected-to-spwc_b_lvds_spw_strobe_out_signal>),                           //                                     .spw_strobe_out_signal
		.spwc_b_lvds_spw_strobe_in_signal                            (<connected-to-spwc_b_lvds_spw_strobe_in_signal>),                            //                                     .spw_strobe_in_signal
		.spwc_c_leds_spw_red_status_led_signal                       (<connected-to-spwc_c_leds_spw_red_status_led_signal>),                       //                          spwc_c_leds.spw_red_status_led_signal
		.spwc_c_leds_spw_green_status_led_signal                     (<connected-to-spwc_c_leds_spw_green_status_led_signal>),                     //                                     .spw_green_status_led_signal
		.spwc_c_lvds_spw_data_in_signal                              (<connected-to-spwc_c_lvds_spw_data_in_signal>),                              //                          spwc_c_lvds.spw_data_in_signal
		.spwc_c_lvds_spw_data_out_signal                             (<connected-to-spwc_c_lvds_spw_data_out_signal>),                             //                                     .spw_data_out_signal
		.spwc_c_lvds_spw_strobe_out_signal                           (<connected-to-spwc_c_lvds_spw_strobe_out_signal>),                           //                                     .spw_strobe_out_signal
		.spwc_c_lvds_spw_strobe_in_signal                            (<connected-to-spwc_c_lvds_spw_strobe_in_signal>),                            //                                     .spw_strobe_in_signal
		.spwc_d_leds_spw_red_status_led_signal                       (<connected-to-spwc_d_leds_spw_red_status_led_signal>),                       //                          spwc_d_leds.spw_red_status_led_signal
		.spwc_d_leds_spw_green_status_led_signal                     (<connected-to-spwc_d_leds_spw_green_status_led_signal>),                     //                                     .spw_green_status_led_signal
		.spwc_d_lvds_spw_data_in_signal                              (<connected-to-spwc_d_lvds_spw_data_in_signal>),                              //                          spwc_d_lvds.spw_data_in_signal
		.spwc_d_lvds_spw_data_out_signal                             (<connected-to-spwc_d_lvds_spw_data_out_signal>),                             //                                     .spw_data_out_signal
		.spwc_d_lvds_spw_strobe_out_signal                           (<connected-to-spwc_d_lvds_spw_strobe_out_signal>),                           //                                     .spw_strobe_out_signal
		.spwc_d_lvds_spw_strobe_in_signal                            (<connected-to-spwc_d_lvds_spw_strobe_in_signal>),                            //                                     .spw_strobe_in_signal
		.spwc_e_leds_spw_red_status_led_signal                       (<connected-to-spwc_e_leds_spw_red_status_led_signal>),                       //                          spwc_e_leds.spw_red_status_led_signal
		.spwc_e_leds_spw_green_status_led_signal                     (<connected-to-spwc_e_leds_spw_green_status_led_signal>),                     //                                     .spw_green_status_led_signal
		.spwc_e_lvds_spw_data_in_signal                              (<connected-to-spwc_e_lvds_spw_data_in_signal>),                              //                          spwc_e_lvds.spw_data_in_signal
		.spwc_e_lvds_spw_data_out_signal                             (<connected-to-spwc_e_lvds_spw_data_out_signal>),                             //                                     .spw_data_out_signal
		.spwc_e_lvds_spw_strobe_out_signal                           (<connected-to-spwc_e_lvds_spw_strobe_out_signal>),                           //                                     .spw_strobe_out_signal
		.spwc_e_lvds_spw_strobe_in_signal                            (<connected-to-spwc_e_lvds_spw_strobe_in_signal>),                            //                                     .spw_strobe_in_signal
		.spwc_f_leds_spw_red_status_led_signal                       (<connected-to-spwc_f_leds_spw_red_status_led_signal>),                       //                          spwc_f_leds.spw_red_status_led_signal
		.spwc_f_leds_spw_green_status_led_signal                     (<connected-to-spwc_f_leds_spw_green_status_led_signal>),                     //                                     .spw_green_status_led_signal
		.spwc_f_lvds_spw_data_in_signal                              (<connected-to-spwc_f_lvds_spw_data_in_signal>),                              //                          spwc_f_lvds.spw_data_in_signal
		.spwc_f_lvds_spw_data_out_signal                             (<connected-to-spwc_f_lvds_spw_data_out_signal>),                             //                                     .spw_data_out_signal
		.spwc_f_lvds_spw_strobe_out_signal                           (<connected-to-spwc_f_lvds_spw_strobe_out_signal>),                           //                                     .spw_strobe_out_signal
		.spwc_f_lvds_spw_strobe_in_signal                            (<connected-to-spwc_f_lvds_spw_strobe_in_signal>),                            //                                     .spw_strobe_in_signal
		.spwc_g_leds_spw_red_status_led_signal                       (<connected-to-spwc_g_leds_spw_red_status_led_signal>),                       //                          spwc_g_leds.spw_red_status_led_signal
		.spwc_g_leds_spw_green_status_led_signal                     (<connected-to-spwc_g_leds_spw_green_status_led_signal>),                     //                                     .spw_green_status_led_signal
		.spwc_g_lvds_spw_data_in_signal                              (<connected-to-spwc_g_lvds_spw_data_in_signal>),                              //                          spwc_g_lvds.spw_data_in_signal
		.spwc_g_lvds_spw_data_out_signal                             (<connected-to-spwc_g_lvds_spw_data_out_signal>),                             //                                     .spw_data_out_signal
		.spwc_g_lvds_spw_strobe_out_signal                           (<connected-to-spwc_g_lvds_spw_strobe_out_signal>),                           //                                     .spw_strobe_out_signal
		.spwc_g_lvds_spw_strobe_in_signal                            (<connected-to-spwc_g_lvds_spw_strobe_in_signal>),                            //                                     .spw_strobe_in_signal
		.spwc_h_leds_spw_red_status_led_signal                       (<connected-to-spwc_h_leds_spw_red_status_led_signal>),                       //                          spwc_h_leds.spw_red_status_led_signal
		.spwc_h_leds_spw_green_status_led_signal                     (<connected-to-spwc_h_leds_spw_green_status_led_signal>),                     //                                     .spw_green_status_led_signal
		.spwc_h_lvds_spw_data_in_signal                              (<connected-to-spwc_h_lvds_spw_data_in_signal>),                              //                          spwc_h_lvds.spw_data_in_signal
		.spwc_h_lvds_spw_data_out_signal                             (<connected-to-spwc_h_lvds_spw_data_out_signal>),                             //                                     .spw_data_out_signal
		.spwc_h_lvds_spw_strobe_out_signal                           (<connected-to-spwc_h_lvds_spw_strobe_out_signal>),                           //                                     .spw_strobe_out_signal
		.spwc_h_lvds_spw_strobe_in_signal                            (<connected-to-spwc_h_lvds_spw_strobe_in_signal>),                            //                                     .spw_strobe_in_signal
		.ssdp_ssdp0                                                  (<connected-to-ssdp_ssdp0>),                                                  //                                 ssdp.ssdp0
		.ssdp_ssdp1                                                  (<connected-to-ssdp_ssdp1>),                                                  //                                     .ssdp1
		.sync_in_conduit                                             (<connected-to-sync_in_conduit>),                                             //                              sync_in.conduit
		.sync_out_conduit                                            (<connected-to-sync_out_conduit>),                                            //                             sync_out.conduit
		.sync_spw1_conduit                                           (<connected-to-sync_spw1_conduit>),                                           //                            sync_spw1.conduit
		.sync_spw2_conduit                                           (<connected-to-sync_spw2_conduit>),                                           //                            sync_spw2.conduit
		.sync_spw3_conduit                                           (<connected-to-sync_spw3_conduit>),                                           //                            sync_spw3.conduit
		.sync_spw4_conduit                                           (<connected-to-sync_spw4_conduit>),                                           //                            sync_spw4.conduit
		.sync_spw5_conduit                                           (<connected-to-sync_spw5_conduit>),                                           //                            sync_spw5.conduit
		.sync_spw6_conduit                                           (<connected-to-sync_spw6_conduit>),                                           //                            sync_spw6.conduit
		.sync_spw7_conduit                                           (<connected-to-sync_spw7_conduit>),                                           //                            sync_spw7.conduit
		.sync_spw8_conduit                                           (<connected-to-sync_spw8_conduit>),                                           //                            sync_spw8.conduit
		.temp_scl_export                                             (<connected-to-temp_scl_export>),                                             //                             temp_scl.export
		.temp_sda_export                                             (<connected-to-temp_sda_export>),                                             //                             temp_sda.export
		.timer_1ms_external_port_export                              (<connected-to-timer_1ms_external_port_export>),                              //              timer_1ms_external_port.export
		.timer_1us_external_port_export                              (<connected-to-timer_1us_external_port_export>),                              //              timer_1us_external_port.export
		.tristate_conduit_tcm_address_out                            (<connected-to-tristate_conduit_tcm_address_out>),                            //                     tristate_conduit.tcm_address_out
		.tristate_conduit_tcm_read_n_out                             (<connected-to-tristate_conduit_tcm_read_n_out>),                             //                                     .tcm_read_n_out
		.tristate_conduit_tcm_write_n_out                            (<connected-to-tristate_conduit_tcm_write_n_out>),                            //                                     .tcm_write_n_out
		.tristate_conduit_tcm_data_out                               (<connected-to-tristate_conduit_tcm_data_out>),                               //                                     .tcm_data_out
		.tristate_conduit_tcm_chipselect_n_out                       (<connected-to-tristate_conduit_tcm_chipselect_n_out>),                       //                                     .tcm_chipselect_n_out
		.umft601a_pins_umft_data_signal                              (<connected-to-umft601a_pins_umft_data_signal>),                              //                        umft601a_pins.umft_data_signal
		.umft601a_pins_umft_reset_n_signal                           (<connected-to-umft601a_pins_umft_reset_n_signal>),                           //                                     .umft_reset_n_signal
		.umft601a_pins_umft_rxf_n_signal                             (<connected-to-umft601a_pins_umft_rxf_n_signal>),                             //                                     .umft_rxf_n_signal
		.umft601a_pins_umft_clock_signal                             (<connected-to-umft601a_pins_umft_clock_signal>),                             //                                     .umft_clock_signal
		.umft601a_pins_umft_wakeup_n_signal                          (<connected-to-umft601a_pins_umft_wakeup_n_signal>),                          //                                     .umft_wakeup_n_signal
		.umft601a_pins_umft_be_signal                                (<connected-to-umft601a_pins_umft_be_signal>),                                //                                     .umft_be_signal
		.umft601a_pins_umft_txe_n_signal                             (<connected-to-umft601a_pins_umft_txe_n_signal>),                             //                                     .umft_txe_n_signal
		.umft601a_pins_umft_gpio_bus_signal                          (<connected-to-umft601a_pins_umft_gpio_bus_signal>),                          //                                     .umft_gpio_bus_signal
		.umft601a_pins_umft_wr_n_signal                              (<connected-to-umft601a_pins_umft_wr_n_signal>),                              //                                     .umft_wr_n_signal
		.umft601a_pins_umft_rd_n_signal                              (<connected-to-umft601a_pins_umft_rd_n_signal>),                              //                                     .umft_rd_n_signal
		.umft601a_pins_umft_oe_n_signal                              (<connected-to-umft601a_pins_umft_oe_n_signal>),                              //                                     .umft_oe_n_signal
		.umft601a_pins_umft_siwu_n_signal                            (<connected-to-umft601a_pins_umft_siwu_n_signal>)                             //                                     .umft_siwu_n_signal
	);

