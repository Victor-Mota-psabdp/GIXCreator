SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE FUNCTION pontoToVirg
(
@Number 	Decimal(16,2)
)
RETURNS VarChar(20) 
AS  
	BEGIN 
		Declare @Cont		Int 
		Declare @Milhar		VarChar(16) 
		Declare @StrNumber	VarChar(20) 
		Declare @StrRetorno	VarChar(20) 
		Declare @Negativo	bit 
		If @Number Is Null 
			Return Null 			
		Set @StrNumber = cast(@Number as varchar(20))

		Set @Cont = Len(@StrNumber) 
		Set @StrRetorno = ''
		While @Cont <> 0 
			Begin 
			
				If substring(@StrNumber, @cont, 1) = '.'
					Set @StrRetorno = ',' + @StrRetorno 
				Else
					Set @StrRetorno = substring(@StrNumber, @cont, 1) + @StrRetorno 
				
				SET @Cont = @Cont - 1
			End 

		Return @StrRetorno

	END











GO
