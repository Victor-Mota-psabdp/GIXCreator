SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spHIMConsulta_Sel] --'1','01-01-2010','2010-01-31','%','%','%','%','%'
		@Tipo	Char(3),
		@DataInicial	DAtetime,
		@DataFinal		Datetime,
		@Navio			varchar(40),
		@Origem			Varchar(30),
		@Destino		Varchar(30),
		@Grupo			Varchar(40),
		@Armador		Varchar(30),
		@MBL			Varchar(30),
		@HBL			Varchar(30)

AS

select	
	PP.Apelido Grupo,num_proc_lim Job_Number, dbo.fBusca_TipoDocCliente('N',num_proc_lim,1) PO_Number,
	SH.Apelido Shipper, CS.Apelido Consignee,Navio_him Navio,viagem_him,org.nome_local Origem,
	dst.nome_local Destino,nome_armador,etd_lim ETD, ATD_LIM ATD,eta_lim ETA,ATA_LIM ATA,
	dbo.[fBusca_HistoricoDescr_Completo](num_proc_lim) Historico,hou.mawb_him MBL,hou.hawb_him HBL
from llp_imp_mar
Join House_imp_mar hou on hou.num_proc_him=num_proc_lim
Join Pessoa CS on CS.cd_pes=cd_consig_him
Join Pessoa SH on SH.cd_pes=cd_export_him
Join Pessoa_LLP PLLP on PLLP.cd_pes=cd_consig_him
Join Pessoa PP on PP.cd_pes=cd_pes_Grupo
Join Localidade Org on org.cd_local=cd_org_him
Join Localidade DST on DST.cd_local=cd_dst_him
Join Job_Imp_mar Job on job.num_proc_him=num_proC_lim
Left Join Armador ARM on ARM.cd_armador=Job.cd_armador
Where
	(ata_lim >=getdate()-20 or ata_lim is null)
	and
	(@Tipo='ETA' and ETa_LIM between @DataInicial and @DataFinal)
	and
	pp.apelido like @Grupo
	and
	navio_him like @Navio
	and
	org.nome_local like @Origem
	and
	dst.nome_local like @Destino
	and 
	arm.nome_armador like @Armador
	AND
	HOU.MAWB_HIM LIKE @MBL
	AND
	HAWB_HIM LIKE @HBL


GO
