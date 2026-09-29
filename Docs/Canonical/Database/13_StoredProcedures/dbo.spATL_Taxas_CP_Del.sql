SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Taxas_CP
CREATE PROCEDURE [dbo].[spATL_Taxas_CP_Del]
(
	@Cd_Tp_Tx		varchar(3),
	@Modal			varchar(2),
	@Cd_Tp_Carga	varchar(1)
)

AS

Begin Transaction

	If  exists (select Modal from Taxas_CP where Modal=@Modal AND Cd_Tp_Tx = @Cd_Tp_Tx AND
	Cd_Tp_Carga = @Cd_Tp_Carga)		
		Begin
			DELETE Taxas_CP Where Modal=@Modal AND Cd_Tp_Tx = @Cd_Tp_Tx AND Cd_Tp_Carga = @Cd_Tp_Carga
		End
	
	

Commit Transaction

GO
