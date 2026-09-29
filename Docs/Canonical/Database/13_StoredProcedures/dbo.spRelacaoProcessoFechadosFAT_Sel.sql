SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spRelacaoProcessoFechadosFAT_Sel]--'Grupo Sun Chemical','2012-01-01','2012-03-28'
	@Grupo			Varchar(400),
	@DataInicial	Datetime,
	@DataFinal		Datetime
AS
Declare @Tabela Table (	
	[Fatura BDP] Varchar(17),
	[CNPJ] varchar(16),
	[Ref. PO] Varchar(100),
	[Ref. Cliente] Varchar(100),
	[Data Emissao]	Datetime,	
	[BDP Servicos Valor] float,
	[Adiantamento Valor] float,
	[Total Faturamento Valor] float,
	[Saldo Valor] float
	)

--Inserir informações Basicas

Insert @Tabela([Fatura BDP],CNPJ,[Ref. PO],[Ref. Cliente],[Data Emissao])

Select 
	Fatura_PC,num_cpf_cnpj,dbo.fBusca_TipoDocCliente('N',left([Fatura_PC],16),1),
	dbo.fBusca_TipoDocCliente('N',left([Fatura_PC],16),3),Data_PC 
from 
	Fatura_CHB 
	Join Pessoa PP on pp.cd_pes=cd_pes_pc
where 
	status_Pc='E' and fatura_pc like '%SUN%'


update  @tabela  set [Adiantamento Valor]=isnull((select sum(vlr_pc) from fatura_chb_item where fatura_cc=[Fatura BDP] and cd_Tp_Tx in (select cd_tp_Tx from tipo_Taxa where nome_Tp_Tx like 'Adiant%')) ,0)

update  @Tabela  set [Total Faturamento Valor]=isnull((select sum(vlr_pc) from fatura_chb_item where fatura_cc=[Fatura BDP] and tp_pgto='B' and cd_Tp_Tx in (select cd_tp_Tx from tipo_Taxa where nome_Tp_Tx not like 'Adiant%')) ,0)

update  @Tabela  set [BDP Servicos Valor]=
isnull(
(
	select 
		sum(vlr_pc) 
	from 
		fatura_chb_item CHB
		Join vwcta_Cte CTA on cta.num_proc_hia=left([Fatura BDP],16) and dc_hia='C' and num_nf_hia is null
	where 
		fatura_cc=[Fatura BDP] and tp_pgto='B' and CHB.cd_Tp_Tx in (select cd_tp_Tx from tipo_Taxa where nome_Tp_Tx not like 'Adiant%'))



 ,0)

update  @tabela  set [Saldo Valor]=[Adiantamento Valor]-[Total Faturamento Valor]


select * from @Tabela
GO
