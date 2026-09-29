SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE Procedure	[dbo].[spPlasticosT3_Rel] --'01-01-2009'
(
@Data datetime
)
As
select 
	Year(convert(datetime,HOU.Dt_Emis_HIM,105))								Ano,					
	HOU.Num_Proc_Him														Ref_BDP,
	CONS.Nome_Raz_Soc														Nome,
	CONS.Apelido															Apelido,
	CONS.Num_CPF_CNPJ														CGC,
	P.Num_Pedido															Order_Number,
	P.Num_PO																PO,
	HOU.Navio_HIM															Navio,
	LC.Nome_Local															Porto,
	LLP.ATA_LIM																Chegada,
	dbo.fBusca_Historico(hou.num_proc_him,53,GETDATE())						Saida,
	dbo.fBusca_Tarefa(hou.num_proc_him,15)									Presenca,
	NF.Data_DI																Data_DI,
	dbo.fBusca_Tarefa(hou.num_proc_him,4)									Desembaraco,
	convert(datetime,HOU.Dt_Emis_HIM,105)									Emissao,
	Isnull(dbo.fBusca_Historico(hou.num_proc_him,54,GETDATE()),ETA_Lim +7)	Previsao,
	Null																	DepositoDataReal,
	Null																	Entrega,
	Null																	NecessFabrica,
	Null																	lk4,
	Dt_Pedido																DataPO,
	dbo.fBusca_HistoricoDescr(hou.num_proc_him,54,GETDATE())				Motivo_Atraso,							
	LLP.Canal_LIM															Canal,
	cast(Isnull(PD.peso_liquido_tot,0)/1000 as float)						TON,
	P.Planta
from
	House_Imp_Mar HOU with(nolock)
	Join LLP_Imp_Mar						LLP with(nolock)	on HOU.Num_Proc_HIM = LLP.Num_Proc_LIM
	Join Job_Imp_Mar						JIM with(nolock)	on HOU.Num_Proc_HIM = JIM.Num_Proc_HIM
	Left Outer Join container_hou_Imp_mar	CO with(nolock)	on HOU.Num_Proc_HIM = CO.Num_Proc_HIM
	Left Outer Join Nota_Cliente 			NF with(nolock)	on HOU.Num_Proc_HIM = NF.Num_Proc
	Left Outer Join Armador					ARM with(nolock)	on JIM.Cd_Armador   = ARM.Cd_Armador
	Join Pedido_Ship 						PS with(nolock)	on HOU.Num_Proc_HIM = PS.Num_Proc
	Join Pedido								P with(nolock)	on PS.Cd_Pedido	    = P.Cd_Pedido
	Join Pedido_Det							PD with(nolock) 	on PS.Cd_Pedido = PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
	Left Outer Join Localidade				LC with(nolock)	on HOU.Cd_Dst_HIM   = Lc.Cd_Local
	Join Pessoa								CONS with(nolock) on HOU.Cd_Consig_HIM= CONS.Cd_Pes
	Join Produto_Cliente					PC with(nolock)	on PS.Cd_Produto    =PC.Cd_Prod
	Left Outer Join De_Para_Produto			DPP with(nolock)	on PC.Cd_Proc_Cliente = DPP.GMID
--	Left Outer Join PO_HIM					PO	on PO.Num_proc_HIM = HOU.Num_proc_HIM and PO.ID_DC = 1
where 
	convert(datetime,Dt_Emis_HIM,105) > @Data 
	--and PD.PO_GRP IN ('041')
	and (P.Planta IN ('05031WQ','05031WJ'))
Group by 
	Year(convert(datetime,HOU.Dt_Emis_HIM,105)),HOU.Num_Proc_Him,CONS.Nome_Raz_Soc,
	CONS.Apelido,CONS.Num_CPF_CNPJ	,P.Num_Pedido,P.Num_PO,	HOU.Navio_HIM,
	LC.Nome_Local,LLP.ATA_LIM,dbo.fBusca_Historico(hou.num_proc_him,53,GETDATE()),
	dbo.fBusca_Tarefa(hou.num_proc_him,15),NF.Data_DI,dbo.fBusca_Tarefa(hou.num_proc_him,6),
	convert(datetime,HOU.Dt_Emis_HIM,105),	Isnull(dbo.fBusca_Historico(hou.num_proc_him,54,GETDATE()),ETA_Lim +7),
	Dt_Pedido ,dbo.fBusca_HistoricoDescr(hou.num_proc_him,54,GETDATE()),LLP.Canal_LIM,PD.peso_liquido_tot,P.Planta











GO
