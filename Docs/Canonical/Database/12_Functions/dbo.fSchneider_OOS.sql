SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[fSchneider_OOS]
(
	@TTS INT
)

RETURNS VarChar(15)

AS

	BEGIN

		Declare @StrRetorno varchar(15)
		set @StrRetorno = ''

		SET @StrRetorno = CASE WHEN @TTS = 0 THEN 'Out of Scope' ELSE CONVERT(VARCHAR(15),@TTS) END

		Return @StrRetorno

	END


















GO
