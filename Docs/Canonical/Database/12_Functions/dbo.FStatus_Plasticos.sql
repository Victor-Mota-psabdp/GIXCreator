SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE     function [dbo].[FStatus_Plasticos]( 
				@Processo varchar(16),
				@Hoje	datetime
)
RETURNS Varchar(20)

BEGIN
		Declare @Resultado Varchar(20)
		if (select dbo.fBusca_Historico(@Processo,54,@hoje)) is not null 
			Begin
				Return('ALTERADA')
			End
		else
			Begin
				Return ('NÃO ALTERADA')
			End
		return ('NÃO ALTERADA')

END













GO
