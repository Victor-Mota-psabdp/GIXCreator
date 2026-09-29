SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_EmbarquesemTransito_Grace]--'GRUPO GRACE GCP'

	@Grupo varchar(20)

AS
	declare @TAB table
	(
	[Num PO]				varchar(30),	
	[Job Number]			varchar(16),
	[Exportador]			varchar(500),
	[Origem]				varchar(30),
	[Destino]				varchar(30),
	[ETD]					varchar(10),
	[ETA]					varchar(10),
	[Codigo Produto]		varchar(100),
	[Descr. Produto]		varchar(500),
	[Incoterm]				varchar(10),
	[Moeda]					varchar(10),
	[Valor do Produto]		float,
	[II]					float,
	[IPI]					float,
	[ICMS]					float,
	[PIS]					float,
	[Cofins]				float,
	[Paridade]				float,
	[Frete Valor]			float,
	[Total Adiantamento]	float,
	[Semana de Registro DI]	varchar(50),
	[Valor_Total]			float
	)

	BEGIN
		insert into
			@TAB 
		SELECT 
			Num_Pedido				[Num PO],
			Num_Proc_Lim			[Job Number],
			Nome_Raz_Soc			[Exportador],
			Org.nome_local			[Origem],
			DST.nome_local			[Destino],
			convert(varchar,ATD_LIM,103)[ETD],
			convert(varchar,ETA_LIM	,103)[ETA],
			cd_proc_cliente			[Codigo Produto],
			Produto_Descr			[Descr. Produto],
			Upper(Incoterm)			[Incoterm],
			Upper(p.cd_tp_moeda)	[Moeda],
			Vlr_Total_Item			[Valor do Produto],
			(dbo.FBusca_AliqProd(cd_prod,'II')/100*Vlr_Total_Item) [II],
			(dbo.FBusca_AliqProd(cd_prod,'IPI')/100) [IPI] ,
			(dbo.FBusca_AliqProd(cd_prod,'ICM')/100) [ICMS],
			(dbo.FBusca_AliqProd(cd_prod,'PIS')/100) [PIS],
			(dbo.FBusca_AliqProd(cd_prod,'COF')/100) [Cofins],
			dbo.VerParidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM') [Paridade],
			isnull(pd.vlr_Frete,0) [Frete Valor],
			0 [Total Adiantamento],
			'Semana :' + cast(datepart(wk,eta_lim+7) as varchar(2)) + '/' + convert(varchar,year(eta_lim)) [Semana de Registro DI],
			0 [Valor_Total]
		FROM 
			LLP_IMP_MAR	LLP With(nolock)
			Join Pedido_Ship		PS	With(nolock) on PS.num_proc=num_proc_lim
			Join Pedido_Det			PD	With(nolock) on PD.cd_pedido=PS.cd_pedido and ps.cd_produto=pd.cd_produto and ps.item=pd.item and ps.lote=pd.lote
			Join House_Imp_Mar		HOU With(nolock) on Hou.num_proc_him=num_proc_lim
			Join Localidade			Org With(nolock) on org.cd_local=cd_org_him
			Join Localidade			Dst With(nolock) on dst.cd_local=cd_dst_him
			Join Pessoa				PP	With(nolock) on PP.cd_pes=cd_export_him
			Join Produto_Cliente	PC	With(nolock) on PC.cd_prod=PS.cd_produto
			Join Pedido				P	With(nolock) on P.cd_pedido=PS.cd_pedido
			Join Tarefas_Processos	T13 With(nolock) on LLP.num_proc_lim=T13.num_proc and T13.Id_task=13
		WHERE
			right(left(NUM_PROC_LIM,5),3) in ('GCP','MPT')
			AND ATD_LIM IS NOT NULL
			and eta_lim > =getdate()-90
	--		AND dbo.fbusca_tarefa(Num_Proc_LIM, 13) is null
			and T13.dt_conclusao is null
	END
	
	Begin		
		Update @TAB
		set
		[IPI] = ([Valor do Produto] + [II]) * [IPI],
		[Valor_Total] = ([Valor do Produto] + [II] + [IPI]) / (1 - [ICMS])
	End

	Begin		
		Update @TAB
		set
		[ICMS]	= [Valor_Total] * [ICMS],
		[PIS]	= [Valor_Total] * [PIS],
		[Cofins]= [Valor_Total] * [Cofins]			
	End

	Begin		
		Update @TAB
		set		
		[Total Adiantamento] = ((([II] + [IPI] + [ICMS] + [PIS] + [Cofins]) * [Paridade]) * 1.25) + [Frete Valor]
	End

	Select [Num PO],[Job Number],[Exportador],[Origem],[Destino],[ETD],[ETA],[Codigo Produto],[Descr. Produto],
	[Incoterm],	[Moeda],[Valor do Produto],[II],[IPI],[ICMS],[PIS],[Cofins],[Paridade],[Frete Valor],[Total Adiantamento],
	[Semana de Registro DI]	from @TAB




