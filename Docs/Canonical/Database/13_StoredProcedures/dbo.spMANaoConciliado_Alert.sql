SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spMANaoConciliado_Alert

AS


select 'Data  ','Numero do MA','Cta.Cte','DC','Valor','Histórico'
select '--------------------------------------------------------------------------------------------------------------'
select dt_pgto_rcto_mov Data,num_lcto_mov Num_LCTO,num_cta_cte Cta_Cte,Dc_mov DC,vlr_doc_mov Valor,historico from atlantis.dbo.mvto_Cta_cte
where
	concil_mov='N' and convert(Datetime,dt_pgto_rcto_mov,105)>='01-01-2009'
	and convert(Datetime,dt_pgto_rcto_mov,105) <=getdate()-2
order by 
	convert(Datetime,dt_pgto_rcto_mov,105) desc

GO
