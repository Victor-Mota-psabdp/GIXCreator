SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spATL_FundoFixoSWB_Rel] 
(  
@Num_Proc VARCHAR(16)  
)  
as  
--set @Num_Proc = 'IMFMC201606001BR'  
  
Declare @Temp Table(  
[JOB]									VARCHAR(50),  
[PO]									VARCHAR(max),  
[CUSTOMER PO]							VARCHAR(max),   
[DESPESAS PAGAS]						DECIMAL(17,2),		-- Alessandra 03/10/2019 - adicionada
--[VALOR DEBITADO (DESPESAS)]				DECIMAL(17,2),	-- Alessandra 03/10/2019  - Removida  
[VALOR SERVIÇOS]						DECIMAL(17,2),  
[PCC 4,655]								DECIMAL(17,2),		-- Alessandra 03/10/2019 - adicionada
[IR 1,5%]								DECIMAL(17,2),		-- Alessandra 03/10/2019 - adicionada
[VALOR LÍQUIDO]							DECIMAL(17,2),		-- Alessandra 03/10/2019 - adicionada
--[VALOR TOTAL (DESPESAS + SERVIÇOS)]		DECIMAL(17,2),	-- Alessandra 03/10/2019  - Removida
[TOTAL COMISSÃO + DESPESAS]				DECIMAL(17,2),		-- Alessandra 03/10/2019  - adicionada  

[DATA DE ENVIO DA PRESTAÇÃO DE CONTAS]	DATETIME,  
[DI/RE]									VARCHAR(max),  
[INVOICE]								VARCHAR(max)  
)  
  
Declare @Vlr_Pgto_Rcto		DECIMAL(17,2)  
Declare @Vlr_Pgto_RctoATUAL DECIMAL(17,2)  

set @Vlr_Pgto_Rcto =	(
						SELECT SUM(Vlr_Pgto_Rcto_HIA) 
						FROM vwcta_Cte cc (NOLOCK)  
						JOIN vwCXAS cx  (NOLOCK) 
							ON cc.Num_Proc_HIA = cx.Num_Proc_HIA 
							AND cc.Cd_Tp_Tx =cx.Cd_Tp_Tx 
							AND  cx.DC_HIA = 'C'  
						JOIN Tipo_Taxa TT (NOLOCK) 
							ON cx.Cd_Tp_Tx = TT.Cd_Tp_Tx 
							AND TT.CD_AX_Resultado = '900.1' 
							AND nome_tp_Tx 
							NOT LIKE 'Presta%'  
						WHERE cc.Num_Proc_HIA = @Num_Proc
						)  
  
set @Vlr_Pgto_RctoATUAL =	(
							SELECT SUM(dbo.valor(Vlr_Pgto_Rcto_HIA,DC_HIA)) 
							FROM vwCXAS cx  (nolock) 
							WHERE Num_Lcto in  
								(SELECT DISTINCT Num_Lcto 
								FROM vwcta_Cte cc  
								JOIN vwCXAS cx  with(nolock) 
									ON cc.Num_Proc_HIA = cx.Num_Proc_HIA   
								WHERE cc.Num_Proc_HIA = @Num_Proc) 
							AND Num_Proc_HIA <>@Num_Proc
							)  
  
   
