SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Nature_Goods
CREATE procedure [dbo].[spATL_Nature_Goods_Del]
(
	@Num_Proc varchar(16)
)

as

If  exists (select Num_Proc from Nature_Goods where Num_Proc=@Num_Proc)
	Begin
		delete Nature_Goods where Num_Proc=@Num_Proc
	End

GO
