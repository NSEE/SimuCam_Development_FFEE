fdrm_mem_area_altsyncram_inst : fdrm_mem_area_altsyncram PORT MAP (
		aclr	 => aclr_sig,
		address	 => address_sig,
		byteena	 => byteena_sig,
		clock	 => clock_sig,
		data	 => data_sig,
		wren	 => wren_sig,
		q	 => q_sig
	);
