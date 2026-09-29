SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Embarques_MARSH_Rel] --'GRUPO OWENS CORNING','2012-01-01', '2012-06-06'

(
	@Grupo varchar (30),
	@DtInicial datetime,
	@DtFinal	datetime
)
as
	declare @TAB table
	(
		[JOB] char(16),
		[Customer PO] varchar (100),
		[PLANTA] varchar(100),
		[DI] varchar(14),
		[Peso Bruto] float,
		[Codigo Embarque] char(1),
		[Transporte] varchar(100),
		[Porto Saida] varchar(100),
		[Data Saida] datetime,
		[Porto Destino] varchar(100),
		[Data Chegada] datetime,
		[Valor FOB] float,
		[Valor Frete] float,
		[Total Impostos] float
	)
	declare @cd_pes_grupo varchar(10)
	Set @cd_pes_grupo = (select top 1 Cd_Pes from pessoa where apelido=@grupo)
	set @grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)
Begin
	Insert into @TAB
					([JOB],[Customer PO],[PLANTA],[DI],[Peso Bruto],[Codigo Embarque],[Transporte],[Porto Saida],[Data Saida],[Porto Destino],[Data Chegada])		
select 
			LLP.Num_Proc_Lim,
			CPO.Numero_PO_Him,
			CS.Cd_Planta,
			DI.Numero_PO_Him,
			HOU.Peso_Bruto_HIM,
			(case
				when DESTINO.Cd_Regiao = '002' or DESTINO.Cd_Regiao = '004' or DESTINO.Cd_Regiao = '007' then '1'
				else '3'
				end),
			HOU.Navio_HIM ,
			ORIGEM.Nome_Local,
			LLP.ATD_LIM [Data Saida],
			DESTINO.Nome_Local,
			LLP.ATA_LIM
		--	dbo.fBusca_Vlr_NF_Det_Processo (LLP.Num_Proc_Lim,'FOB') [Valor FOB],
		--	dbo.fBusca_Vlr_NF_Det_Processo (LLP.Num_Proc_Lim,'Vlr_FRETE')[Valor Frete]
		--	NOTA.Vlr_NF - (dbo.fBusca_Vlr_NF_Det_Processo (LLP.Num_Proc_Lim,'FOB') + dbo.fBusca_Vlr_NF_Det_Processo (LLP.Num_Proc_Lim,'Vlr_FRETE')) [Total Impostos]
		from 
			llp_imp_mar LLP With(nolock)
		join House_Imp_Mar HOU With(nolock) on LLP.num_proc_lim = HOU.num_proc_him
		join Localidade ORIGEM With(nolock) on HOU.Cd_Org_Him = ORIGEM.CD_Local
		join Localidade DESTINO With(nolock) on HOU.Cd_Dst_Him = DESTINO.CD_Local
		left outer join PO_HIM DI With(nolock) on LLP.num_proc_lim = DI.Num_proc_him and DI.ID_DC=5
		left outer join PO_HIM CPO With(nolock) on LLP.num_proc_lim = CPO.Num_proc_him and CPO.ID_DC=9
		left outer join Pessoa_LLP CS With(nolock) on HOU.Cd_Consig_Him = CS.cd_Pes
		--join Nota_Cliente NOTA With(nolock) on LLP.Num_Proc_Lim = NOTA.Num_Proc
		--join Regiao CDEMBARQUE with(nolock) on DESTINO.Cd_Regiao = CDEMBARQUE.Cd_Regiao
		where
		ata_Lim between @DtInicial and @DtFinal and ISNULL(LLP.ID_STATUS,0) <> 9 and 
		(@cd_pes_grupo = 'P000007153' and (right(left(LLP.num_proc_lim,5),3) in (@grupo,'OWE'))OR (@cd_pes_grupo <> 'P000007153' and right(left(LLP.num_proc_lim,5),3) = @grupo))

		Union ALL

		select 
			LLP.Num_Proc_lia,
			CPO.Numero_PO_Hia,
			CS.Cd_Planta,
			DI.Numero_PO_Hia,
			HOU.Peso_Bruto_hia [Peso Bruto],
			(case
				when DESTINO.Cd_Regiao = '002' or DESTINO.Cd_Regiao = '004' or DESTINO.Cd_Regiao = '007' then '4'
				else '3'
				end),
			CA.Nome_Cia_Aer,
			ORIGEM.Nome_Local,
			LLP.ATD_lia,
			DESTINO.Nome_Local,
			LLP.ATA_lia
		--	dbo.fBusca_Vlr_NF_Det_Processo (LLP.Num_Proc_lia,'FOB') [Valor FOB],
		--	dbo.fBusca_Vlr_NF_Det_Processo (LLP.Num_Proc_lia,'Vlr_FRETE')[Valor Frete]
		--	NOTA.Vlr_NF - (dbo.fBusca_Vlr_NF_Det_Processo (LLP.Num_Proc_lia,'FOB') + dbo.fBusca_Vlr_NF_Det_Processo (LLP.Num_Proc_lia,'Vlr_FRETE')) [Total Impostos]
		from 
			llp_imp_aer LLP With(nolock)
		join House_Imp_aer HOU With(nolock) on LLP.num_proc_lia = HOU.num_proc_hia
		join JOB_Imp_AER JOB	With(nolock) on LLP.num_proc_lia = JOB.Num_proc_hia
		join Cia_Aerea CA	with(nolock) on JOB.Cd_cia_aer = CA.Cd_Cia_Aer
		join Localidade ORIGEM With(nolock) on HOU.Cd_Org_hia = ORIGEM.CD_Local
		join Localidade DESTINO With(nolock) on HOU.Cd_Dst_hia = DESTINO.CD_Local
		left outer join PO_HIA DI With(nolock) on LLP.num_proc_lia = DI.Num_proc_hia and DI.ID_DC=5
		left outer join PO_HIA CPO With(nolock) on LLP.num_proc_lia = CPO.Num_proc_hia and CPO.ID_DC=9
		left outer join Pessoa_LLP CS With(nolock) on HOU.Cd_Consig_Hia = CS.cd_Pes
		--join Nota_Cliente NOTA With(nolock) on LLP.Num_Proc_lia = NOTA.Num_Proc
		where
		ata_lia between @DtInicial and @DtFinal and ISNULL(LLP.ID_STATUS,0) <> 9 and 
		(( @cd_pes_grupo = 'P000007153' and right(left(LLP.num_proc_lia,5),3) in (@grupo,'OWE'))OR (@cd_pes_grupo <> 'P000007153' and right(left(LLP.num_proc_lia,5),3) = @grupo))

		Union ALL

		select 
			LLP.Num_Proc_lio [JOB],
			CPO.Numero_PO_Hio,
			CS.Cd_Planta,
			DI.Numero_PO_Hio [DI],
			HOU.Peso_Bruto_hio [Peso Bruto],
			5 [Codigo Embarque],
			TRANSP.Apelido [TRASNPORTE],
			ORIGEM.Nome_Local [Porto Saida],
			LLP.ATD_lio [Data Saida],
			DESTINO.Nome_Local [Porto Destino],
			LLP.ATA_lio [Data Chegada]
