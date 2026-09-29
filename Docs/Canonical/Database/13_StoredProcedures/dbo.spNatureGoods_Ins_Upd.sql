SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  procedure  [dbo].[spNatureGoods_Ins_Upd]
	
	@Processo	varchar (16),
	@Descr		varchar(3000),
	@Header		varchar(200)
as

--TRATAMENTO PARA A TABELA Natures_Goods
	
	If  exists (select Num_Proc from Nature_Goods where Num_Proc=@Processo)
		Begin
			Update
				Nature_Goods
			Set
				Descr 	= @Descr,
				Header = @Header		
			Where
				Num_Proc	= @Processo
		end
	Else
		Begin
			Insert Into
				Nature_Goods
				(
					Num_Proc,
					Descr,
					Header
				)
			Values
				(
					@Processo, 
					@Descr,
					@Header
				)
		end

IF @@Error <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
	END
GO
