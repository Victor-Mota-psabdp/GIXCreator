SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Nature_Goods
CREATE  procedure  [dbo].[spATL_Nature_Goods_InsUpd]
(
	
	@Num_Proc	varchar (16),
	@Descr		varchar(3000),
	@Header		varchar(200)
)

as


	If  exists (select Num_Proc from Nature_Goods where Num_Proc=@Num_Proc)
		Begin
			Update
				Nature_Goods
			Set
				Descr 	= @Descr,
				Header = @Header		
			Where
				Num_Proc = @Num_Proc
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
					@Num_Proc, 
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
