SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spATL_Controle_LI_Backup_Rel]--'2016-03-01','2016-03-10' 

	@DtInicial datetime,
	@DtFinal  datetime
	
As

select 
	SL.Num_Solicitacao							[ID],
	CONVERT(varchar(10),Sl.Dt_Solicitacao,103)	[LI Request - Date],
	UR.Nome_Usuario								[Solicitante],
	GG.Apelido									[Group],
	UO.Nome_Usuario								[Operador],
	SL.Num_LI									[Import License],
	CONVERT(varchar(10),Sl.Dt_LI,103)			[Dt. da LI],
	CONVERT(varchar(10),SL.Dt_Aut_Embarque,103)	[Dt. Aut. Embarque],
	(RIGHT('000'+CAST(TSL.ID_Status_LI as varchar(2)),2) + ' - ' + TSL.Status_LI_Descricao)	[Status],
	OA.Nome_Orgao_Anuente						[Orgão Anuente],
	PC.cd_proc_cliente							[Product ID],
	PC.Produto_Descr							[Product Description],
	P.Qty										[Qty],
	P.Peso_Liquido								[Peso Liquido],
	(Case when SL.CobrancaCliente = 0 then 'SIM' Else 'NÃO' end) [Cobrança Cliente],
	SL.Obs_LI [Obs. LI____________________________],
	LLP.Num_Proc_LIM							[BDP Ref.]
from Solicitacao_LI		SL with(nolock)
	join Tipo_LI		TL with(nolock) on TL.ID_Tipo = SL.ID_Tipo_LI
	join Tipo_Status_LI TSL with(nolock) on SL.ID_Status = TSL.ID_Status_LI
	left Join LLP_Imp_Mar	LLP with(nolock) on LLP.num_proc_LIm=SL.Num_Proc
	left Join House_Imp_Mar	HOU with(nolock) on LLP.num_proc_LIm=HOU.Num_Proc_HIM
	left Join Solicitacao_LI_Orgao_Anuente SO with(nolock) on SL.Num_Solicitacao = SO.Num_Solicitacao
	left Join Orgao_Anuente OA with(nolock) on SO.ID_Orgao_Anuente = OA.ID_Orgao 
	left join Pessoa			CSN with(nolock) on CSN.cd_pes=HOU.Cd_Consig_HIM	
	left Join Pessoa_LLP PLLP with(nolock)  on HOU.Cd_Consig_HIM=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	left Join Pessoa GG with(nolock)  on GG.cd_pes=SL.cd_grupo	
	left Join Localidade ORG with(nolock) on HOU.cd_org_HIM=ORG.cd_local	
	left join Solicitacao_LI_Produto P with(nolock) on P.Num_Solicitacao = SL.Num_Solicitacao
	left join Produto_cliente PC with(nolock) on P.cd_produto = pc.cd_prod
	left join Pedido_Ship PS with(nolock) on PS.num_proc = SL.num_proc
	Left join Pedido PE with(nolock) on PE.cd_pedido = PS.cd_pedido
	Left Join Usuario UO with(nolock) on SL.Cd_Usuario_Oper = UO.Cd_Usuario
	Left Join Usuario UR with(nolock) on SL.Cd_Usuario_Req = UR.Cd_Usuario
where
	(SL.Dt_LI between @DtInicial and @DtFinal)
	and SL.ID_Tipo_LI = 8
	
union all

select 
	SL.Num_Solicitacao							[ID],
	CONVERT(varchar(10),Sl.Dt_Solicitacao,103)	[LI Request - Date],
	UR.Nome_Usuario								[Solicitante],
	GG.Apelido									[Group],
	UO.Nome_Usuario								[Operador],
	SL.Num_LI									[Import License],
	CONVERT(varchar(10),Sl.Dt_LI,103)			[Dt. da LI],
	CONVERT(varchar(10),SL.Dt_Aut_Embarque,103)	[Dt. Aut. Embarque],
	(RIGHT('000'+CAST(TSL.ID_Status_LI as varchar(2)),2) + ' - ' + TSL.Status_LI_Descricao)	[Status],
	OA.Nome_Orgao_Anuente						[Orgão Anuente],
	PC.cd_proc_cliente							[Product ID],
	PC.Produto_Descr							[Product Description],
	P.Qty										[Qty],
	P.Peso_Liquido								[Peso Liquido],
	(Case when SL.CobrancaCliente = 0 then 'SIM' Else 'NÃO' end) [Cobrança Cliente],
	SL.Obs_LI [Obs. LI____________________________],
	LLP.Num_Proc_LIA							[BDP Ref.]
