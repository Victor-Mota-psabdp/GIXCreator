SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
spAccount_Rel 'MPT'
spAccount_Rel 'OXT'
select * from pessoa where apelido like 'grupo grace%'
*/

CREATE PROCEDURE [dbo].[spAccount_Rel]
(
	@Grupo varchar(3)
)
as
	declare @Cd_Pes_Grupo varchar(10)
	set @Cd_Pes_Grupo = (select cd_pes_grupo from grupo where grupo=@Grupo)

	select
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,'1')						PO_Number,
		SHP.Nome_raz_soc													Fornecedor,
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%Imposto de Imp%')	vlr_II,
		(dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_Him,'%Impos% Prod% Ind%')+ dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_Him,'IPI%')) vlr_IPI,
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%PIS%')				vlr_PIS,
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%Cofins%')			vlr_Cofins,
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%SISComeX%')			vlr_SISC,
		dbo.fBusca_CustoProcessoTAB(HOU.Num_Proc_HIM,'%ICMS%')				vlr_ICMS,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,'10')						NF_Number,
		'Bradesco'			Banco,
		HOU.Num_Proc_HIM	BDP_Ref,
		TERM.Nome_Terminal	Armazem
	from
		House_Imp_Mar HOU
		join LLP_Imp_Mar LLP on LLP.Num_Proc_LIM = HOU.Num_Proc_HIM
		join Pessoa SHP on SHP.cd_pes = HOU.Cd_Export_HIM --Shipper
		join Pessoa_LLP PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@Cd_Pes_Grupo
		left join Terminal TERM on LLP.Cd_Terminal = TERM.Cd_Terminal
		join PO_HIM DI on DI.Num_Proc_HIM = HOU.Num_Proc_HIM and DI.ID_DC='5'
	where
		DI.Data_PO_HIM > getdate() - 90 
	order by
		1
GO
