SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[vwPgtoRcto]

as
Select	
		Num_Lcto [01 Register Number],
		(case when concil = 'S' then 'Closed' else 'Open' end) [02 Status],
		DC [03 DC], convert(datetime,Dt_Pgto_Rcto,103) [04 Date], Conta.Titular [05 Bank Account], P.Apelido [06 Creditor/Debitor], Num_Doc [07 Doc Number], Forma_Pgto_Rcto [08 Method], Vlr_Doc [09 Value], convert(datetime,Dt_vcto,103) [10 Due Date], cc.nome_centro_custo [11 Cost Center]
	From
		PGTO_RCTO PR
		left join Cta_Cte Conta on PR.Num_Cta_Cte = Conta.Num_Cta_Cte AND PR.CD_Banco = Conta.CD_Banco AND PR.CD_Agencia = Conta.CD_Agencia
		left join Pessoa P on PR.Cd_Pes = P.Cd_Pes
		left join Centro_Custo CC on cc.cd_centro_custo = pr.cd_centro_custo
	Where
		convert(datetime,Dt_Pgto_Rcto,103) > getdate()-365
--	order by
--		convert(datetime,Dt_Pgto_Rcto,103)

GO