from Solicitacao_LI		SL with(nolock)
	join Tipo_LI		TL with(nolock) on TL.ID_Tipo = SL.ID_Tipo_LI
	join Usuario		US with(nolock) on SL.Cd_Usuario_Req = US.Cd_Usuario
	join Tipo_Status_LI TSL with(nolock) on SL.ID_Status = TSL.ID_Status_LI
	left Join LLP_Imp_Aer	LLP with(nolock) on LLP.Num_Proc_Lia=SL.Num_Proc
	left Join House_Imp_Aer	HOU with(nolock) on LLP.num_proc_LIa=HOU.Num_Proc_HIA
	left Join Solicitacao_LI_Orgao_Anuente SO with(nolock) on SL.Num_Solicitacao = SO.Num_Solicitacao
	left Join Orgao_Anuente OA with(nolock) on SO.ID_Orgao_Anuente = OA.ID_Orgao 	
	left join Pessoa			CSN with(nolock) on CSN.cd_pes=HOU.Cd_Consig_HIA
	left Join Pessoa_LLP PLLP with(nolock)  on HOU.Cd_Consig_HIA=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	left Join Pessoa GG with(nolock)  on GG.cd_pes=SL.cd_grupo	
	left Join Localidade		ORG with(nolock) on HOU.Cd_Org_HIA=ORG.cd_local	
	left join Solicitacao_LI_Produto P with(nolock) on P.Num_Solicitacao = SL.Num_Solicitacao
	left join Produto_cliente PC with(nolock) on P.cd_produto = pc.cd_prod
	left join Pedido_Ship PS with(nolock) on PS.num_proc = SL.num_proc
	Left join Pedido PE with(nolock) on PE.cd_pedido = PS.cd_pedido
	Left Join Usuario UO with(nolock) on SL.Cd_Usuario_Oper = UO.Cd_Usuario
	Left Join Usuario UR with(nolock) on SL.Cd_Usuario_Req = UR.Cd_Usuario
where
	(SL.Dt_LI between @DtInicial and @DtFinal)
	and SL.ID_Tipo_LI = 8
	
UNION ALL

select
	SL.Num_Solicitacao							[ID],
	CONVERT(varchar(10),Sl.Dt_Solicitacao,103)	[LI Request - Date],
	UR.Nome_Usuario								[Solicitante],
	GG.Apelido									[Group],
	UO.Nome_Usuario								[Operador],
	SL.Num_LI									[Import License],
	CONVERT(varchar(10),Sl.Dt_LI,103)			[Dt. da LI],
	CONVERT(varchar(10),SL.Dt_Aut_Embarque,103)	[Dt. Aut. Embarque],
	(RIGHT('000'+CAST(TSL.ID_Status_LI as varchar(2)),2) + ' - ' + TSL.Status_LI_Descricao)	[Status],
	OA.Nome_Orgao_Anuente						[Orgão Anuente],
	PC.cd_proc_cliente							[Product ID],
	PC.Produto_Descr							[Product Description],
	P.Qty										[Qty],
	P.Peso_Liquido								[Peso Liquido],
	(Case when SL.CobrancaCliente = 0 then 'SIM' Else 'NÃO' end) [Cobrança Cliente],
	SL.Obs_LI [Obs. LI____________________________],
	LLP.Num_Proc_Lio							[BDP Ref.]
from Solicitacao_LI		SL with(nolock)
	join Tipo_LI		TL with(nolock) on TL.ID_Tipo = SL.ID_Tipo_LI
	join Usuario		US with(nolock) on SL.Cd_Usuario_Req = US.Cd_Usuario
	join Tipo_Status_LI TSL with(nolock) on SL.ID_Status = TSL.ID_Status_LI
	Left Join LLP_Imp_Out	LLP with(nolock) on LLP.Num_Proc_LiO=SL.Num_Proc
	Left Join House_Imp_Out	HOU with(nolock) on LLP.num_proc_LIO=HOU.Num_Proc_HIO	
	left Join Solicitacao_LI_Orgao_Anuente SO with(nolock) on SL.Num_Solicitacao = SO.Num_Solicitacao
	left Join Orgao_Anuente OA with(nolock) on SO.ID_Orgao_Anuente = OA.ID_Orgao 	
	Left join Pessoa			CSN with(nolock) on CSN.cd_pes=HOU.Cd_Consig_HIO
	left Join Pessoa_LLP PLLP with(nolock)  on HOU.Cd_Consig_HIO=PLLP.cd_pes
	left Join Pessoa PP with(nolock)  on PP.cd_pes=cd_pes_grupo
	left Join Pessoa GG with(nolock)  on GG.cd_pes=SL.cd_grupo	
	Left Join Localidade		ORG with(nolock) on HOU.Cd_Org_HIO=ORG.cd_local	
	left join Solicitacao_LI_Produto P with(nolock) on P.Num_Solicitacao = SL.Num_Solicitacao
	left join Produto_cliente PC with(nolock) on P.cd_produto = pc.cd_prod
	left join Pedido_Ship PS with(nolock) on PS.num_proc = SL.num_proc
	Left join Pedido PE with(nolock) on PE.cd_pedido = PS.cd_pedido
	Left Join Usuario UO with(nolock) on SL.Cd_Usuario_Oper = UO.Cd_Usuario
	Left Join Usuario UR with(nolock) on SL.Cd_Usuario_Req = UR.Cd_Usuario
where
	(SL.Dt_LI between @DtInicial and @DtFinal)
	and SL.ID_Tipo_LI = 8
	
order by [Group]

--OPTION(HASH JOIN)



GO