--			dbo.fBusca_Vlr_NF_Det_Processo (LLP.Num_Proc_lio,'FOB') [Valor FOB],
--			dbo.fBusca_Vlr_NF_Det_Processo (LLP.Num_Proc_lio,'Vlr_FRETE')[Valor Frete]
			--NOTA.Vlr_NF - (dbo.fBusca_Vlr_NF_Det_Processo (LLP.Num_Proc_lio,'FOB') + dbo.fBusca_Vlr_NF_Det_Processo (LLP.Num_Proc_lio,'Vlr_FRETE')) [Total Impostos]
		from 
			llp_imp_out LLP With(nolock)
		join House_Imp_out HOU With(nolock) on LLP.num_proc_lio = HOU.num_proc_hio
		join Localidade ORIGEM With(nolock) on HOU.Cd_Org_hio = ORIGEM.CD_Local
		join Localidade DESTINO With(nolock) on HOU.Cd_Dst_hio = DESTINO.CD_Local
		left outer join PO_HIO DI With(nolock) on LLP.num_proc_lio = DI.Num_proc_hio and DI.ID_DC=5
		left outer join PO_HIO CPO With(nolock) on LLP.num_proc_lio = CPO.Num_proc_hio and CPO.ID_DC=9
		--join Nota_Cliente NOTA With(nolock) on LLP.Num_Proc_lio = NOTA.Num_Proc
		join Pessoa TRANSP With(nolock) on LLP.Cd_Transportadora = TRANSP.Cd_Pes
		left outer join Pessoa_LLP CS With(nolock) on HOU.Cd_Consig_Hio = CS.cd_Pes
		where
		ata_lio between @DtInicial and @DtFinal and ISNULL(LLP.ID_STATUS,0) <> 9  and 
