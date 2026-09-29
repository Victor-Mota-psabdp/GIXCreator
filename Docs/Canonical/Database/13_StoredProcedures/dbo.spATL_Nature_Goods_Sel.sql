SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Nature_Goods
Create PROCEDURE [dbo].[spATL_Nature_Goods_Sel]
(
	@Num_Proc varchar(16),
	@Tipo char(1)
)
	
as

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			Num_Proc				[JOB],
			Descr				[Description & Goods],
			Header			[Description & Goods Header]					
		FROM 
			Nature_Goods A with(nolock)
		where 
			Num_Proc = @Num_Proc
	End	
	

	
	

GO
