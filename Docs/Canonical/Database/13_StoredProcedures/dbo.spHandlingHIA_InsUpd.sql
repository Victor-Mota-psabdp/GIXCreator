SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure  [dbo].[spHandlingHIA_InsUpd]
	
	@Processo	varchar (16),
	@Handling	varchar(1000)
as

--TRATAMENTO PARA A TABELA Handling_Hea
	
	If  exists (select Num_Proc_hia from handling_hia where Num_Proc_hia=@Processo)
		Begin
			Update
				handling_hia
			Set
				Hand_Hia_1 	= @Handling		
			Where
				Num_Proc_Hia	= @Processo
		end
	Else
		Begin
			Insert Into
				handling_hia
				(
					Num_Proc_Hia,
					Hand_hia_1
				)
			Values
				(
					@Processo, 
					@Handling
				)
		end




GO
