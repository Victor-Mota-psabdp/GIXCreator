SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pAvisoExp_Rel
(
@Num_Proc		VarChar(16)
)
AS
	Select 
		HEM.Num_Proc_HEM as Processo, HEM.Navio_HEM as Navio, Origem.Nome_Local as Origem, Dt_Saida_MEM as Saida, 
		HEM.HAWB_HEM as House, Destino.Nome_Local as Destino, TT.Nome_Tp_Tx as Taxa, 
		Cte.Cd_Tp_Moeda as Moeda, Cte.Vlr_Org_HEM as Valor_Tx, MEM.MAWB_MEM as Master,
		Shipper.Nome_Raz_Soc as Shipper
	From 
		House_Exp_Mar as HEM Join Master_Exp_Mar as MEM on MEM.Num_Proc_MEM = Left(HEM.Num_Proc_HEM, 14)
		Join Pessoa as Shipper on Shipper.Cd_Pes = HEM.Cd_Export_HEM 
		Join Localidade as Origem on Origem.Cd_Local = HEM.Cd_Org_HEM 
		Join Localidade as Destino on Destino.Cd_Local = HEM.Cd_Dst_HEM 
		Join Cta_Cte_Hou_Exp_Mar as Cte on (Cte.Num_Proc_HEM = HEM.Num_Proc_HEM and Cte.Comp_RP_HEM = 'S' and Cte.Cd_Cred_Dev_HEM = HEM.Cd_Export_HEM and Cte.DC_HEM = 'C')
		Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
	Where
		HEM.Num_Proc_HEM = @Num_Proc

GO
