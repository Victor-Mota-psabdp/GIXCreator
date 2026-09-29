SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vwPgtoRctoDiv]

as
select
	Num_Lcto_Div [01 Register Number],
	(case when concil_div = 'S' then 'Closed' else 'Open' end) [02 Status],
	DC_Div [03 DC],convert(datetime,Dt_Pgto_Rcto_Div,103) [04 Date], Conta.Titular [05 Bank Account], Forma_Pgto_Rcto_Div [06 Method], Num_Doc_Div [07 Doc Number], Vlr_Doc_Div [08 Value], P.Apelido [09 Creditor/Debitor], convert(datetime,Dt_Vcto_Div,103) [10 Due Date]
FROM
	Pgto_Rcto_Div PRD
	left join Cta_Cte Conta on PRD.Num_Cta_Cte = Conta.Num_Cta_Cte AND PRD.CD_Banco = Conta.CD_Banco AND PRD.CD_Agencia = Conta.CD_Agencia
	left join Pessoa P on PRD.Cd_Pes = P.Cd_Pes
Where 
	convert(datetime,Dt_Pgto_Rcto_Div,103) > getdate()-180

GO
