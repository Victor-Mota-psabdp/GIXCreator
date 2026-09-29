SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_Controle_Conteiner_Rel]'Grupo Oxiteno','2012-01-01','2012-12-31'

CREATE Procedure	[dbo].[spATL_Controle_Conteiner_Rel]
(
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
)
As

	declare @cd_pes_grupo varchar(10)
	set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Grupo)
	set @grupo = (select grupo from grupo with(nolock) where cd_pes_grupo = @cd_pes_grupo)

	Select
		HOU.Num_Proc_HIM										[BDP Ref.], 
		dbo.fbusca_docs_po_modal(HOU.Num_Proc_HIM,'1')			[PO Number],	
		dbo.fbusca_docs_po_modal(HOU.Num_Proc_HIM,'9')			[Customer_PO],
		P91.numero_po_him										[RC],
		CS.Nome_Raz_Soc											[Consignee],
		--CS.Num_CPF_CNPJ										[CNPJ],
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)					[Product Description],		
		DST.Nome_Local											[Port of Discharge],
		TER.nome_terminal										[Terminal],
		INC.Nome_Tp_Oper										[Incoterm],
		LLP.Vlr_Invoice											[Invoice Value],
		ARM.nome_armador										[Carrier],
		HOU.MAWB_HIM											[House],
		HOU.Peso_Bruto_him										[Gross Weight - House],
		HOU.Peso_Liquido_him									[Net Weight - House],
		TC.Nome_tp_cont											[Type - Container],		
		cp138.Campo_Dados										[Free time negociado (Número de dias)],
		MAS.num_cont_im											[Container Reference],
		MAS.Peso_Bruto_IM										[Gross Weight - Container],
		LLP.ETA_LIM												[ETA - DATE],
		LLP.ATA_LIM												[ATA - DATE],
		--T15.dt_conclusao										[Port Entry - Date],
		T15.dt_conclusao										[PRESENÇA],
		--P5.numero_po_him										[Entry Number],
		P5.numero_po_him										[DI],
		--T7.dt_conclusao										[Transport. Doc Delivery Date],
		T7.dt_conclusao											[Data de Nacionalização],
		--Vencimento da armazenagem (1º período)			
		CP150.Campo_Dados										[Limite de Armazenagem No Porto],
		dateadd(day,convert(int,cp138.Campo_Dados),LLP.ATA_LIM)	[Expiração do Free Time],
		--LLP.ATA_LIM,
		--cp138.Campo_Dados,
		AD.dt_entregaPlanta										[ENTREGA PLANTA],
		AD.dt_entregaArmazem									[ENTRADA ARMAZÉM],
		AD.dt_saidaArmazem										[SAÍDA ARMAZEM],
		AD.dt_saidaVazio										[SAIDA VAZIO],
		AD.dt_devolucao											[DEVOLUÇÃO VAZIO],			
		AD.local_entrega_vazio									[LOCAL ENTREGA VAZIO],
		TRP.apelido												[TRANSPORTADORA],
		AD.local_entrega										[LOCAL ENTREGA CARGA]			
	from 
		House_Imp_MAR				HOU With(nolock)
		Join LLP_Imp_MAR			LLP		With(nolock) on LLP.Num_Proc_LIM	=	HOU.Num_Proc_HIM
		Join JOB_Imp_MAR			JOB		With(nolock) on JOB.Num_Proc_HIM	=	HOU.Num_Proc_HIM
		Join Pessoa					CS		With(nolock) on HOU.Cd_Consig_HIM	=	CS.Cd_Pes
		Join Armador				ARM		With(nolock) on ARM.cd_armador		=	JOB.cd_armador
		left join Pessoa			TRP		With(nolock) on TRP.cd_pes			=   LLP.cd_transportadora	
		Join Localidade				DST		With(nolock) on DST.cd_local		=	HOU.cd_dst_him
		left Join Terminal			TER		With(nolock) on TER.cd_terminal		=	LLP.cd_terminal
		join container_hou_imp_mar	CHOU	With(nolock) on CHOU.num_proc_him	=	HOU.Num_Proc_HIM
		join container_mas_imp_mar	MAS		With(nolock) on MAS.num_proc_mim	=	CHOU.num_proc_mim and  CHOU.Item_Cont_IM =MAS.Item_Cont_IM
		left join container_additional_info AD	With(nolock) on Ad.num_proc		=	CHOU.num_proc_him and AD.num_cont = replace(MAS.num_cont_im,'-','')	
		left Join Tipo_Container	TC		With(nolock) on TC.cd_tp_cont		=	MAS.cd_tp_cont		
		left join PO_HIM			P5		With(nolock) on P5.num_proc_him		=	Hou.num_proc_him and p5.id_dc = 5
		left join PO_HIM			P91		With(nolock) on P91.num_proc_him	=	Hou.num_proc_him and P91.id_dc = 91
		left join tarefas_processos T15		With(nolock) on T15.num_proc		=	Hou.num_proc_him and T15.Id_task = 15
		left join tarefas_processos T7		With(nolock) on T7.num_proc			=	Hou.num_proc_him and T7.Id_task = 7

		left join Tipo_Oper			INC		With(nolock) on HOU.Cd_Tp_Oper		=	INC.Cd_Tp_Oper
		left join campo_processo	CP138	With(nolock) on CP138.num_proc	=	Hou.num_proc_him and CP138.Id_campo = 138
		left join campo_processo	CP150	With(nolock) on CP150.num_proc	=	Hou.num_proc_him and CP150.Id_campo = 150		
	Where	
		LLP.ETA_LIM between @dtInicial and @DtFinal
		and substring(num_proc_lim,3,3) = @grupo