--
--	declare @cd_pes_grupo varchar(10)
--	set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@Grupo)
--	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)

--	--OBS: esta parte não esta pronta, só inclui pra se alguem quiser usar pra outro grupo,antes precisa revisar as contas
--	BEGIN		
--		SELECT 
--			Num_Pedido Num_PO,
--			Num_Proc_Lim Job,
--			Nome_Raz_Soc,
--			Org.nome_local Origem, 
--			DST.nome_local Destino,
--			ETA_LIM ETA,
--			cd_proc_cliente 
--			Codigo_Produto,
--			Produto_Descr,
--			Vlr_Total_Item,
--			(dbo.FBusca_AliqProd(cd_prod,'II')/100*Vlr_Total_Item)	[II],
--			(dbo.FBusca_AliqProd(cd_prod,'IPI')/100)*Vlr_Total_Item [IPI] ,
--			(dbo.FBusca_AliqProd(cd_prod,'ICM')/100)*Vlr_Total_Item [ICMS],
--			(dbo.FBusca_AliqProd(cd_prod,'PIS')/100)*Vlr_Total_Item [PIS],
--			(dbo.FBusca_AliqProd(cd_prod,'COF')/100)*Vlr_Total_Item [Cofins],
--			ATD_LIM ATD,
--			Upper(Incoterm) Incoterm,
--			Upper(p.cd_tp_moeda) Cd_TP_moeda,
--			dbo.VerParidade(convert(varchar(10),getdate(),103),P.cd_tp_moeda,'IMM') Paridade,
--			datepart(wk,eta_lim+7) Semana,
--			pd.vlr_Frete valor_frete,
--			PS.Qty
--		FROM 
--			LLP_IMP_MAR	LLP With (nolock)
--			Join Pedido_Ship		PS	With (nolock) on PS.num_proc=num_proc_lim
--			Join Pedido_Det			PD	With (nolock) on PD.cd_pedido=PS.cd_pedido and ps.cd_produto=pd.cd_produto and ps.item=pd.item and ps.lote=pd.lote
--			Join House_Imp_Mar		HOU With (nolock) on Hou.num_proc_him=num_proc_lim
--			Join Localidade			Org With (nolock) on org.cd_local=cd_org_him
--			Join Localidade			Dst With (nolock) on dst.cd_local=cd_dst_him
--			Join Pessoa				PP	With (nolock) on PP.cd_pes=cd_export_him
--			Join Produto_Cliente	PC	With (nolock) on PC.cd_prod=PS.cd_produto
--			Join Pedido				P	With (nolock) on P.cd_pedido=PS.cd_pedido
--			Join Tarefas_Processos	T7 With (nolock) on LLP.num_proc_lim=T7.num_proc and T7.Id_task=7
--		WHERE
--	--		convert(datetime,Dt_Emis_HIM,105) between @Dt_Inicial and @Dt_Final
--	--		and 
--			right(left(HOU.Num_proc_HIM,5),3)  = @Grupo
--			AND ATD_LIM IS NOT NULL
--	--		AND dbo.fbusca_tarefa(Num_Proc_LIM, 7) is null
--			and T7.dt_conclusao is null
--	END

GO
