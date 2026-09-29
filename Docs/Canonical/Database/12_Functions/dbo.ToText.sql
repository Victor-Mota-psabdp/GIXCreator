SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE FUNCTION ToText 
(
@Number 	Decimal(16,2)
)
RETURNS VarChar(20) 
AS  
	BEGIN 
		Declare @Cont		Int 
		Declare @Milhar		VarChar(16) 
		Declare @StrMilhar	VarChar(20) 
		Declare @Negativo	bit 
		If @Number Is Null 
			Return Null 			
		Set @StrMilhar = '' 

		If @Number < 0 
			Begin 
				Set @Negativo = 1 
				Set @Number= @Number * (-1)
			End 
		Else 
			Set @Negativo = 0 

		Set @Cont = Len(@Number) - 3 

		Set @Milhar = Substring(Cast(@Number as VarChar(20)),  1, @Cont) 
		While @Cont <> 0 
			Begin 
				If Len(@StrMilhar) = 3 or Len(@StrMilhar) = 7 or Len(@StrMilhar) =  11 or Len(@StrMilhar) =  15 
					Set @StrMilhar = '.' + @StrMilhar 
				Else
					Begin 
						Set @StrMilhar = Substring(@Milhar, @Cont,1)  + @StrMIlhar 
						Set @Cont = @Cont - 1 
					End 
			End 
		Set @StrMilhar = @StrMilhar + ',' + Right(@Number, 2)
		If @Negativo = 1 
			Set @StrMilhar = '-' +@StrMilhar

		Return @StrMilhar

	END










GO
