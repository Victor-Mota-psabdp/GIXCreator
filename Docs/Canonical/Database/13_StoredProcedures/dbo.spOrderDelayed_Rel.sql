SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE	  Procedure	 spOrderDelayed_Rel  --'10-25-2007'

(
	@Data datetime
)

As
	select 
		P.Num_Pedido		SAP,
		HOU.Num_Proc_Hem	Ref_BDP,
		LLP.Canal_LEM		Canal,
		HOU.Navio_HEM		Navio,
		LC.Nome_Local		PortoChegada,		
		LLP.ATD_LEM		DataEmbarque,
		LLP.ETA_LEM		Previsao,
		LLP.ATA_LEM		Entrega
	from
		House_Exp_Mar HOU

	Join LLP_Exp_Mar		LLP	on HOU.Num_Proc_HEM = LLP.Num_Proc_LEM
	Join Pedido_Ship 		PS	on HOU.Num_Proc_HEM = PS.Num_Proc
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Left Outer Join Localidade	LC	on Hou.Cd_Dst_HEM = Lc.Cd_Local
	
	where 
		convert(datetime,Dt_Emis_Hem,105) > @Data

Union All

	select 
		P.Num_Pedido		SAP,
		HOU.Num_Proc_HIM	Ref_BDP,
		LLP.Canal_LIM		Canal,
		HOU.Navio_HIM		Navio,
		LC.Nome_Local		PortoChegada,		
		LLP.ATD_LIM		DataEmbarque,
		LLP.ETA_LIM		Previsao,
		LLP.ATA_LIM		Entrega
	from
		House_Imp_Mar HOU

	Join LLP_Imp_Mar		LLP	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Join Pedido_Ship 		PS	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido			P	on PS.Cd_Pedido = P.Cd_Pedido
	Left Outer Join Localidade	LC	on Hou.Cd_Dst_HIM = Lc.Cd_Local
	
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data



GO
