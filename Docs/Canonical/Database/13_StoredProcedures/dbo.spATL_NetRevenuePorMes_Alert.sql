SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_NetRevenuePorMes_Alert]--'2014-03-28'
		@DataAtual Datetime		

as

Declare @Data	Datetime
Declare @TAble table
	(
		Grupo	Varchar(50),
		Jobs	int,
		Total	Decimal(10,2)
	
	)

set @Data=(SELECT CAST(@DataAtual AS DATETIME))

--if day(@Data)<=5 
--	Begin	
--		set @Data=(select getdate()-1-Day(@Data))
--	End
	--set @data='03-31-2013'
	
	Insert @Table
	select 
		Apelido Grupo,
		convert(varchar(12),count(distinct num_proc)) [#Transaction],
		convert(varchar,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia))) [TOTAL] 
	from vwcta_Cte
		Join Base_Nota_Fiscal NF with (nolock) on NF.nota_fiscal=num_nf_hia and ref_acesso=ref_Acesso_nf_hia
		Join vwcliente C on C.num_proc=num_proc_hia
		Join Pessoa_LLP P with (nolock) on p.cd_pes=cd_Cliente
		Join Pessoa GRP with (nolock) on GRP.cd_pes=cd_pes_grupo
	where		
		year(emissao)=year(@Data) and month(emissao)=month(@data)				
		and cd_Status <> '2'
		group by apelido
	
	insert @Table
	Select 'TOTAL OF Current Month',sum(jobs), sum(Total) From @Table
	
	insert @Table
	Select 'Estimated Taxes Over NF', 0,sum(Total)*-0.11 From @Table where grupo <> 'TOTAL OF Current Month'
	
	insert @Table
	select 'Total Ops Costs',0,sum(total*dbo.FConverterMoeda(cd_tp_moeda,'REL'))*-1 from registro_financeiro 
		where			
			mes=month(@Data) and ano=year(@data)
						
	Insert @Table
	select 'Demurrage Revenue',0,sum(vlr_pgto_Rcto_hia) From vwcxas CXA
	Join TIpo_taxa tt with(nolock) on tt.cd_tp_tx=cxa.cd_Tp_Tx
	LEft Join vwcta_Cte cta with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cD_tp_Tx=cxa.cd_tp_tx
	where 
		num_nf_hia is null 
		and nome_tp_tx like 'Demurrage%' 
		and month(convert(Datetime,dt_pgto_Rcto_hia,105))= month(@data)		
		and cxa.dc_hia='C'
		and year(convert(Datetime,dt_pgto_Rcto_hia,105)) =year(@data)
	Insert @Table
	Select 'Net Revenue of Current Month',0,sum(Total) from @Table
	Where Grupo in ('Demurrage Revenue','Total Ops Costs','Estimated Taxes Over NF','TOTAL OF Current Month')
	select * from @table
	
GO
