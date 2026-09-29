SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spCtaCteTitular_Rel]
(
@Local varchar(3)
)
As

	If @Local = 'BR'
		Begin
			select titular from cta_cte where titular like 'Banco%'
		End
	Else
		Begin
			select titular from cta_cte 
		End		

GO
