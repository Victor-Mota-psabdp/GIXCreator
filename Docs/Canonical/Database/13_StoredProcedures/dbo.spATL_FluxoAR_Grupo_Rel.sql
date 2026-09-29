SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_FluxoAR_Grupo_Rel] 
	@DataFinal	Datetime,
	@Grupo varchar(50)
As

--Declare @Data Datetime
--set @Data = '01-20-2013'

Declare @Fluxo Table
(

	Nome_Raz_Soc Varchar(100),
	Apelido		Varchar(100),
	[30 Days Credit]	Decimal(18,2),
	[30 Days Dedit]	Decimal(18,2),
	[60 Days Credit]	Decimal(18,2),
	[60 Days Dedit]	Decimal(18,2),
	[90 Days Credit]	Decimal(18,2),
	[90 Days Dedit]	Decimal(18,2),
	[120 Days Credit]	Decimal(18,2),
	[120 Days Dedit]	Decimal(18,2),
	[More than 120 Days Credit]	Decimal(18,2),
	[More than 120 Days Dedit]	Decimal(18,2),
	[Total Credit] Decimal(18,2),
	[Total Debit] Decimal (18,2)
)

Declare @TaxasEmAberto Table
(
	Nome_Raz_Soc Varchar(100),
	Endereco Varchar(500),
	Fatura	Varchar(17),
	Apelido	Varchar(50),
	Num_proc	Varchar(16),
	Vencimento Datetime,
	Taxa		Varchar(60),
	DC			Char(1),
	Moeda		Varchar(3),
	Vlr_Org		Decimal (18,2),
	Vlr_Org_RS	Decimal(18,2),
	Range_Fluxo	Varchar(50),
	EnvioCobrana	datetime,
	PO varchar(500)
)

Insert @TaxasEmAberto (Nome_Raz_Soc,Endereco,Fatura,Apelido,Num_proc,vencimento,taxa,dc,moeda,vlr_org,vlr_org_rs,range_fluxo,EnvioCobrana,PO)
Exec [spATLAR_Grupo_Sel]  @DataFinal,@Grupo


Insert @Fluxo (Nome_Raz_Soc,Apelido,[30 Days Credit],[30 Days Dedit])
select 
	Nome_Raz_soc,apelido,
	case 
		when DC='C' Then Vlr_org_RS
		else 0
	End,
	case 
		when DC='D' Then Vlr_org_RS
		else 0
	End
from 
	@TaxasEmAberto where range_fluxo='30 Days'
	

Insert @Fluxo (Nome_Raz_Soc,Apelido,[60 Days Credit],[60 Days Dedit])
select 
	Nome_Raz_soc,apelido,
	case 
		when DC='C' Then Vlr_org_RS
		else 0
	End,
	case 
		when DC='D' Then Vlr_org_RS
		else 0
	End
from 
	@TaxasEmAberto where range_fluxo='60 Days'
print '3'
Insert @Fluxo (Nome_Raz_Soc,Apelido,[90 Days Credit],[90 Days Dedit])
select 
	Nome_Raz_soc,apelido,
	case 
		when DC='C' Then Vlr_org_RS
		else 0
	End,
	case 
		when DC='D' Then Vlr_org_RS
		else 0
	End
from 
	@TaxasEmAberto where range_fluxo='90 Days'
print '4'	
Insert @Fluxo (Nome_Raz_Soc,Apelido,[120 Days Credit],[120 Days Dedit])
select 
	Nome_Raz_soc,apelido,
	case 
		when DC='C' Then Vlr_org_RS
		else 0
	End,
	case 
		when DC='D' Then Vlr_org_RS
		else 0
	End
from 
	@TaxasEmAberto where range_fluxo='120 Days'
print '5'
Insert @Fluxo (Nome_Raz_Soc,Apelido,[More than 120 Days Credit],[More than 120 Days Dedit])
select 
	Nome_Raz_soc,apelido,
	case 
		when DC='C' Then Vlr_org_RS
		else 0
	End,
	case 
		when DC='D' Then Vlr_org_RS
		else 0
	End
from 
	@TaxasEmAberto where range_fluxo='More than 120 Days'

print '6'
Update @Fluxo
	Set 
	[Total Credit] =Isnull([30 Days Credit],0)+Isnull([60 Days Credit],0)+Isnull([90 Days Credit],0)+isnull([120 Days Credit],0)+isnull([More than 120 Days Credit],0),
	[Total Debit] =Isnull([30 Days Dedit],0)+Isnull([60 Days Dedit],0)+Isnull([90 Days Dedit],0)+isnull([120 Days Dedit],0)+isnull([More than 120 Days Dedit],0)

select 
	Nome_Raz_Soc,apelido,
	sum(Isnull([30 Days Credit],0)) [30 Days Credit],sum(Isnull([30 Days Dedit],0)) [30 Days Debit], 
	sum(Isnull([60 Days Credit],0)) [60 Days Credit],sum(Isnull([60 Days Dedit],0)) [60 Days Debit],
	sum(Isnull([90 Days Credit],0)) [90 Days Credit],sum(Isnull([90 Days Dedit],0)) [90 Days Debit],
	sum(Isnull([120 Days Credit],0)) [120 Days Credit],sum(Isnull([120 Days Dedit],0)) [120 Days Debit],
	sum(Isnull([More than 120 Days Credit],0)) [More than 120 Days Credit],
	sum(Isnull([More than 120 Days Dedit],0)) [More than 120 Days Dedit],
	sum([Total Credit]) [Total Credit],
	sum([Total Debit]) [Total Debit],
	sum([Total Credit])+ sum([Total Debit]) [Balance]
from @Fluxo

Group by Nome_Raz_Soc,apelido

GO
