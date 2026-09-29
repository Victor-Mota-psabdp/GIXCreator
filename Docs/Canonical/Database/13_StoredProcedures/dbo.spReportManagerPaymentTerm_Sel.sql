SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spReportManagerPaymentTerm_Sel]
	@Num_Proc	Varchar(16)

as
	select 
		descricao_Termo
	from 
		campo_processo With(nolock) 
		Left Join Termo_Pagamento TM with(nolock) on cd_termo=campo_Dados
	where 
		id_campo=87
		And num_proc=@num_Proc

union all

	select top 1
		descricao_Termo
	from 
		invoice_cliente INV With(nolock) 
		Left Join Termo_Pagamento TM with(nolock) on TM.cd_termo=INV.cd_termo
	where 
		num_proc=@num_Proc


GO
