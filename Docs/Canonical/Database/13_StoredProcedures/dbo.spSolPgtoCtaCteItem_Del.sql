SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spSolPgtoCtaCteItem_Del]
	@ID	bigint,
	@ID_Item	int
as

Delete Sol_Pgto_Cta_Cte_Item where Id = @ID and ID_Item = @ID_Item
GO
