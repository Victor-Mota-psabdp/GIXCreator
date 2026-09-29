SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE     PROCEDURE [dbo].[pPreAlert_Rel] 
(
@Num_Proc		VarChar(16)
)
AS
	Select 
		HIM.Num_Proc_HIM as Processo, Consig.Nome_Raz_Soc as Consignatario, HIM.Navio_HIM as Navio, Origem.Nome_Local as Origem, Dt_Previs as Chegada, 
		HIM.HAWB_HIM as House, Destino.Nome_Local as Destino, Shipper.Nome_Raz_Soc as Shipper, TT.Nome_Tp_Tx as Taxa, 
		Cte.Cd_Tp_Moeda as Moeda, Cast(Cte.Vlr_Org_HIM as smallmoney) as Valor_Tx, MIM.MAWB_MIM as Master, Dt_Saida_MIM Dt_Saida,
		Dt_Previs Data_Chegada_Estimada

	From 
		House_Imp_Mar as HIM 
		Join Pessoa as Consig on HIM.Cd_Consig_HIM = Consig.Cd_Pes 
		Join Master_Imp_Mar as MIM on MIM.Num_Proc_MIM = Left(HIM.Num_Proc_HIM, 14)
		Join Pessoa as Shipper on Shipper.Cd_Pes = HIM.Cd_Export_HIM 
		Join Localidade as Origem on Origem.Cd_Local = HIM.Cd_Org_HIM 
		Join Localidade as Destino on Destino.Cd_Local = HIM.Cd_Dst_HIM 
		Left Outer Join Cta_Cte_Hou_Imp_Mar as Cte on (Cte.Num_Proc_HIM = HIM.Num_Proc_HIM and Cte.Comp_RP_HIM = 'S' and Cte.Cd_Cred_Dev_HIM = HIM.Cd_Consig_HIM and Cte.DC_HIM = 'C')
		Left Outer Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Left Join Viagem VG on MIM.id_viagem=VG.id_viagem	
	Where
		HIM.Num_Proc_HIM = @Num_Proc






GO
