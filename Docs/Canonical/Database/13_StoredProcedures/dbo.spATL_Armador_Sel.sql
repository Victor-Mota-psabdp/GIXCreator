SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Armador
CREATE PROCEDURE [dbo].[spATL_Armador_Sel]
	@Cd_Armador varchar(3),
	@Nome_Armador varchar(30),
	@Tipo char(1)
	
as



if @Tipo = 'A' or @Tipo = 'B'
	Begin
		SELECT
			Cd_Armador		[Code],
			Nome_Armador	[Carrier Name] ,
			Cd_Arm_Ofc		[Oficial Code],
			SCAC			[SCAC],
			CNPJ			[CNPJ/CUIT],
			A.cd_termo		[Term Container Code],
			T.Empresa		[Term Container],
			SAP_Code		[SAP Code],
			FreeTime		[Free Time],
			GIX_Armador		[GIX],
			dt_criacao		[Created Date]
			,Booking_Request [Booking Request]
		FROM 
			Armador A with(nolock)
			left JOIN Termo_Container T with(nolock) on A.cd_termo = T.Cd_Termo
		WHERE
			Cd_Armador <> '0'
	End

if @Tipo = 'C' or @Tipo = 'D'
	Begin
		SELECT
			Cd_Armador		[Code],
			Nome_Armador	[Carrier Name] ,
			Cd_Arm_Ofc		[Oficial Code],
			SCAC			[SCAC],
			CNPJ			[CNPJ/CUIT],
			A.cd_termo		[Term Container Code],
			T.Empresa		[Term Container],
			SAP_Code		[SAP Code],
			FreeTime		[Free Time],
			GIX_Armador		[GIX],
			dt_criacao		[Created Date]
			,Booking_Request [Booking Request]
		FROM 
			Armador A with(nolock)
			left JOIN Termo_Container T with(nolock) on A.cd_termo = T.Cd_Termo
		where 
			Cd_Armador = @Cd_Armador AND Cd_Armador <> '0'
	End	
	
if @Tipo = 'N' or @Tipo = 'O'
	Begin
		SELECT
			Cd_Armador		[Code],
			Nome_Armador	[Carrier Name] ,
			Cd_Arm_Ofc		[Oficial Code],
			SCAC			[SCAC],
			CNPJ			[CNPJ/CUIT],
			A.cd_termo		[Term Container Code],
			T.Empresa		[Term Container],
			SAP_Code		[SAP Code],
			FreeTime		[Free Time],
			GIX_Armador		[GIX],
			dt_criacao		[Created Date]
			,Booking_Request [Booking Request]
		FROM 
			Armador A with(nolock)
			left JOIN Termo_Container T with(nolock) on A.cd_termo = T.Cd_Termo
		where 
			Nome_Armador = @Nome_Armador
			AND Cd_Armador <> '0'
	End
	
	
if @Tipo = 'Z' --or @Tipo = 'O'
	Begin
		SELECT
			Cd_Armador		[Code],
			Nome_Armador	[Carrier Name] ,
			Cd_Arm_Ofc		[Oficial Code],
			SCAC			[SCAC],
			CNPJ			[CNPJ/CUIT],
			A.cd_termo		[Term Container Code],
			T.Empresa		[Term Container],
			SAP_Code		[SAP Code],
			FreeTime		[Free Time],
			GIX_Armador		[GIX],
			dt_criacao		[Created Date]
			,Booking_Request [Booking Request]
		FROM 
			Armador A with(nolock)
			left JOIN Termo_Container T with(nolock) on A.cd_termo = T.Cd_Termo
		where
			Nome_Armador = @Nome_Armador and Cd_Armador <> @Cd_Armador			
	End

GO
