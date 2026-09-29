SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Armador
CREATE VIEW [dbo].[vwATL_Armador_Sel]
AS
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

GO
