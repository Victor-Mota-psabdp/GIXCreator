SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--spaTL_CashFlowLoad_Sel  '%Adiantamento%', '%', '%'
create procedure [dbo].[spaTL_CashFlowLoad_Sel](
	
	@ChargeName varchar(50),
	@ChargeCode varchar(50),
	@TypeCashFlow varchar(50)

)

as

	select TT.Cd_Tp_Tx,TT.Nome_Tp_Tx,TT.Nome_Tp_Tx_Ing, TC.ID_TypeExpense,TYC.Type_Expense from Tipo_Taxa TT with(nolock)
	left join Taxa_CashFlow TC with(nolock) on TT.Cd_Tp_Tx = TC.Cd_Tp_Tx
	left join Type_Expense TYC with(nolock) on TC.ID_TypeExpense = TYC.ID_TypeExpense
	where  TT.Cd_Tp_Tx like @ChargeCode and TT.Nome_Tp_Tx like @ChargeName and isnull(TYC.Type_Expense,'') like @TypeCashFlow and  TT.Desat_Tx = 'N' order by Nome_Tp_Tx
	
	
	
GO
