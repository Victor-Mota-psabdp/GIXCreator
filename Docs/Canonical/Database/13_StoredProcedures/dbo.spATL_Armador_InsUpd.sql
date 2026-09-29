SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
alter table armador add dt_criacao datetime
select * from armador where SCAC is NOT null  
alter table armador drop column cd_pes 
alter table armador drop constraint FK_Armador_Pessoa
ALTER table [dbo].[Armador] add [Booking_Request] bit NULL
*/

--sp_help Armador
CREATE procedure [dbo].[spATL_Armador_InsUpd]
(	
	@Cd_Armador			varchar(3),
	@Nome_Armador		varchar(30),
	@Cd_Arm_Ofc			varchar(4),
	@SCAC				varchar(4),
	@CNPJ				varchar(15),
	@FreeTime			int,
	@Cd_Termo			int,
	@GIX_Armador		bit,
	@dt_criacao			datetime,
	@SAP_Code			varchar(30),
	@Booking_Request	bit
)

AS

Begin Transaction

	If  exists (select Cd_Armador from Armador where Cd_Armador=@Cd_Armador)
		Begin
			Update
				Armador
			Set
				Cd_Armador=@Cd_Armador,
				Nome_Armador=@Nome_Armador,
				Cd_Arm_Ofc=@Cd_Arm_Ofc,
				scac = @scac,
				CNPJ = @CNPJ,
				FreeTime = @FreeTime,
				Cd_Termo = @Cd_Termo,
				GIX_Armador = @GIX_Armador,
				SAP_Code = @SAP_Code
				--,dt_criacao = getdate()
				,Booking_Request=@Booking_Request
			Where
				Cd_Armador=@Cd_Armador
		End
	Else
		Insert into Armador
		(
			Cd_Armador,Nome_Armador,Cd_Arm_Ofc,scac,CNPJ,FreeTime,Cd_Termo,GIX_Armador,SAP_Code,dt_criacao,Booking_Request
		)
		Values
		(
			@Cd_Armador,@Nome_Armador, @Cd_Arm_Ofc,@scac,@CNPJ,@Freetime,@Cd_Termo,@GIX_Armador,@SAP_Code,getdate(),@Booking_Request
		)
	

Commit Transaction

GO
