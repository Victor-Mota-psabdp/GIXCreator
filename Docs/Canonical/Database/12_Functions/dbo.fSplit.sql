SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Texto para Vetor 
CREATE FUNCTION [dbo].[fSplit]
(
	@Texto varchar(max), 
	@Delimitador char(1)
) 
	RETURNS @Resultado TABLE (item varchar(1000))

	Begin

		Declare @Parte varchar(1000)

		While CHARINDEX(@Delimitador,@Texto,0) <> 0
			Begin
				SELECT
					@Parte=RTRIM(LTRIM(SUBSTRING(@Texto,1,CHARINDEX(@Delimitador,@Texto,0)-1))),
					@Texto=RTRIM(LTRIM(SUBSTRING(@Texto,CHARINDEX(@Delimitador,@Texto,0)+LEN(@Delimitador),LEN(@Texto))))

					IF LEN(@Parte) > 0
					INSERT INTO @Resultado SELECT @Parte
				END

				IF LEN(@Texto) > 0
					INSERT INTO @Resultado SELECT @Texto
				RETURN
		END





GO
