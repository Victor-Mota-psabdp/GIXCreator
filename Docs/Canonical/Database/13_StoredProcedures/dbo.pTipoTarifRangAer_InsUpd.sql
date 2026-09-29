SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE pTipoTarifRangAer_InsUpd
(
@TptID			Int, 
@TtaFator		char(1),
@TtaMin		float, 
@Tta0			float,
@Tta45			float,
@Tta100		float,
@Tta300		float,
@Tta500		float,
@Tta1000		float,
@Tta2000		float 

)
AS
	If not exists(Select * From Tipo_Tarif_Rang_Aer Where TptID = @TptID) 
		Begin 
			Insert Into Tipo_Tarif_Rang_Aer (TptID, TtaFator, TtaMin, Tta0, Tta45, Tta100, Tta300, Tta500, Tta1000, Tta2000)
			Values (@TptID, @TtaFator, @TtaMin, @Tta0, @Tta45, @Tta100, @Tta300, @Tta500, @Tta1000, @Tta2000)
		end 
	Else
		Begin 
			Update  
				Tipo_Tarif_Rang_Aer
			Set 
				TtaFator = @TtaFator, 
				TtaMin = @TtaMin, 
				Tta0 = @Tta0, 
				Tta45 = @Tta45, 
				Tta100 = @Tta100, 
				Tta300 = @Tta300, 
				Tta500 = @Tta500, 
				Tta1000 = @Tta1000,
				Tta2000 = @Tta2000
			Where 
				TptID = @TptID 
		End
GO
