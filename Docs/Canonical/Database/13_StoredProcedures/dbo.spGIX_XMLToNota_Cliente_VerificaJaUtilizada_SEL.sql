SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spGIX_XMLToNota_Cliente_VerificaJaUtilizada_SEL]
(
	@Num_proc		varchar(16),
	@nota_fiscal	varchar(20)
	)
as

select ID_NF from Nota_Cliente with (nolock) 
where num_proc=@num_proc  
and 
right('00000000000000000000' + nota_fiscal,20) =
right('00000000000000000000' + @nota_fiscal,20) 




GO
