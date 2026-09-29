SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vwLivro_Contabil]
as
select 
	L.ID [01 ID], convert(varchar,L.ano) [02 Year], convert(varchar,L.mes) [03 Month], L.numero [04 Number], L.Data [05 Date], I.Item [06 Item], I.job [07 BDP Ref.], I.valor [08 Value],
	contaCredito [09 Account Credit], contaDebito [10 Account Debito], historico [11 Historic], historico2 [12 Historic 2]
from 
	livro_contabil L
	left join livro_contabil_item I on I.id = L.id
where
	ativo = 1

GO
