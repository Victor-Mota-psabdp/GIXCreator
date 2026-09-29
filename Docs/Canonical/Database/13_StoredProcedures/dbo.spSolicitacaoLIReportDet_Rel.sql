SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--spSolicitacaoLIReportDet_Rel 

CREATE Procedure [dbo].[spSolicitacaoLIReportDet_Rel] --[spSolicitacaoLIReportDet_Rel]'GRUPO DOW','2014-12-02','2014-12-03'
	@Grupo varchar(30),
	@DtInicial Datetime,
	@DtFinal Datetime
as

declare @cd_pes_grupo varchar(10)
set @cd_pes_grupo = (select top 1 cd_pes from pessoa where Desat_pes = 'N' and apelido = @Grupo)

if @cd_pes_grupo is not NULL
	begin
		set @Grupo = (select grupo from grupo where cd_pes_grupo = @cd_pes_grupo)
	end

select 
	num_proc_him Job,
	isnull(dbo.fBusca_TipoDocCliente('N',num_proc_him,2),'') PO_Number,
	Org.Nome_Local Origem,
	Nome_PAis Pais_Origem,
	DST.Nome_Local Destino,
	Peso_Bruto_HiM Peso_Bruto,
	Peso_Liquido_Him Peso_Liquido,
	etd_LIM ETD,
	ATD_LIM ATD, 
	EtA_LIM ETA, 
	ATA_LIM ATA,
	Dt_Vencimento Dt_Vencimento,
	Nome_Tp_li Tipo,
	dt_solicitacao,
	dt_li dt_LI,
	dt_deferimento dt_deferimento,
	num_li num_li
from 
	house_imp_mar HOU
	Join Localidade Org on Org.cd_local=cd_org_him
	Join Pais on pais.cd_pais=org.cd_pais
	Join Localidade DST on DST.cd_local=cd_dst_him
	Join LLP_Imp_Mar LLP on llp.num_proc_lim=hou.num_proc_him
	Join Solicitacao_LI SLI on SLI.num_proc=hou.num_proc_him and SLI.num_solicitacao=(select top 1 num_solicitacao from solicitacao_li where num_proc=hou.num_proc_him order by 1 desc)
	Join Tipo_LI TLI on TLI.id_tipo=sli.id_tipo_li
where 
	substring(hou.num_proc_him,3,3) in (@Grupo)
	and
	convert(Datetime,dt_emis_him,105) between @DtInicial and @DtFinal

Union all

select 
	num_proc_hia Job,isnull(dbo.fBusca_TipoDocCliente('N',num_proc_hia,2),'') PO_Number, 
	Org.Nome_Local Origem,Nome_PAis Pais_Origem,DST.Nome_Local Destino,Peso_Bruto_Hia Peso_Bruto,
	Peso_real_Hia Peso_Liquido,etd_LIa ETD,ATD_LIa ATD, EtA_LIa ETA, ATA_LIA ATA,
	Dt_Vencimento Dt_Vencimento,Nome_Tp_li Tipo,dt_solicitacao,dt_li dt_LI,dt_deferimento dt_deferimento,isnull(num_li,'') num_li
from 
	house_imp_aer HOU
	Join Localidade Org on Org.cd_local=cd_org_hia
	Join Pais on pais.cd_pais=org.cd_pais
	Join Localidade DST on DST.cd_local=cd_dst_hia
	Join LLP_Imp_aer LLP on llp.num_proc_lia=hou.num_proc_hia
	Join Solicitacao_LI SLI on SLI.num_proc=hou.num_proc_hia and SLI.num_solicitacao=(select top 1 num_solicitacao from solicitacao_li where num_proc=hou.num_proc_hia order by 1 desc)
	Join Tipo_LI TLI on TLI.id_tipo=sli.id_tipo_li
where 
	substring(hou.num_proc_hia,3,3) in (@Grupo)
	and
	convert(Datetime,dt_emis_hia,105) between @DtInicial and @DtFinal

Union all

select 
	num_proc_hio Job,isnull(dbo.fBusca_TipoDocCliente('N',num_proc_hio,2),'') PO_Number, 
	Org.Nome_Local Origem,Nome_PAis Pais_Origem,DST.Nome_Local Destino,Peso_Bruto_Hio Peso_Bruto,
	Peso_real_Hio Peso_Liquido,etd_LIo ETD,ATD_LIo ATD, EtA_LIo ETA, ATA_LIO ATA,
	Dt_Vencimento Dt_Vencimento,Nome_Tp_li Tipo,dt_solicitacao,dt_li dt_LI,dt_deferimento dt_deferimento,isnull(num_li,'') num_li
from 
	house_imp_out HOU
	Join Localidade Org on Org.cd_local=cd_org_hio
	Join Pais on pais.cd_pais=org.cd_pais
	Join Localidade DST on DST.cd_local=cd_dst_hio
	Join LLP_Imp_out LLP on llp.num_proc_lio=hou.num_proc_hio
	Join Solicitacao_LI SLI on SLI.num_proc=hou.num_proc_hio and SLI.num_solicitacao=(select top 1 num_solicitacao from solicitacao_li where num_proc=hou.num_proc_hio order by 1 desc)
	Join Tipo_LI TLI on TLI.id_tipo=sli.id_tipo_li
where 
	substring(hou.num_proc_hio,3,3) in (@Grupo)
	and
	convert(Datetime,dt_emis_hio,105) between @DtInicial and @DtFinal


GO
