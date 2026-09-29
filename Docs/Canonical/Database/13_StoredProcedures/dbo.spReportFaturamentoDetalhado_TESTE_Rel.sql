SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spReportFaturamentoDetalhado_TESTE_Rel] 'IMSLA202102001BR'

CREATE Procedure [dbo].[spReportFaturamentoDetalhado_TESTE_Rel]
(
	@Num_Proc varchar(16)
)

as

Declare @Temp Table(
	JOB					varchar(17),
	PO					Varchar(200),
	MAWB				varchar(50),
	HAWB				varchar(50),
	[Taxa]				varchar(50),
	[Valor]				decimal(17,2)	
)

--declare @Num_Proc varchar(16)
--set @Num_Proc = 'IMSLA202102001BR'

insert into @Temp	
		select distinct
			FCHB.fatcod [Job], 
			null,
			null,
			null,
			null,  
			null
		from vwCXAS cx with(nolock)
			join vwFaturasValidasCHB FCHB with(nolock) on cx.Num_Proc_HIA = FCHB.Num_Proc AND cx.Cd_Tp_Tx = FCHB.Cd_Tp_Tx AND cx.DC_HIA=FCHB.DC
			--join vwcta_Cte	cc  with(nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA
			--join Tipo_taxa	T with(nolock) on T.cd_tp_tx = cc.cd_tp_tx and T.Nome_Tp_Tx not like 'Transf. Processo%'
			--join vwCliente_Alerta A with(nolock) on A.num_proc = CX.Num_Proc_HIA	
		where Num_Lcto in
		(select Distinct Num_Lcto from vwcta_Cte cc  with(nolock)
		join vwCXAS cx  with(nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
		where cc.Num_Proc_HIA = @Num_Proc) and cx.Num_Proc_HIA <>@Num_Proc
		--and cx.Num_Proc_HIA = 'IMSLA202012016BR'
		--order by 1

insert into @Temp	
		select 
			Temp.JOB [Job], 
			'PO ' + isnull(	dbo.[fBusca_Docs_PO_Modal](FCHB.Num_Proc,1),'') [PO],
			'MBL ' + isnull(A.MAWB,'')  MAWB,
			'HBL ' + isnull(A.HAWB,'')  HAWB,
			T.nome_tp_tx [Taxa],  
			--dbo.valor(cc.Vlr_Org_HIA ,cc.DC_HIA) [valor]
			--cc.Vlr_Org_HIA [valor]
			FCHB.Vlr_PC [valor]
		from @Temp Temp 
			join vwFaturasValidasCHB_Tp_Pgto FCHB with(nolock) on FCHB.fatcod = Temp.JOB and FCHB.tp_Pgto = 'B'		
			join Tipo_taxa T with(nolock) on T.cd_tp_tx = FCHB.cd_tp_tx and T.Nome_Tp_Tx not like 'Transf. Processo%'	
			join vwCliente_Alerta A with(nolock) on A.num_proc = FCHB.Num_Proc
	

insert into @Temp
	select distinct T.[Job], [PO],MAWB,HAWB,TT.nome_tp_tx [Taxa],
		dbo.valor(I.vlr_RS ,I.DC) [valor]
		from @Temp T 
		join FATURA_CHB FAT with(nolock) on Fat.Fatura_PC = T.[Job]
		join Item_Fat I with(nolock) on I.Fatcod = BDP_Invoice
		join Tipo_taxa	TT with(nolock) on TT.cd_tp_tx = I.cd_tp_tx
	

select distinct 'Job ' + [Job] [Job], [PO],MAWB,HAWB,[Taxa],[Valor] from @Temp where [PO] is not null order by 1

GO
