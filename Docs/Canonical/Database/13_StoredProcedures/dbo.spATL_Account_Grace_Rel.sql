SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_Account_Grace_Rel]--'GRUPO GRACE GCP'
	@Grupo varchar(20)

as
	select
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,'1')						[PO],
		SHP.Nome_raz_soc													[Fornecedor],
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%Imposto de Imp%')	[I.I.],
		(dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_Him,'%Impos% Prod% Ind%')
					+ dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_Him,'IPI%')) [I.P.I.],
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%PIS%')				[PIS/PASEP],
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%Cofins%')			[COFINS],
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%SISComeX%')			[TX. SISC],
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%ICMS%') 
					- (dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%ICMS%') /19)	[ICMS],
		(dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%ICMS%') / 19 )      [FECP],
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,'10')						[N. Fiscal],
		'Bradesco'															[Banco],
		
		(dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_Him,'%Impos% Prod% Ind%')
					+ dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_Him,'IPI%')) +
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%PIS%')	+
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%Cofins%')+
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%SISComeX%')+
		(dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%ICMS%') 
					- (dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%ICMS%') /19)) +
		(dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%ICMS%') / 19 ) 		[TOTAL IMPOSTOS],
		HOU.Num_Proc_HIM													[BDP Reference],
		TERM.Nome_Terminal													[Armazem de Desembaraço]
--		dbo.fBusca_Tarefa(HOU.Num_Proc_HIM,'14')							PrestContas
	from
		House_Imp_Mar HOU
		join LLP_Imp_Mar LLP on LLP.Num_Proc_LIM = HOU.Num_Proc_HIM
		join Pessoa SHP on SHP.cd_pes = HOU.Cd_Export_HIM --Shipper
		join Pessoa_LLP PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo in ('P21129','P21130') 
		left join Terminal TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		join PO_HIM DI on DI.Num_Proc_HIM = HOU.Num_Proc_HIM and DI.ID_DC='5'
	where		
		DI.ID_DC is not null
		and ATD_LIM IS NOT NULL and eta_lim > =getdate()-90
	order by
		1
GO