(( @cd_pes_grupo = 'P000007153' and right(left(LLP.num_proc_lio,5),3) in (@grupo,'OWE'))OR (@cd_pes_grupo <> 'P000007153' and right(left(LLP.num_proc_lio,5),3) = @grupo))

End

Begin
/*
	Update T
	set 
		[Valor FOB] = FOB_USD, 
		[Valor Frete] = dbo.fBusca_Custo_Processo([JOB],'%Frete%'), 
		[Total Impostos] = (dbo.fBusca_Custo_Processo([JOB],'Imposto de Importação%') + dbo.fBusca_Custo_Processo([JOB],'Despesas Aduaneiras%') + dbo.fBusca_Custo_Processo([JOB],'Taxa% do Siscomex%') + dbo.fBusca_Custo_Processo([JOB],'%PIS%') + dbo.fBusca_Custo_Processo([JOB],'%COFINS%') + dbo.fBusca_Custo_Processo([JOB],'%ICMS%'))
	from 
		@TAB T
	join
	(
	Select
		num_proc,FOB_USD 
	from
		ATL_capa_valores 
	) A on A.Num_Proc = T.[JOB]
*/
			
	Update T
	set
		[Valor FOB] = totFOB,
		[Valor Frete] = totFrete,
		[Total Impostos] = (dbo.fBusca_Custo_Processo([JOB],'%IPI%')+ dbo.fBusca_Custo_Processo([JOB],'Imposto de Importação%') + dbo.fBusca_Custo_Processo([JOB],'%PIS%') + dbo.fBusca_Custo_Processo([JOB],'%COFINS%') + dbo.fBusca_Custo_Processo([JOB],'%ICMS%')) / dbo.fBusca_CampoCliente([JOB],31)
	from
		@TAB T
	join
		(
		Select 
			sum(CIF - vlr_frete - vlr_seguro - isnull(acrescimos,0)) / dbo.fBusca_CampoCliente(num_proc,31) totFOB,
			--sum(NFCD.VL_II + NFCD.VL_IPI + NFCD.Vlr_Siscomex + NFCD.VL_Imposto_PIS + NFCD.VL_IMPOSTO_COFINS + NFCD.VL_ICMS) totImpostos,
			sum(Vlr_FRETE) / dbo.fBusca_CampoCliente(num_proc,31) totFrete, 
			num_proc
		from nota_fiscal_cliente_det NFCD
		join nota_cliente NC on NC.Id_NF = NFCD.Id_NF and NC.cd_cliente = NFCD.cd_cliente
		group by num_proc, NC.Vlr_NF
		) A on A.num_proc = T.[JOB]
End

	select
		[JOB],
		[Customer PO],
		[PLANTA],
		[DI],
		[Peso Bruto],
		[Codigo Embarque],
		[Transporte],
		[Porto Saida],
		[Data Saida],
		[Porto Destino],
		[Data Chegada],
		[Valor FOB],
		[Valor Frete],
		[Total Impostos]
	from
		 @TAB
GO
