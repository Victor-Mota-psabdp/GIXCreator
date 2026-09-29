SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO






CREATE		PROCEDURE spShippIntrCustosIM_Rel

(
@ProcessCUSTO	VarChar(16)
)
AS
	Select
		C.Num_Proc_SIM,
		C.Item_Cont,
		TC.Nome_Tp_Cont,
		TX.Nome_Tp_Tx_Ing,
		C.Cd_Tp_Moeda_C,
		C.Vlr_C_SIM,
		C.Cd_Tp_Moeda_V,
		C.Vlr_V_SIM,
		O.Obs_SIM
	from
		Custo_SIM C 

		left join Container_SIM	 CS on CS.Item_Cont = C.Item_Cont AND CS.num_proc_sim = C.num_proc_sim 
		left join Tipo_Container TC on TC.Cd_Tp_Cont = CS.Cd_Tp_Cont 
		left join Tipo_Taxa 	 TX on TX.Cd_Tp_Tx = C.Cd_Tp_Tx
		left join Si_Imp_Mar	 O  on O.Num_Proc_SIM = C.Num_Proc_SIM
	where
		C.Num_Proc_SIM = @ProcessCUSTO
	Order by
		C.Item_Cont







GO
