SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--			 spPlasticosT6_Rel '10-25-2007'

-- Inclusão do campo Planta 03/08/09 - Rafael

CREATE Procedure [dbo].[spPlasticosT6_Rel] --'01/01/09'
(
	@Data datetime
)
As
	select 
		P.Num_Pedido															SAP,
		P.Num_PO																PO,
		HOU.Num_Proc_Him														Ref_BDP,
		Isnull(Peso_Liquido_Tot,0)/1000											Ton,
		Canal_Lim																Canal,
		HOU.Navio_HIM															Navio,
		LC.Nome_Local															PortoChegada,
		Isnull(ATA_LIM,ETA_LIM)													Chegada,
		dbo.fBusca_Historico(hou.num_proc_him,53,getdate())						SaidaNavio,
		dbo.fBusca_Tarefa(hou.num_proc_him,15)									PresencaCarga,
		NF.Data_DI																Data_DI,
		dbo.fBusca_Tarefa(hou.num_proc_him,4)									Desembaraco,
		Null																	DataCI,
		Null																	RecebimentoCI,
		Isnull(dbo.fBusca_Historico(hou.num_proc_him,54,getdate()),ETA_Lim +7)	Previsao,
		Null																	Entrega,
		Null																	DepositoDataReal,	
		Dt_Pedido																Data_PO,
		dbo.fBusca_HistoricoDescr(hou.num_proc_him,54,getdate())				Motivo_Atraso,
		P.Planta
	from
		House_Imp_Mar HOU with(nolock)
	Join LLP_Imp_Mar						LLP with(nolock)	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Join Job_Imp_Mar						JIM with(nolock)	on HOU.Num_Proc_HIM = JIM.Num_Proc_HIM
	Left Outer Join container_hou_Imp_mar CO with(nolock) on HOU.Num_Proc_HIM = CO.Num_Proc_HIM
	Left Outer Join Nota_Cliente 			NF with(nolock)	on HOU.Num_Proc_HIM = NF.Num_Proc
	Left Outer Join Armador					ARM with(nolock)	on JIM.Cd_Armador   = ARM.Cd_Armador
	Join Pedido_Ship 						PS with(nolock)	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido								P with(nolock)	on PS.Cd_Pedido	    = P.Cd_Pedido
	Join Pedido_Det							PD with(nolock) 	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Left Outer Join Localidade				LC with(nolock)	on Hou.Cd_Dst_HIM   = LC.Cd_Local
	Join Produto_Cliente					PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Join De_Para_Produto 					DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
	--Left Outer Join PO_HIM				PO	on PO.Num_proc_HIM = HOU.Num_proc_HIM and PO.ID_DC = 1
	where 
		convert(datetime,Dt_Emis_HIM,105) > @Data 
			--and PD.PO_GRP IN ('041')
			and (P.Planta IN ('05031WQ','05031WJ'))
	Group by
		HOU.Num_Proc_HIM,
		P.Num_PO,
		P.Num_Pedido,
		HOU.Navio_HIM,
		ARM.Nome_Armador,
		LC.Nome_Local,
		NF.Data_DI,
		NF.DI,
		LLP.Canal_LIM,
		PS.Cd_Produto,
		PS.Cd_Pedido,
		Peso_Liquido_Tot,
		ATA_LIM,
		ETA_LIM,
		Dt_Pedido,
		P.Planta

















GO
