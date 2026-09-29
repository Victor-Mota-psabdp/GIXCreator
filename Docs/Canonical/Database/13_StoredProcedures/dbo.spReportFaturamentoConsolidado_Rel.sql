SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spReportFaturamentoConsolidado_Rel] 'IMSLA202103001BR'

CREATE Procedure [dbo].[spReportFaturamentoConsolidado_Rel]
(
	@Num_Proc varchar(16)
)

as

Declare @Temp Table(
	[Despachante]		varchar(7)
	,[Fatura]			varchar(11)
	,[Data Fatura]		datetime
	,[NF]				varchar(10)
	,[CNPJ]				varchar(15)
	,[Ref. Cliente]		varchar(400)
	,[Ref. BDP]			varchar(16)
	,[Valor]			decimal(17,2)
)
--declare @Num_Proc varchar(16)
--set @Num_Proc = 'IMSLA202103001BR'

	declare @valor_total decimal(17,2)


	insert into @Temp	
	select 
		'1058637'													[Despachante]
		,left(FAT.Processo_PC,2)+left(right(FAT.Processo_PC,11),9)	[Fatura]
		,max(Data_PC)												[Data Fatura]
		,num_nf_hia													[NF]	
		,right(PP.Num_CPF_CNPJ,14)									[CNPJ]
		,PD.num_pedido												[Ref. Cliente]
		,dbo.fBusca_Docs_PO_Modal(FAT.Processo_PC,1)				[Ref. BDP]
		,sum(dbo.valor(cx.Vlr_Pgto_Rcto_HIA,cx.DC_HIA))				[Valor]
		--,dbo.valor(cx.Vlr_Pgto_Rcto_HIA,cx.DC_HIA)
		--,FAT.Processo_PC processo
		--,cc.Num_Proc_HIA
		--,Num_Lcto

	from vwCXAS cx with(nolock)
	inner join vwcta_Cte	cc  (nolock) 
		on cc.Num_Proc_HIA = cx.Num_Proc_HIA
		and  cc.dc_hia = cx.dc_hia
		and  cc.cd_tp_tx = cx.cd_tp_tx
	inner join Tipo_taxa	T (nolock) 
		on T.cd_tp_tx = cc.cd_tp_tx 
	--	and T.Nome_Tp_Tx not like 'Transf. Processo%'

	inner join fatura_chb FAT
		on cc.Num_Proc_HIA = FAT.Processo_PC

	INNER JOIN dbo.Fatura_CHB_Item AS I 
		ON I.fatura_cc = FAT.Fatura_PC  
		AND cc.Cd_Tp_Tx = I.Cd_Tp_Tx 
		AND cc.DC_HIA=I.DC

	inner join Pessoa PP (nolock) 
		on PP.cd_pes=FAT.cd_pes_PC  
	left Join Pedido_Ship PS (nolock) 
		on PS.num_proc=processo_pc  
	left Join Pedido PD (nolock) 
		on PD.cd_pedido=PS.cd_pedido  
	where Num_Lcto in
						(
						select Distinct Num_Lcto 
						from vwcta_Cte cc (nolock) 
						inner join vwCXAS cx  (nolock) 
							on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
						where cc.Num_Proc_HIA = @Num_Proc
						) 

	and cx.num_proc_hia in
	(
		select 
		distinct cx.num_proc_hia
		from vwCXAS cx with(nolock)
		inner join vwcta_Cte	cc  (nolock) 
			on cc.Num_Proc_HIA = cx.Num_Proc_HIA
			and  cc.dc_hia = cx.dc_hia
			and  cc.cd_tp_tx = cx.cd_tp_tx
		where Num_Lcto in
					(
					select Distinct Num_Lcto 
					from vwcta_Cte cc (nolock) 
					inner join vwCXAS cx  (nolock) 
						on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
					where cc.Num_Proc_HIA = 'IMCSR202104001BR'
					and Num_Lcto not in ('Manual AX')
					) 
		and cx.num_proc_hia <> 'IMCSR202104001BR'	
	)



	and cx.Num_Proc_HIA <>@Num_Proc

	AND (Status_PC = 'E' )  
	and len(FAT.Fatura_PC) = 17  
	group by 	
		left(FAT.Processo_PC,2)+left(right(FAT.Processo_PC,9),7)
		,num_nf_hia														
		,right(PP.Num_CPF_CNPJ,14)									
		,PD.num_pedido
		--,dbo.fBusca_Docs_PO_Modal(@Num_Proc,1)
		,FAT.Processo_PC 

		--,cx.Vlr_Pgto_Rcto_HIA
		--,cx.DC_HIA


	--ORDER BY cc.Num_Proc_HIA


	select @valor_total = sum(valor) from @Temp

	insert into @Temp	
	([Despachante],[Valor])
	select 'Total',@valor_total


	select * from @Temp


GO
