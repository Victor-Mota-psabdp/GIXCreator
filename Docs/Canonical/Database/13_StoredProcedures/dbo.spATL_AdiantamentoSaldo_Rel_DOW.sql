SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_AdiantamentoSaldo_Rel_DOW 'IMCSR201909001BR'

CREATE procedure [dbo].[spATL_AdiantamentoSaldo_Rel_DOW]
(
 @Num_Proc varchar(16)
)
as
--set @Num_Proc = 'IMFMC201606001BR'

Declare @Temp Table(
	JOB										varchar(50),
	PO										Varchar(max),
	[CUSTOMER PO]							varchar(max),	
	[VALOR DEBITADO (DESPESAS)]				decimal(17,2),
	[VALOR SERVIÇOS]						decimal(17,2),
	[VALOR TOTAL (DESPESAS + SERVIÇOS)]		decimal(17,2),
	[DATA DE ENVIO DA PRESTAÇÃO DE CONTAS]	datetime,
	[DI/RE]									varchar(max),
	[INVOICE]								varchar(max)
)

Declare @Vlr_Pgto_Rcto decimal(17,2)
Declare @Vlr_Pgto_RctoATUAL decimal(17,2)

set @Vlr_Pgto_Rcto = (	
						select sum(Vlr_Pgto_Rcto_HIA) 
						from vwcta_Cte cc (nolock)
						inner join vwCXAS cx  (nolock) 
							on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
							and cc.Cd_Tp_Tx =cx.Cd_Tp_Tx 
							and  cx.DC_HIA = 'C'
						inner join Tipo_Taxa TT (nolock) 
							on cx.Cd_Tp_Tx = TT.Cd_Tp_Tx 
							and TT.CD_AX_Resultado = '900.1' 
							and nome_tp_Tx not like 'Presta%'
						where cc.Num_Proc_HIA = @Num_Proc
						)

set @Vlr_Pgto_RctoATUAL = (	
							select 
							Sum(dbo.valor(Vlr_Pgto_Rcto_HIA,DC_HIA)) 
							from vwCXAS cx  (nolock) 
							where Num_Lcto in	
												(
												select 
												Distinct Num_Lcto 
												from vwcta_Cte cc (nolock)
												inner join vwCXAS cx  (nolock) 
													on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
												where cc.Num_Proc_HIA = @Num_Proc
												and Num_Lcto not in ('Manual AX')
												) 
							and Num_Proc_HIA <>@Num_Proc
							)


insert @Temp 
select 
	Num_Proc_HIA [BDP Ref.], 
	dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,1),
	dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,9),	
	sum(dbo.valor(Vlr_Pgto_Rcto_HIA,DC_HIA)),
	NULL,
	NULL,
	dbo.[fBusca_Tarefa](Num_Proc_HIA,40),
	ISNULL(dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,5),dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,4)),
	dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,2)	  
from
	 vwCXAS cx (nolock)
where Num_Lcto in
					(select Distinct 
					Num_Lcto from vwcta_Cte cc  (nolock)
					inner join vwCXAS cx  (nolock) 
						on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
					where cc.Num_Proc_HIA = @Num_Proc
					and Num_Lcto not in ('Manual AX')) 

and Num_Proc_HIA <>@Num_Proc
group by Num_Proc_HIA

union all
	select NULL, NULL, NULL, NULL,NULL,NULL, NULL,NULL, NULL
union all
	select 'PRESTAÇÕES DE CONTAS:', @Num_Proc, NULL,NULL ,NULL,NULL,NULL,NULL, NULL
union all
	select NULL, 'SALDO INICIAL:', NULL, @Vlr_Pgto_Rcto,NULL,NULL, NULL,NULL, NULL
union ALL
	select NULL, 'DESPESAS:', NULL, @Vlr_Pgto_RctoATUAL,NULL,NULL, NULL,NULL, NULL
union ALL
	select NULL, 'SALDO FINAL:', NULL, @Vlr_Pgto_Rcto - @Vlr_Pgto_RctoATUAL,NULL,NULL, NULL,NULL,NULL



--[VALOR SERVIÇOS]
update T set T.[VALOR SERVIÇOS]=Valor_ARP   
from @Temp T 
INNER JOIN
(select 
FAT.Num_Proc, 
SUM(FAT.Valor_ARP) Valor_ARP 
from vwFaturasValidasArg FAT  (nolock)
inner Join vwCliente C (nolock) 
	on FAT.Num_Proc = C.num_proc 
	and FAT.Cd_Pes_FAT = C.cd_cliente
group by FAT.Num_Proc) F 
	on T.JOB= F.Num_Proc

