SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spLivro_Contabil_Sel]
	@ID int
As
	select 
		ID txtID, ano cmbAno, right('0' + convert(varchar,mes),2) + ' - ' + datename(mm,DateAdd(month,mes,0)-1) cmbMes, numero cmbNumero, convert(varchar,data,103) txtData, 0 txtTotalCredito, 0 txtTotalDebito
	from 
		livro_contabil
	where
		id = @ID and Ativo = 1


GO
