SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spControleFatura_Container_InsDel]
(	
	@cd_controlefatura varchar(12),	
	@container varchar(12),
	@lacre varchar(50),
	@active bit,
	@valor float

)
AS

Begin Transaction

		Begin
			if NOT exists(select * from Controle_Fatura_Container where container = @container  and cd_controlefatura = @cd_controlefatura)
				Begin
					Insert into Controle_Fatura_Container
					Values(@cd_controlefatura, @container,@lacre,@active,@valor)
				End
			else
				Update
					Controle_Fatura_Container
				Set
					Lacre = @lacre,
					Active = @active,
					Valor_Container = @valor 								
				where 
					container = @container  and cd_controlefatura = @cd_controlefatura
		End

Commit Transaction


GO
