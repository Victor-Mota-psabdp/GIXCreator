SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE Procedure	[dbo].[spPlasticosT7_Rel] --'01-01-2008'
(
	@Data datetime
)
As
	select 
		Num_Pedido								RefCliente,
		HOU.Num_Proc_HIM						Processo, 
		Null									RefRepresentante,
		HOU.HAWB_HIM							House,
		HOU.MAWB_HIM							Master,
		NF.Data_DI								Data_DI,
		NF.DI									DI,
		DS.Nome_Local							Local_Entrada,
		dbo.fBusca_Tarefa(hou.num_proc_him,4)	Desembaraco,
		LLP.Canal_LIM							Canal,
		convert(datetime,HOU.Dt_Emis_HIM,105)	Data_Emissao,
		Null									DataEntregaTransporte,
		Null									DtEnvioFaturamento,
		TM.Nome_Terminal						Armazem,
		NF.Nota_Fiscal							Nota_Fiscal,
		Left(HOU.Num_Proc_HIM,2)				Tipo_Processo,
		HOU.Qtd_Tot_Vol_HIM						Qtd_Volume
		--P.Planta
	from
		House_IMP_MAR HOU with(nolock)
	Join LLP_IMP_Mar							LLP with(nolock)	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Left Outer Join	JOB_IMP_Mar					JOB with(nolock)	on HOU.Num_Proc_HIM = JOB.Num_Proc_HIM
	Left Outer Join Nota_Cliente 				NF with(nolock)	on HOU.Num_Proc_HIM = NF.Num_Proc 
	Left Outer Join Pedido_Ship 				PS with(nolock)	on HOU.Num_Proc_HIM = PS.Num_Proc
	Left Outer Join Pedido						P with(nolock)	on PS.Cd_Pedido = P.Cd_Pedido
	Join Pedido_Det								PD with(nolock) 	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Left Outer Join Nota_Fiscal_Cliente_Det		NFD with(nolock) on NFD.ID_NF=NF.ID_NF and NFD.CD_Produto = PS.Cd_Produto
	Join Produto_Cliente						PC with(nolock)	on PS.Cd_Produto =PC.Cd_Prod
	Left Outer Join De_Para_Produto				DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
	Left Outer Join Localidade					DS with(nolock)	on HOU.Cd_Dst_HIM = DS.Cd_Local
	Left Outer Join Terminal					TM with(nolock)	on LLP.Cd_Terminal = TM.Cd_Terminal
	--Left Outer Join PO_HIM					PO	on PO.Num_proc_HIM = HOU.Num_proc_HIM and PO.ID_DC = 1	
	where 
		--and (P.Planta IN ('05031WQ','05031WJ'))
		convert(datetime,Dt_Emis_HIM,105) > @Data 
		and PD.PO_GRP IN ('041')
		
	Group by 
		Num_Pedido,
		HOU.Num_Proc_HIM,
		HOU.HAWB_HIM,
		HOU.MAWB_HIM,
		NF.Data_DI,
		NF.DI,
		DS.Nome_Local,
		dbo.fBusca_Tarefa(hou.num_proc_him,4),
		LLP.Canal_LIM,
		--P.Planta

	convert(datetime,HOU.Dt_Emis_HIM,105),TM.Nome_Terminal,NF.Nota_Fiscal,Left(HOU.Num_Proc_HIM,2),HOU.Qtd_Tot_Vol_HIM











GO
