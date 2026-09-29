SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pTipoTarifario_Ins 
(
@TptDescricao		VarChar(50) ,
@TptID			Int OUTPUT
)
AS
	Set @TptID = IsNull((Select max(TptID) From Tipo_Tarifario ),0) + 1 
	Insert Into tipo_tarifario (TptID, TptDescricao)  
	Values (@TptID, @TptDescricao )

GO
