SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE		PROCEDURE spShippIntrCustosIA_Rel
(
@ProcessCUSTO	VarChar(16)
)
AS
	Select
		C.Num_Proc_SIA,
		C.Item,
		TX.Nome_Tp_Tx_Ing,
		C.Cd_Tp_Moeda_C,
		C.Vlr_C_SIA,
		C.Cd_Tp_Moeda_V,
		C.Vlr_V_SIA,
		O.Obs_SIA
	from
		Custo_SIA C 
		left join Tipo_Taxa 	 TX on TX.Cd_Tp_Tx = C.Cd_Tp_Tx
		left join Si_Imp_Aer	 O  on O.Num_Proc_SIA = C.Num_Proc_SIA
	where
		C.Num_Proc_SIA = @ProcessCUSTO
	Order by
		C.Item


GO
