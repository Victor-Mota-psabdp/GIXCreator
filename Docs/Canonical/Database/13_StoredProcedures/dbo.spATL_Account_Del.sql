SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spATL_Account_Del](
	@id_Account			INT
)
as
	delete Account Where id_Account = @id_Account

GO
