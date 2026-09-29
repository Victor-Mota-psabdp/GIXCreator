SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_TranfRefer_Ins]
(
@Num_ProcReal Varchar(16),
@NumeroPO	varchar(80),
@DataPO	datetime,
@IDDC	int,
@CdUsuario	varchar(10)
)
as

If SUBSTRING(@Num_ProcReal,1,2) = 'IM'
	Begin
		exec dbo.spATL_POHIM_InsUpd NULL, @NumeroPO, @DataPO, @Num_ProcReal,@IDDC,@CdUsuario
	End
	
If SUBSTRING(@Num_ProcReal,1,2) = 'IA'
	Begin
		exec dbo.spATL_POHIA_InsUpd NULL, @NumeroPO, @DataPO, @Num_ProcReal,@IDDC,@CdUsuario
	End
	
If SUBSTRING(@Num_ProcReal,1,2) = 'IO'
	Begin
		exec dbo.spATL_POHIO_InsUpd NULL, @NumeroPO, @DataPO, @Num_ProcReal,@IDDC,@CdUsuario
	End






GO
