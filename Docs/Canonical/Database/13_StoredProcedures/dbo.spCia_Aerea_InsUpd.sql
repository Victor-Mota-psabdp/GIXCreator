SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
select * from cia_aerea where SCAC is NOT null  
alter table cia_aerea drop column cd_pes 
alter table cia_aerea drop constraint FK_Cia_Aerea_Pessoa
EXEC sp_rename 'spCiaAerea_InsUpd', 'spCia_Aerea_InsUpd'
*/
CREATE procedure [dbo].[spCia_Aerea_InsUpd]

	@Cd_Cia_Aer varchar(3),
	@Nome_Cia_Aer varchar(30),
	@SCAC varchar(4),
	@Iata_code varchar(25),
	@dt_criacao datetime

AS

Begin Transaction

	If  exists (select Cd_Cia_Aer from Cia_Aerea where Cd_Cia_Aer=@Cd_Cia_Aer)
	Begin
		Update
			Cia_Aerea
		Set
			Nome_Cia_Aer=@Nome_cia_aer,
			SCAC=@SCAC,
			Iata_code = @Iata_code,
			dt_criacao = getdate()
		Where
			Cd_Cia_Aer=@Cd_Cia_Aer
	End
	Else
		Insert
			Cia_Aerea
					(
					Cd_Cia_Aer,
					Nome_Cia_Aer,
					SCAC,
					dt_criacao,
					Iata_code
					)
		Values
					(
					@Cd_Cia_Aer,
					@Nome_cia_aer,
					@SCAC,
					getdate(),
					@Iata_code
					)
	
Commit Transaction



GO
