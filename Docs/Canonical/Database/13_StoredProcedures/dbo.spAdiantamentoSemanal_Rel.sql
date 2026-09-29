SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[dbo].[fBusca_Caixa_Data]('IMEAS201205001BR','Adiantamento Cliente - CHB','C')

CREATE Procedure [dbo].[spAdiantamentoSemanal_Rel]-- '%SUN%','01-07-2012','11-07-2012'
	@Grupo			Varchar(400),
	@DataInicial	Datetime,
	@DataFinal		Datetime
AS

Declare @Table Table
		(
			PO Varchar(40),
			Job	Varchar(16),
			Exportador varchar(50),
			Produto Varchar(50),
			[Advancement Received - Date] Datetime,
			[ETA - Date]		Datetime,
			[Previsao de Registro - Date] Datetime,
			[Conta BDP Value]			Decimal(10,2),
			[Cliente Value]				Decimal(10,2),
--			[ICMS Value]				Decimal(10,2),
			[Total Value]				Decimal(10,2)
		)

Insert @Table

select 
	dbo.fBusca_TipoDocCliente('N',num_proc,1) PO, 
	num_proc,
	SHP.nome_Raz_Soc Exportador, 
	DBO.[fBusca_PRODUTO](Num_Proc) Descr_Produto,
	[dbo].[fBusca_Caixa_Data](Num_Proc,'Adiantamento Cliente - CHB','C')[Advancement Received - Date],
	ETA_LIM ETA,
	(ETA_LIM+3) [Previsao de Registro],
	[dbo].[FBusca_ADTOTX](Num_Proc,'%',@datainicial,@datafinal,'B') Conta_BDP,
----	[dbo].[FBusca_ADTOTX](Num_Proc,'%',@datainicial,@datafinal,'C')-[dbo].[FBusca_ADTOTX](Num_Proc,'ICMS%',@datainicial,@datafinal,'%')  Cliente, 
	[dbo].[FBusca_ADTOTX](Num_Proc,'%',@datainicial,@datafinal,'C') Cliente, 
--	[dbo].[FBusca_ADTOTX](Num_Proc,'ICMS%',@datainicial,@datafinal,'%') ICMS,
	[dbo].[FBusca_ADTOTX](Num_Proc,'%',@datainicial,@datafinal,'%') [Total Geral]
	
from 
	Adiantamento_Cliente AC With(Nolock)
	Join Grupo GRP with (Nolock) on GRP.grupo=substring(num_proc,3,3)
	Join Pessoa PP with (Nolock)  on cd_pes_grupo=cd_pes
	Join House_Imp_Mar Hou with (Nolock)  on hou.num_proc_him=num_proc
	Join Localidade Org with (Nolock)  on org.cd_local=cd_org_him
	Join Localidade Dst with (Nolock)  on dst.cd_local=cd_dst_him
	Join Pessoa SHP with (Nolock)  on cd_export_him=SHP.cd_pes
	Join LLP_Imp_Mar LLP with (nolock) on num_proc_lim=num_proc
Where
	pp.Apelido like @Grupo
	and
	dt_solicitacao between @DataInicial and @DataFinal

	

Union all

select 
	dbo.fBusca_TipoDocCliente('N',num_proc,1) PO, num_proc,
	SHP.nome_Raz_Soc Exportador, DBO.[fBusca_PRODUTO](Num_Proc) Descr_Produto,[dbo].[fBusca_Caixa_Data](Num_Proc,'Adiantamento Cliente - CHB','C')[Advancement Received - Date],
	ETA_LIA ETA,(ETA_LIA+3) [Previsao de Registro],[dbo].[FBusca_ADTOTX](Num_Proc,'%',@datainicial,@datafinal,'B') Conta_BDP,
--	[dbo].[FBusca_ADTOTX](Num_Proc,'%',@datainicial,@datafinal,'C')-[dbo].[FBusca_ADTOTX](Num_Proc,'ICMS%',@datainicial,@datafinal,'%')  Cliente,
	[dbo].[FBusca_ADTOTX](Num_Proc,'%',@datainicial,@datafinal,'C') Cliente,
--	 [dbo].[FBusca_ADTOTX](Num_Proc,'ICMS%',@datainicial,@datafinal,'%') ICMS,
	[dbo].[FBusca_ADTOTX](Num_Proc,'%',@datainicial,@datafinal,'%') [Total Geral]
from 
	Adiantamento_Cliente AC With(Nolock)
	Join Grupo GRP with (Nolock) on GRP.grupo=substring(num_proc,3,3)
	Join Pessoa PP with (Nolock)  on cd_pes_grupo=cd_pes
	Join House_Imp_aer Hou with (Nolock)  on hou.num_proc_hia=num_proc
	Join Localidade Org with (Nolock)  on org.cd_local=cd_org_hia
	Join Localidade Dst with (Nolock)  on dst.cd_local=cd_dst_hia
	Join Pessoa SHP with (Nolock)  on cd_export_hia=SHP.cd_pes
	Join LLP_Imp_aer LLP with (nolock) on num_proc_lia=num_proc
Where
	pp.Apelido like @Grupo
	and
	dt_solicitacao between @DataInicial and @DataFinal

Union all

select 
	dbo.fBusca_TipoDocCliente('N',num_proc,1) PO, num_proc,
	SHP.nome_Raz_Soc Exportador, DBO.[fBusca_PRODUTO](Num_Proc) Descr_Produto,[dbo].[fBusca_Caixa_Data](Num_Proc,'Adiantamento Cliente - CHB','C')[Advancement Received - Date],
	ETA_LIO ETA,(ETA_LIO+3) [Previsao de Registro],[dbo].[FBusca_ADTOTX](Num_Proc,'%',@datainicial,@datafinal,'B') Conta_BDP,
--	[dbo].[FBusca_ADTOTX](Num_Proc,'%',@datainicial,@datafinal,'C')-[dbo].[FBusca_ADTOTX](Num_Proc,'ICMS%',@datainicial,@datafinal,'%')  Cliente, 
	[dbo].[FBusca_ADTOTX](Num_Proc,'%',@datainicial,@datafinal,'C') Cliente, 
--	[dbo].[FBusca_ADTOTX](Num_Proc,'ICMS%',@datainicial,@datafinal,'%') ICMS,
	[dbo].[FBusca_ADTOTX](Num_Proc,'%',@datainicial,@datafinal,'%') [Total Geral]
from 
	Adiantamento_Cliente AC With(Nolock)
	Join Grupo GRP with (Nolock) on GRP.grupo=substring(num_proc,3,3)
	Join Pessoa PP with (Nolock)  on cd_pes_grupo=cd_pes
	Join House_Imp_Out Hou with (Nolock)  on hou.num_proc_hio=num_proc
	Join Localidade Org with (Nolock)  on org.cd_local=cd_org_hio
	Join Localidade Dst with (Nolock)  on dst.cd_local=cd_dst_hio
	Join Pessoa SHP with (Nolock)  on cd_export_hio=SHP.cd_pes
	Join LLP_Imp_out LLP with (nolock) on num_proc_lio=num_proc
Where
	pp.Apelido like @Grupo
	and
	dt_solicitacao between @DataInicial and @DataFinal



select * from @Table

Union All

Select '','','','TOTAL',null,null,null,sum([Conta BDP Value]),sum([cliente Value]), 
--	sum([ICMS Value]), 
	sum([Total Value]) from @table





GO
