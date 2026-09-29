SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Bit_to_String]
(
	@Tipo		char(2), -- S = Semana , M = Mês, DM = Dias do Mês
	@Reference 	varchar(31)	
)

RETURNS VarChar(200)

AS

	BEGIN

		Declare @StrRetorno varchar(200)

		set @StrRetorno = ''

		If @Tipo = 'W' and len(@Reference) > 0

			Begin
				
				If substring(@Reference, 1, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'Sunday, '

				If substring(@Reference, 2, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'Monday, '

				If substring(@Reference, 3, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'Tuesday, '

				If substring(@Reference, 4, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'Wednesday, '

				If substring(@Reference, 5, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'Thursday, '
				
				If substring(@Reference, 6, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'Friday, '

				If substring(@Reference, 7, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'Saturday, '
			End

		If @Tipo = 'M' and len(@Reference) > 0

			Begin
				If substring(@Reference, 1, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'January, '

				If substring(@Reference, 2, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'February, '

				If substring(@Reference, 3, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'March, '

				If substring(@Reference, 4, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'April, '

				If substring(@Reference, 5, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'May, '
				
				If substring(@Reference, 6, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'June, '

				If substring(@Reference, 7, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'July, '

				If substring(@Reference, 8, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'August, '

				If substring(@Reference, 9, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'September, '

				If substring(@Reference, 10, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'October, '

				If substring(@Reference, 11, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'November, '

				If substring(@Reference, 12, 1) = '1'
					Set @StrRetorno =  @StrRetorno + 'December, '
			End

		If @Tipo = 'DM' and len(@Reference) > 0

			Begin
				declare @i as int
				set @i = 1
				while @i <=31
					begin
						If substring(@Reference, @i, 1) = '1'
							Set @StrRetorno =  @StrRetorno + cast(@i as varchar) + ', '
						set @i = @i + 1
					end
			End

		if len(@StrRetorno) > 1
			Set @StrRetorno = left(@StrRetorno, len(@StrRetorno)-1)

		Return @StrRetorno

	END


















GO
