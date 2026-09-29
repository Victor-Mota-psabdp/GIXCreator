SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT DBO.fSchneider_split_Container_tp('20ft - Dry Van','-','S')
--SELECT DBO.fSchneider_split_Container_tp('20ft - Dry Van','-','T')


--GO

create FUNCTION [dbo].[fSchneider_split_Container_tp]
(
	@Nome_Tp_Cont	varchar(30)
	,@delimiter 		char(1)
	,@Tipo				char(1) -- S ou T. S=Size T = type
)

RETURNS VarChar(30)

AS

	BEGIN

		Declare @StrRetorno varchar(30)

		set @StrRetorno = ''

		IF CHARINDEX('-',@Nome_Tp_Cont) <> 0
			BEGIN
				If @Tipo = 'S' -- SIZE
					Begin
						set @StrRetorno = SUBSTRING(@Nome_Tp_Cont,1,CHARINDEX('-',@Nome_Tp_Cont)-1)
						set @StrRetorno = replace(@StrRetorno,'ft','''')
						--set @StrRetorno = replace(@StrRetorno,'ft','')
						set @StrRetorno = LTRIM(RTRIM(@StrRetorno))
					END
				If @Tipo = 'T' -- Type
					Begin
						set @StrRetorno = SUBSTRING(@Nome_Tp_Cont,(CHARINDEX('-', @Nome_Tp_Cont)+1),LEN(@Nome_Tp_Cont)-CHARINDEX('-', @Nome_Tp_Cont)+1)
						set @StrRetorno = LTRIM(RTRIM(@StrRetorno))

						set @StrRetorno =
						CASE 
							WHEN @StrRetorno = 'Dry Van' THEN  'Dry'
							WHEN @StrRetorno = 'High Cube' THEN 'HC'
					
							ELSE @StrRetorno
						END

					END
			END
		ELSE
			BEGIN
				set @StrRetorno = ''
			END



		Return @StrRetorno

	END


















GO
