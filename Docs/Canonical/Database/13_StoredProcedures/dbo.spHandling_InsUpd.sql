SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



create procedure  spHandling_InsUpd
	
	@Processo	varchar (16),
	@Handling	varchar(1000)
as

--TRATAMENTO PARA A TABELA Handling_Hea
	
	If  exists (select Num_Proc_hea from handling_hea where Num_Proc_hea=@Processo)
		Begin
			Update
				handling_hea
			Set
				Hand_Hea_1 	= @Handling		
			Where
				Num_Proc_Hea	= @Processo
		end
	Else
		Begin
			Insert Into
				handling_hea
				(
					Num_Proc_Hea,
					Hand_hea_1
				)
			Values
				(
					@Processo, 
					@Handling
				)
		end



GO
