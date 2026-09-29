SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[VerParidade]
(
@Date		VarChar(10),
@Moeda	Char(3),
@TpPar	Char(3)
)
RETURNS VarChar(10) 
AS  
	BEGIN 
		Declare @DtRefer	Datetime 
		Declare @Paridade	decimal(10,6) 
		Declare @Cont		Int 
		Set @DtRefer = convert(datetime, @Date, 105) 
		Set @Cont = 0 
		set @paridade=0
		If @Moeda = 'REL'
			set @Paridade = 1
		Else
			Begin 
				While @Paridade = 0 or @Paridade = null 
					Begin 
						Set @Cont = @Cont + 1 
						Set @Paridade = IsNull((Select Par_Moeda From Paridade Where Dt_Par = dbo.strhoje(@DtRefer) and Cd_Tp_Par = @TpPar and Cd_Tp_Moeda = @Moeda  ), 0)
						Set @DtRefer = dateadd(day, -1, @DtRefer)
						Set @DtRefer = @DtRefer-1
						If @Cont> 50 

							Begin 
								Set @Cont = 0 
								Set @TpPar = 'OFC'
								Set @Paridade=1			
							End 
					End 
			End 				
			

		Return @Paridade

	END














GO
