SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Endereco
CREATE procedure [dbo].[spATL_Endereco_Del]
(
		@Cd_Pes			varchar(10),
		@Cd_Tp_End		varchar(3)
)
as
	DELETE Endereco  where CD_PES =@Cd_Pes AND Cd_Tp_End= @Cd_Tp_End

GO
