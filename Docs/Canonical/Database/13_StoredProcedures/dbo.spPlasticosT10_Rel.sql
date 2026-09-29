SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Incluido o campo de Planta - 03/08/09 - Rafael

CREATE    Procedure	[dbo].[spPlasticosT10_Rel] --'01-01-2008'
(
@Data datetime
)
As

Select 
	dbo.FStatus_Plasticos(hou.num_proc_him,getdate())						Divisao,
	HOU.Num_Proc_HIM														Ref_BDP,
	P.Num_PO																PU,
	sum(isnull(PD.Peso_Liquido_TOT,0))										Peso_Liquido,
	isnull(LLP.ATD_LIM,LLP.ETD_LIM)											Data_Embarque,
	Isnull(LLP.ATA_LIM,LLP.ETA_LIM)											Atracacao,
	Isnull(dbo.fBusca_Historico(hou.num_proc_him,54,getdate()),ETA_Lim +7)	Previsao,
	HOU.Navio_HIM															Navio,
	dbo.fBusca_HistoricoDescr(hou.num_proc_him,54,getdate())				Motivo_Atraso,
	P.Planta
from
	House_IMP_MAR HOU
	Left Outer Join LLP_IMP_MAR		LLP	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Outer Join Pessoa_LLP		DV 	on HOU.Cd_Export_HIM = DV.Cd_Pes
	Join Pedido_Ship 				PS	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido_Det					PD 	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Join Pedido						P	on PS.Cd_Pedido = P.Cd_Pedido
	Join Produto_Cliente			PC	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 			DPP	on PC.Cd_Proc_Cliente = DPP.GMID
where 
	convert(datetime,Dt_Emis_HIM,105) > @Data and (P.Planta IN ('05031WQ','05031WJ'))
	AND HOU.Cd_Dst_HIM = 'SSZ' and dbo.FStatus_Plasticos(hou.num_proc_him,getdate())='ALTERADA'

Group by
	HOU.Num_Proc_HIM,
	P.Num_PO,
	PD.Peso_Liquido_TOT,
	LLP.ATD_LIM,LLP.ETD_LIM,
	LLP.ATA_LIM,LLP.ETA_LIM,
	HOU.Navio_HIM,
	P.Planta









GO