insert @Temp   
select 
	Num_Proc_HIA											AS [JOB], 
	dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,1)				AS [PO],
	dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,9)				AS [CUSTOMER PO],
	NULL													AS [DESPESAS PAGAS],						-- Alessandra 03/10/2019 - adicionada	
	--sum(dbo.valor(Vlr_Pgto_Rcto_HIA,DC_HIA))				AS [VALOR DEBITADO (DESPESAS)],				-- Alessandra 03/10/2019  - Removida
	NULL													AS [VALOR SERVIÇOS],
	NULL													AS [PCC 4,655],								-- Alessandra 03/10/2019 - adicionada		
	NULL													AS [IR 1,5%],								-- Alessandra 03/10/2019 - adicionada	
	NULL													AS [VALOR LÍQUIDO],							-- Alessandra 03/10/2019 - adicionada	
	--NULL													AS [VALOR TOTAL (DESPESAS + SERVIÇOS)],		-- Alessandra 03/10/2019  - Removida
	sum(dbo.valor(Vlr_Pgto_Rcto_HIA,DC_HIA))				AS [TOTAL COMISSÃO + DESPESAS],				-- Alessandra 03/10/2019 - adicionada	
	dbo.[fBusca_Tarefa](Num_Proc_HIA,40)					AS [DATA DE ENVIO DA PRESTAÇÃO DE CONTAS],
	ISNULL(dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,5),dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,4))	AS [DI/RE],
	dbo.[fBusca_Docs_PO_Modal](Num_Proc_HIA,2)														AS [INVOICE]	  
from
	 vwCXAS cx with(nolock)
where Num_Lcto in
(select Distinct Num_Lcto from vwcta_Cte cc  with(nolock)
join vwCXAS cx  with(nolock) on cc.Num_Proc_HIA = cx.Num_Proc_HIA 
where cc.Num_Proc_HIA = @Num_Proc) 
and Num_Proc_HIA <>@Num_Proc
group by Num_Proc_HIA

union all
select 'TOTAL', NULL, NULL, NULL,NULL,NULL, NULL,NULL, NULL, NULL, NULL, NULL
union all
select NULL, NULL, NULL, NULL,NULL,NULL, NULL,NULL, NULL, NULL, NULL, NULL
union all
select 'PRESTAÇÕES DE CONTAS:', NULL, NULL,NULL ,NULL,NULL,NULL,NULL, NULL, NULL, NULL, NULL
union all
select NULL, 'SALDO INICIAL:', NULL, NULL,NULL,NULL, NULL,NULL, NULL, NULL, NULL, NULL
union ALL
select NULL, 'DESPESAS:', NULL, NULL,NULL,NULL, NULL,NULL, NULL, NULL, NULL, NULL
union ALL
select NULL, 'SERVIÇOS:', NULL, NULL,NULL,NULL, NULL,NULL, NULL, NULL, NULL, NULL
union ALL
select NULL, 'PCC + IR (6,15%):', NULL, NULL,NULL,NULL, NULL,NULL, NULL, NULL, NULL, NULL
union ALL
select NULL, 'SALDO FINAL:', NULL, NULL,NULL,NULL, NULL,NULL,NULL , NULL, NULL, NULL
  
  
  
--[VALOR SERVIÇOS]  
update T set T.[VALOR SERVIÇOS]=ISNULL(Valor_ARP,0)   
from @Temp T JOIN  
(select FAT.Num_Proc, SUM(FAT.Valor_ARP)Valor_ARP from vwFaturasValidasArg FAT  with(nolock)  
Join vwCliente C with(nolock) on FAT.Num_Proc = C.num_proc and FAT.Cd_Pes_FAT = C.cd_cliente  
group by FAT.Num_Proc) F on T.JOB= F.Num_Proc  

--[PCC 4,655] e [IR 1,5%] -- Alessandra 03/10/2019 - adicionada
update T 
set T.[PCC 4,655]=ISNULL(T.[VALOR SERVIÇOS],0)*0.0465 
,T.[IR 1,5%]=ISNULL(T.[VALOR SERVIÇOS],0) *0.015
from @Temp T
where isnull([JOB],'') not in ('','PRESTAÇÕES DE CONTAS:','TOTAL')

--[VALOR LÍQUIDO] -- Alessandra 03/10/2019 - adicionada
update T 
set T.[VALOR LÍQUIDO]=ISNULL(T.[VALOR SERVIÇOS],0)-ISNULL([PCC 4,655],0)-ISNULL([IR 1,5%],0)
from @Temp T
where isnull([JOB],'') not in ('','PRESTAÇÕES DE CONTAS:','TOTAL')

