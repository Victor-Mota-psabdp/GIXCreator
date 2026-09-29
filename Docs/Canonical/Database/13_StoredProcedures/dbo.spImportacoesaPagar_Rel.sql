SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
spImportacoesaPagar_Rel 'MPT'
spImportacoesaPagar_Rel 'OXT'
select * from pessoa where apelido like 'grupo grace%'
*/

CREATE PROCEDURE [dbo].[spImportacoesaPagar_Rel]
(
	@Grupo varchar(3)
)
as
	declare @Cd_Pes_Grupo varchar(10)
	set @Cd_Pes_Grupo = (select cd_pes_grupo from grupo where grupo=@Grupo)

	select
		HOU.Num_Proc_HIM BDP_Ref,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,'10')	NF_Number,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,'1')	PO_Number,
		INV.Numero_PO_HIM		Invoice_Number,
		SHP.Nome_raz_soc		Vendor,
		LLP.Cd_Moeda_Invoice,
		LLP.Vlr_Invoice,
		(INV.Data_PO_HIM + 60) Vcto_Inv,
		dbo.fBusca_Docs_PO_Modal(HOU.Num_Proc_HIM,'5') DI_Number,
		LLP.ATA_LIM				ATA
	from
		 House_Imp_Mar HOU
		join LLP_Imp_Mar LLP on LLP.Num_Proc_LIM = HOU.Num_Proc_HIM
		join Pessoa SHP on SHP.cd_pes = HOU.Cd_Export_HIM --Shipper
		join PO_HIM INV on INV.Num_Proc_HIM = HOU.Num_Proc_HIM and INV.ID_DC='2'
		Join Pessoa_LLP PLL on PLL.Cd_Pes=HOU.Cd_Consig_HIM and PLL.Cd_Pes_Grupo=@Cd_Pes_Grupo
	where
		LLP.Vlr_Invoice is not NULL








GO
