SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pEvento_Ins 
(
@Arquivo_EVE			varchar(25),
@Tp_Evento			varchar(5),
@Sb_Tp_Evento		char(1)=Null,
@Dt_Geracao			datetime=Null,
@Dt_Envio			datetime=Null,
@Status_EVE			char(1)=Null,
@Cd_Usuario			varchar(10)=Null
)
AS
	If @Dt_Envio <> Null
		Set @Dt_Envio = GetDate()
	Insert Into 	
		Eventos
		(Arquivo_EVE, Tp_Evento, Sb_Tp_Evento, Dt_Geracao, Dt_Envio, Status_EVE, Cd_Usuario) 
	Values 
		(@Arquivo_EVE, @Tp_Evento, @Sb_Tp_Evento, @Dt_Geracao, @Dt_Envio, @Status_EVE, @Cd_Usuario)



GO
