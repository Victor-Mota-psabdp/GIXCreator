SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pTipoTarifRangMar_InsUpd
(
@TptID			Int, 
@Cd_Tp_Cont		varchar(3),
@TtmFator		char(1), 
@TtmValor		float
)
AS
	If not exists(Select * From Tipo_Tarif_Rang_Mar Where TptID = @TptID and Cd_Tp_Cont = @Cd_Tp_Cont) 
		Begin 
			Insert Into Tipo_Tarif_Rang_Mar (TptID, Cd_Tp_Cont, TtmFator, TtmValor)
			Values  (@TptID, @Cd_Tp_Cont, @TtmFator, @TtmValor)

		end 
	Else
		Begin 
			Update  
				Tipo_Tarif_Rang_Mar
			Set 
				TtmFator = @TtmFator , 
				TtmValor = @TtmValor
			Where 
				TptID = @TptID and 
				Cd_Tp_Cont  = @Cd_Tp_Cont
		End
GO