--[VALOR TOTAL (DESPESAS + SERVIÇOS)
update @Temp set [VALOR TOTAL (DESPESAS + SERVIÇOS)] = [VALOR DEBITADO (DESPESAS)] + [VALOR SERVIÇOS]  from @Temp 

select * from @Temp

/*
ALTER procedure [dbo].[spATL_AdiantamentoSaldo_Rel_DOW]
(
 @Num_Proc varchar(16)
)
as
--set @Num_Proc = 'IMFMC201606001BR'

Declare @Temp Table(
	JOB varchar(50),
	PO Varchar(max),
	[CUSTOMER PO] varchar(max),
	[VALOR DEBITADO (DESPESAS)] decimal(17,2),
	[VALOR SERVIÇOS] decimal(17,2),
	[VALOR TOTAL (DESPESAS + SERVIÇOS)] decimal(17,2),
	[DATA DE ENVIO DA PRESTAÇÃO DE CONTAS] datetime
)

Declare @Vlr_Pgto_Rcto decimal(17,2)
Declare @Vlr_Pgto_RctoATUAL decimal(17,2)

set @Vlr_Pgto_Rcto = ( select  sum(Vlr_Pgto_Rcto_HIA) from vwcta_Cte cc (nolock)
join vwCXAS cx  (nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA and cc.Cd_Tp_Tx =cx.Cd_Tp_Tx and  cx.DC_HIA = 'C'
join Tipo_Taxa TT (nolock) on cx.Cd_Tp_Tx = TT.Cd_Tp_Tx and TT.CD_AX_Resultado = '900.1' and nome_tp_Tx not like 'Presta%'
where cc.Num_Proc_HIA = @Num_Proc)

set @Vlr_Pgto_RctoATUAL = (select 
	Sum(dbo.valor(Vlr_Pgto_Rcto_HIA,DC_HIA)) from vwCXAS cx  (nolock) where Num_Lcto in
(select Distinct Num_Lcto from vwcta_Cte cc
join vwCXAS cx  (nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
where cc.Num_Proc_HIA = @Num_Proc) and Num_Proc_HIA <>@Num_Proc)


insert @Temp 

select 
	Num_Proc_HIA [BDP Ref.], 
	dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,1),
	dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,9),  
	sum(dbo.valor(Vlr_Pgto_Rcto_HIA,DC_HIA)),
	NULL,
	NULL,
	dbo.[fBusca_Tarefa](Num_Proc_HIA,40)
from
	 vwCXAS cx (nolock)
where Num_Lcto in
(select Distinct Num_Lcto from vwcta_Cte cc  (nolock)
join vwCXAS cx  (nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
where cc.Num_Proc_HIA = @Num_Proc) and Num_Proc_HIA <>@Num_Proc
group by Num_Proc_HIA
union all
select NULL, NULL, NULL, NULL,NULL,NULL, NULL
union all
select 'PRESTAÇÕES DE CONTAS:', @Num_Proc, NULL,NULL ,NULL,NULL,NULL
union all
select NULL, 'SALDO INICIAL:', NULL, @Vlr_Pgto_Rcto,NULL,NULL, NULL
union ALL
select NULL, 'DESPESAS:', NULL, @Vlr_Pgto_RctoATUAL,NULL,NULL, NULL
union ALL
select NULL, 'SALDO FINAL:', NULL, @Vlr_Pgto_Rcto - @Vlr_Pgto_RctoATUAL,NULL,NULL, NULL



--[VALOR SERVIÇOS]

update T set T.[VALOR SERVIÇOS]=Valor_ARP   from @Temp T JOIN
(select FAT.Num_Proc, SUM(FAT.Valor_ARP)Valor_ARP from vwFaturasValidasArg FAT 
Join vwCliente C on FAT.Num_Proc = C.num_proc and FAT.Cd_Pes_FAT = C.cd_cliente
group by FAT.Num_Proc) F on T.JOB= F.Num_Proc

--[VALOR TOTAL (DESPESAS + SERVIÇOS)
update @Temp set [VALOR TOTAL (DESPESAS + SERVIÇOS)] = [VALOR DEBITADO (DESPESAS)] + [VALOR SERVIÇOS]  from @Temp 

select * from @Temp*/
GO
