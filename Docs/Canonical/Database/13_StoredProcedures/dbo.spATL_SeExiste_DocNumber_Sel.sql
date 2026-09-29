SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spATL_SeExiste_DocNumber_Sel]--'CADU123'
(
	@Doc_Number varchar(60)
)
as
	select ID
		from sol_pgto_cta_cte 
	where Doc_Number = @Doc_Number
	and Status_Aprovacao <> 'A' and Status = 1

GO