option(hash join)


/*
ALTER Procedure	[dbo].[spATL_Controle_Conteiner_Rel]
(
	@Grupo varchar(20),
	@DtInicial datetime,
	@DtFinal datetime
)
As

	declare @cd_pes_grupo varchar(10)
	set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa with(nolock) where apelido=@Grupo)
	set @grupo = (select grupo from grupo with(nolock) where cd_pes_grupo = @cd_pes_grupo)

	Select
		HOU.Num_Proc_HIM										[BDP Ref.], 
		dbo.fbusca_docs_po_modal(HOU.Num_Proc_HIM,'1')			[PO Number],	
		dbo.fbusca_docs_po_modal(HOU.Num_Proc_HIM,'9')			[Customer_PO],
		CS.Nome_Raz_Soc											[Consignee],
		CS.Num_CPF_CNPJ											[CNPJ],
		DST.Nome_Local											[Port of Discharge],
		TER.nome_terminal										[Terminal],
		INC.Nome_Tp_Oper										[Incoterm],
		LLP.Vlr_Invoice											[Invoice Value],
		ARM.nome_armador										[Carrier],
		HOU.MAWB_HIM											[House],
		HOU.Peso_Bruto_him										[Gross Weight - House],
		HOU.Peso_Liquido_him									[Net Weight - House],
		LLP.ETA_LIM												[ETA - DATE],		
		dbo.fBusca_PRODUTO(HOU.Num_Proc_HIM)					[Product Description],
		P5.numero_po_him										[Entry Number],		
		MAS.Peso_Bruto_IM										[Gross Weight - Container],
		TC.Nome_tp_cont											[Type - Container],
--		AD.num_cont												[References],
		MAS.num_cont_im											[References],
		T15.dt_conclusao										[Port Entry - Date],		
		T7.dt_conclusao											[Transport. Doc Delivery Date],
		AD.dt_entregaPlanta										[Good Receipt],
		AD.dt_entregaArmazem									[Delivery to Warehouse],
		AD.dt_saidaArmazem										[Exit to Warehouse],
		AD.dt_saidaVazio										[Empty Exit],
		AD.dt_devolucao											[Return Date],			
		AD.local_entrega_vazio									[Delivery Empty Container],
		TRP.apelido												[Inland Trucker],
		AD.local_entrega										[Delivery Place]			
	from 
		House_Imp_MAR				HOU With(nolock)
		Join LLP_Imp_MAR			LLP		With(nolock) on LLP.Num_Proc_LIM		=	HOU.Num_Proc_HIM
		Join JOB_Imp_MAR			JOB		With(nolock) on JOB.Num_Proc_HIM		=	HOU.Num_Proc_HIM
		Join Pessoa					CS		With(nolock) on HOU.Cd_Consig_HIM	=	CS.Cd_Pes
		Join Armador				ARM		With(nolock) on ARM.cd_armador		=	JOB.cd_armador
		left join Pessoa			TRP		With(nolock) on TRP.cd_pes			=   LLP.cd_transportadora	
		Join Localidade				DST		With(nolock) on DST.cd_local			=	HOU.cd_dst_him
		left Join Terminal			TER		With(nolock) on TER.cd_terminal		=	LLP.cd_terminal
--		Join Pedido_Ship			PS		on PS.Num_Proc			=	HOU.Num_Proc_HIM
--		Join Pedido					P		on PS.Cd_Pedido			=	P.Cd_Pedido
--		Join Produto_Cliente		PC		on cd_prod				=	cd_produto		
		join container_hou_imp_mar	CHOU	With(nolock) on CHOU.num_proc_him	=	HOU.Num_Proc_HIM
		join container_mas_imp_mar	MAS		With(nolock) on MAS.num_proc_mim		=	CHOU.num_proc_mim and  CHOU.Item_Cont_IM =MAS.Item_Cont_IM
		left join container_additional_info AD	With(nolock) on Ad.num_proc		=	CHOU.num_proc_him and AD.num_cont = replace(MAS.num_cont_im,'-','')	
		left Join Tipo_Container	TC		With(nolock) on TC.cd_tp_cont		=	MAS.cd_tp_cont
		left join tarefas_processos T7		With(nolock) on T7.num_proc			=	Hou.num_proc_him and T7.Id_task = 7
		left join PO_HIM			P5		With(nolock) on P5.num_proc_him		=	Hou.num_proc_him and p5.id_dc = 5
		left join tarefas_processos T15		With(nolock) on T15.num_proc			=	Hou.num_proc_him and T15.Id_task = 15
		left join Tipo_Oper			INC		With(nolock) on HOU.Cd_Tp_Oper	 =	INC.Cd_Tp_Oper
	Where
		LLP.ETA_LIM between @dtInicial and @DtFinal
		and substring(num_proc_lim,3,3) = @grupo
option(hash join)
*/
		
GO
