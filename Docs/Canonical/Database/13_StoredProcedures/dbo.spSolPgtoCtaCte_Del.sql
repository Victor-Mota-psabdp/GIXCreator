SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--alterado 17/5/2017 - cadu
CREATE procedure [dbo].[spSolPgtoCtaCte_Del]

	@ID				bigint,
	@Solicitante	varchar(50)


as

	Declare @Cd_Solicitante	varchar(6)

	
	set @Cd_Solicitante = (Select Cd_usuario from Usuario where Nome_Usuario = @Solicitante)

		update 
			Sol_Pgto_Cta_Cte 
			set
				--Cd_Solicitante = @Cd_Solicitante,
				Cd_Gerente= @Cd_Solicitante,				
				Dt_Ins = GETDATE(),
				[Status] = 0
			where ID = @ID
		

	
	

GO
