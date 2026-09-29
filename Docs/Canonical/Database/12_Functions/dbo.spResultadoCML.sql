SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
















CREATE function [dbo].[spResultadoCML]
			(
			@Num_Proc Char(16),
			@DC		  Char(1)

			)

returns
	Float
as
	Begin
		Declare @Valor as Float

		Set @Valor=(select sum(valor) from cml.dbo.clientes_bkp where processo=@num_proc and dc like @DC)

		Return (@Valor)


END

















GO