--[DESPESAS PAGAS] -- Alessandra 03/10/2019 - adicionada
update T 
set T.[DESPESAS PAGAS]=ISNULL(T.[TOTAL COMISSÃO + DESPESAS],0) - ISNULL(T.[VALOR SERVIÇOS],0) + ISNULL([PCC 4,655]+[IR 1,5%],0)
from @Temp T
where isnull([JOB],'') not in ('','PRESTAÇÕES DE CONTAS:','TOTAL')


declare @despesas_pagas DECIMAL(17,2)
set @despesas_pagas = (select SUM(ISNULL([DESPESAS PAGAS],0))	from @Temp T2	where isnull([JOB],'') not in ('','PRESTAÇÕES DE CONTAS:','TOTAL'))

declare @valor_servicos DECIMAL(17,2)
set @valor_servicos = (select SUM(ISNULL([VALOR SERVIÇOS],0))	from @Temp T2	where isnull([JOB],'') not in ('','PRESTAÇÕES DE CONTAS:','TOTAL'))

declare @pcc DECIMAL(17,2)
set @pcc = (select SUM(ISNULL([PCC 4,655],0))	from @Temp T2	where isnull([JOB],'') not in ('','PRESTAÇÕES DE CONTAS:','TOTAL'))

declare @ir DECIMAL(17,2)
set @ir = (select SUM(ISNULL([IR 1,5%],0))	from @Temp T2	where isnull([JOB],'') not in ('','PRESTAÇÕES DE CONTAS:','TOTAL'))

declare @valor_liquido DECIMAL(17,2)
set @valor_liquido = (select SUM(ISNULL([VALOR LÍQUIDO],0))	from @Temp T2	where isnull([JOB],'') not in ('','PRESTAÇÕES DE CONTAS:','TOTAL'))

declare @total_comissao DECIMAL(17,2)
set @total_comissao = (select SUM(ISNULL([TOTAL COMISSÃO + DESPESAS],0))	from @Temp T2	where isnull([JOB],'') not in ('','PRESTAÇÕES DE CONTAS:','TOTAL'))

update T
set [DESPESAS PAGAS] = @despesas_pagas
,[VALOR SERVIÇOS] =@valor_servicos
,[PCC 4,655] =@pcc
,[IR 1,5%] =@ir
,[VALOR LÍQUIDO] = @valor_liquido
,[TOTAL COMISSÃO + DESPESAS] =@total_comissao
from @Temp T
WHERE [JOB] = 'TOTAL' 


update T
set [DESPESAS PAGAS] = @Vlr_Pgto_Rcto
from @Temp T
WHERE [PO] = 'SALDO INICIAL:' 

update T
set [DESPESAS PAGAS] = @despesas_pagas * -1
from @Temp T
WHERE [PO] = 'DESPESAS:'

update T
set [DESPESAS PAGAS] = @valor_servicos * -1
from @Temp T
WHERE [PO] = 'SERVIÇOS:'  

update T
set [DESPESAS PAGAS] = @pcc + @IR
from @Temp T
WHERE [PO] = 'PCC + IR (6,15%):' 

update T
set [DESPESAS PAGAS] = @Vlr_Pgto_Rcto-@despesas_pagas-@valor_servicos+@pcc+ @IR
from @Temp T
WHERE [PO] = 'SALDO FINAL:' 

update T
set [PO] = @Num_Proc
from @Temp T
WHERE [JOB] = 'PRESTAÇÕES DE CONTAS:' 
  
-- Alessandra 03/10/2019  - Removida
--[VALOR TOTAL (DESPESAS + SERVIÇOS)  
--update @Temp set [VALOR TOTAL (DESPESAS + SERVIÇOS)] = [VALOR TOTAL (DESPESAS + SERVIÇOS)] + [VALOR SERVIÇOS]  from @Temp   


select * from @Temp  
GO
